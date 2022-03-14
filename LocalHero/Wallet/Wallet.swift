//
//  Wallet.swift
//  LocalHero
//
//  Created by Sean Williams on 24/02/2022.
//

import Foundation

class Wallet {
    private (set) var loyaltyPlans: [LoyaltyPlanModel]?
    private (set) var paymentAccounts: [PaymentAccountResponseModel]?
    
    func getLoyaltyPlans(completion: @escaping (NetworkingError?) -> Void) {
        let request = BinkNetworkRequest(endpoint: .getLoyaltyPlans, method: .get, headers: nil, isUserDriven: false)
        Current.apiClient.performRequest(request, expecting: [Safe<LoyaltyPlanModel>].self) { result, _ in
            switch result {
            case .success(let response):
                self.loyaltyPlans = response.compactMap( { $0.value })
                completion(nil)
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    func launch() {
        // Get payment accounts
    }
}
