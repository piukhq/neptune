//
//  Wallet.swift
//  LocalHero
//
//  Created by Sean Williams on 24/02/2022.
//

import Foundation

class Wallet: WalletServiceProtocol, CoreDataRepositoryProtocol {
    private enum FetchType {
        case localLaunch // Specifically used on launch to perform desired behaviour not needed at any other time
        case localReactive // Any local fetch other than on launch
        case reload // A fetch from the API
    }
    
    private (set) var loyaltyPlans: [CD_LoyaltyPlan]?
    private (set) var paymentAccounts: [CD_PaymentAccount]?
    private (set) var loyaltyCards: [CD_LoyaltyCard]?
    private var hasLaunched = false

    
    // MARK: - Public

    func launch(completion: @escaping ServiceCompletionSuccessHandler<WalletServiceError>) {
        loadWalletData(forType: .localLaunch, reloadPlans: false, isUserDriven: false) { [weak self] _, _ in
            self?.loadWalletData(forType: .reload, reloadPlans: true, isUserDriven: false) { success, error in
                completion(success, error)
                self?.hasLaunched = true
            }
        }
    }
    
    func refreshLocal(completion: EmptyCompletionBlock? = nil) {
        loadWalletData(forType: .localReactive, reloadPlans: false, isUserDriven: false) { success, _ in
            guard success else { return }
            completion?()
        }
    }
    
    
    // MARK: - Private

    private func loadWalletData(forType type: FetchType, reloadPlans: Bool, isUserDriven: Bool, completion: ServiceCompletionSuccessHandler<WalletServiceError>? = nil) {
        let walletDispatchGroup = DispatchGroup()
        let forceAPIRefresh = type == .reload
        
        if forceAPIRefresh {
            // Get remote config
        }
        
        walletDispatchGroup.enter()
        getLoyaltyPlansAndWallet(forceAPIRefresh: forceAPIRefresh, reloadPlans: reloadPlans, isUserDriven: isUserDriven) { success, error in
            guard success else {
                completion?(success, error)
                return
            }
            
            walletDispatchGroup.leave()
        }
        
        walletDispatchGroup.notify(queue: .main) {
            NotificationCenter.default.post(name: type == .reload ? .didLoadWallet : .didLoadLocalWallet, object: nil)
            completion?(true, nil)
        }
    }
    
    private func getLoyaltyPlansAndWallet(forceAPIRefresh: Bool = false, reloadPlans: Bool, isUserDriven: Bool, completion: @escaping ServiceCompletionSuccessHandler<WalletServiceError>) {
        loadLoyaltyPlans(forceRefresh: reloadPlans, isUserDriven: isUserDriven) { [weak self] success, error in
            guard success else {
                completion(success, error)
                return
            }
            
            self?.loadWallet(forceAPIRefresh: forceAPIRefresh, isUserDriven: isUserDriven, completion: { success, error in
                completion(success, error)
            })
        }
    }
    
    private func loadWallet(forceAPIRefresh: Bool = false, isUserDriven: Bool, completion: @escaping ServiceCompletionSuccessHandler<WalletServiceError>) {
        guard forceAPIRefresh else {
            loadCoreDataPaymentAndLoyaltyAccounts {
                completion(true, nil)
            }
            return
        }
        
        getWalletFromAPI(isUserDriven: false) { [weak self] result in
            switch result {
            case .success(let response):
                self?.mapCoreDataObjects(objectsToMap: [response], type: CD_Wallet.self, completion: {
                    self?.loadCoreDataPaymentAndLoyaltyAccounts {
                        completion(true, nil)
                    }
                })
            case .failure(let error):
                completion(false, error) 
            }
        }
    }
    
    private func loadCoreDataPaymentAndLoyaltyAccounts(completion: @escaping EmptyCompletionBlock) {
        let coreDataDispatchGroup = DispatchGroup()

        coreDataDispatchGroup.enter()
        fetchCoreDataObjects(forObjectType: CD_PaymentAccount.self) { [weak self] paymentAccounts in
            guard let self = self else { return }
            self.paymentAccounts = paymentAccounts
            self.applyLocalWalletOrder(&self.localPaymentCardsOrder, to: paymentAccounts, updating: &self.paymentAccounts)
            coreDataDispatchGroup.leave()
        }
        
        coreDataDispatchGroup.enter()
        fetchCoreDataObjects(forObjectType: CD_LoyaltyCard.self) { [weak self] loyaltyCards in
            guard let self = self else { return }
            self.loyaltyCards = loyaltyCards
            self.applyLocalWalletOrder(&self.localLoyaltyCardsOrder, to: loyaltyCards, updating: &self.loyaltyCards)
            coreDataDispatchGroup.leave()
        }
        
        coreDataDispatchGroup.notify(queue: .main) {
            completion()
        }
    }
    
