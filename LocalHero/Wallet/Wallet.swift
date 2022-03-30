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
    
    private (set) var loyaltyPlans: [LoyaltyPlanModel]?
    private (set) var paymentAccounts: [CD_PaymentAccount]?
    
    
    // MARK: - Public

    func launch(completion: @escaping ServiceCompletionSuccessHandler<WalletServiceError>) {
        loadWalletData(forType: .localLaunch, reloadPlans: false, isUserDriven: false) { [weak self] _, _ in
            self?.loadWalletData(forType: .reload, reloadPlans: true, isUserDriven: false) { success, error in
                print("LAUNCH COMPLETE")
                completion(success, error)
            }
        }
    }
    
    
    // MARK: - Private

    /// Maybe sack off this function - possibly redundant
    private func loadWalletData(forType type: FetchType, reloadPlans: Bool, isUserDriven: Bool, completion: ServiceCompletionSuccessHandler<WalletServiceError>? = nil) {
        let forceRefresh = type == .reload
        
        if forceRefresh {
            // Get remote config
        }
        
        getLoyaltyPlansAndWallet(forceRefresh: forceRefresh, reloadPlans: reloadPlans, isUserDriven: isUserDriven) { success, error in
            guard success else {
                completion?(success, error)
                return
            }
            
            completion?(success, error)
        }
    }
    
    private func getLoyaltyPlansAndWallet(forceRefresh: Bool = false, reloadPlans: Bool, isUserDriven: Bool, completion: @escaping ServiceCompletionSuccessHandler<WalletServiceError>) {
        loadLoyaltyPlans(forceRefresh: reloadPlans, isUserDriven: isUserDriven) { [weak self] success, error in
            guard success else {
                completion(success, .failedToGetWallet)
                return
            }
            
            self?.loadWallet(forceRefresh: forceRefresh, isUserDriven: isUserDriven, completion: { success, error in
                completion(success, error)
            })
        }
    }
    
    private func loadWallet(forceRefresh: Bool = false, isUserDriven: Bool, completion: @escaping ServiceCompletionSuccessHandler<WalletServiceError>) {
        guard forceRefresh else {
            // Fetch core data objects for wallet
            fetchCoreDataObjects(forObjectType: CD_PaymentAccount.self) { [weak self] paymentAccounts in
                guard let self = self else { return }
                self.paymentAccounts = paymentAccounts
            }
            completion(true, nil)
            return
        }
        
        getWallet(isUserDriven: false) { [weak self] result in
            switch result {
            case .success(let response):
                self?.mapCoreDataObjects(objectsToMap: [response], type: CD_Wallet.self, completion: {
                    self?.fetchCoreDataObjects(forObjectType: CD_PaymentAccount.self, completion: { paymentAccounts in
                        self?.paymentAccounts = paymentAccounts
                        completion(true, nil)
                    })
                    
                    // TODO: - Fetch Loyalty accounts
                })
            case .failure(let error):
                completion(false, error)
            }
        }
    }
    
    private func loadLoyaltyPlans(forceRefresh: Bool = false, isUserDriven: Bool, completion: @escaping ServiceCompletionSuccessHandler<WalletServiceError>) {
        guard forceRefresh else {
            /// Fetch core data Loyalty plans
            completion(true, nil)
            return
        }
        getLoyaltyPlans(isUserDriven: isUserDriven, completion: { [weak self] result in
            switch result {
            case .success(let response):
                // Map to core data
                // Fetch from core data
                self?.loyaltyPlans = response
                completion(true, nil)
            case .failure(let error):
                guard let localPlans = self?.loyaltyPlans, !localPlans.isEmpty else {
                    completion(false, error)
                    return
                }
                completion(true, nil)
            }
        })
    }
}