    private func loadLoyaltyPlans(forceRefresh: Bool = false, isUserDriven: Bool, completion: @escaping ServiceCompletionSuccessHandler<WalletServiceError>) {
        guard forceRefresh else {
            self.fetchCoreDataObjects(forObjectType: CD_LoyaltyPlan.self) { [weak self] localPlans in
                self?.loyaltyPlans = localPlans
                completion(true, nil)
            }
            return
        }
        getLoyaltyPlans(isUserDriven: isUserDriven, completion: { [weak self] result in
            switch result {
            case .success(let response):
                guard let self = self else { return }
                self.mapCoreDataObjects(objectsToMap: response, type: CD_LoyaltyPlan.self) {
                    self.fetchCoreDataObjects(forObjectType: CD_LoyaltyPlan.self) { loyaltyPlans in
                        self.loyaltyPlans = loyaltyPlans
                        completion(true, nil)
                    }
                }
            case .failure(let error):
                guard let localPlans = self?.loyaltyPlans, !localPlans.isEmpty else {
                    completion(false, error)
                    return
                }
                completion(true, nil)
            }
        })
    }
    
    func handleLogout() {
        hasLaunched = false
        loyaltyCards = nil
        paymentAccounts = nil
    }
}


// MARK: - Wallet Ordering

extension Wallet {
    enum WalletType: String, Codable {
        case loyalty
        case payment
    }
    
    private var localPaymentCardsOrder: [String]? {
        get {
            return getLocalWalletOrder(for: .payment)
        }
        set {
            setLocalWalletOrder(newValue, for: .payment)
        }
    }
    
    private var localLoyaltyCardsOrder: [String]? {
        get {
            return getLocalWalletOrder(for: .loyalty)
        }
        set {
            setLocalWalletOrder(newValue, for: .loyalty)
        }
    }
    
    private func getLocalWalletOrder(for walletType: WalletType) -> [String]? {
        guard let userId = Current.userManager.currentEmailAddress else { return nil }
        return Current.userDefaults.value(forDefaultsKey: .localWalletOrder(userId: userId, walletType: walletType)) as? [String]
    }

    private func setLocalWalletOrder(_ newValue: [String]?, for walletType: WalletType) {
        guard let order = newValue else { return }
        guard let userId = Current.userManager.currentEmailAddress else { return }
        Current.userDefaults.set(order, forDefaultsKey: .localWalletOrder(userId: userId, walletType: walletType))
    }
    
    private func applyLocalWalletOrder<C: WalletCard>(_ localOrder: inout [String]?, to cards: [C]?, updating walletDataSource: inout [C]?) {
        guard let cards = cards else { return }

        /// On logout, we delete all core data objects, so the first time we fall into this method is when we attempt to load local cards, which won't exist. We should return out at this point.
        if cards.isEmpty && !hasLaunched { return }

        /// If we have a local order set
        if var order = localOrder {
            /// Remove id's from local order that don't exist in the latest cards response
            order.removeAll { cardId in
                !cards.contains(where: { $0.id == cardId })
            }

            /// Add id's to top of local order for any new cards in the response
            var newCardIds = cards.compactMap { $0.id }.filter { !order.contains($0) }
            newCardIds.reverse()
            newCardIds.forEach {
                order.insert($0, at: 0)
            }

            /// Sort cards in the custom order
            let orderedCards = order.map { cardId in
                cards.first(where: { $0.id == cardId })
            }

            /// Sync the datasource and local card order
            localOrder = order
            walletDataSource = orderedCards.compactMap({ $0 })
        } else {
            /// Sync the datasource and set the local card order
            localOrder = cards.compactMap { $0.id }
            walletDataSource = cards
        }
    }
}
