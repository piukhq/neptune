//
//  WalletServiceProtocol.swift
//  LocalHero
//
//  Created by Sean Williams on 10/03/2022.
//

import Foundation

enum WalletServiceError: BinkError {
    case failedToGetSpreedlyToken
    case failedToAddPaymentAccount
    case failedToDecodeWallet
    case failedToGetWallet
    case failedToGetLoyaltyPlans
    case customError(String)
    
    var domain: BinkErrorDomain {
        return .walletService
    }
    
    var message: String {
        switch self {
        case .failedToGetSpreedlyToken:
            return "Failed to get Spreedly token"
        case .failedToAddPaymentAccount:
            return "Failed to add payment account"
        case .failedToDecodeWallet:
            return "Failed to decode wallet"
        case .failedToGetWallet:
            return "Failed to get wallet"
        case .customError(let message):
            return message
        case .failedToGetLoyaltyPlans:
            return "Failed to get loyalty plans"
        }
    }
}

protocol WalletServiceProtocol {}

extension WalletServiceProtocol {
    func getLoyaltyPlans(isUserDriven: Bool, completion: @escaping ServiceCompletionResultHandler<[LoyaltyPlanModel], WalletServiceError>) {
        let request = BinkNetworkRequest(endpoint: .getLoyaltyPlans, method: .get, headers: nil, isUserDriven: false)
        Current.apiClient.performRequest(request, expecting: [Safe<LoyaltyPlanModel>].self) { result, _ in
            switch result {
            case .success(let response):
                let safeResponse = response.compactMap( { $0.value })
                completion(.success(safeResponse))
            case .failure:
                completion(.failure(.failedToGetLoyaltyPlans))
            }
        }
    }
    
    func getSpreedlyToken(withRequest model: SpreedlyRequest, completion: @escaping ServiceCompletionResultHandler<SpreedlyResponse, WalletServiceError>) {
        let request = BinkNetworkRequest(endpoint: .spreedly, method: .post, headers: nil, isUserDriven: true)
        Current.apiClient.performRequestWithBody(request, body: model, expecting: Safe<SpreedlyResponse>.self) { (result, rawResponse) in
            switch result {
            case .success(let response):
                guard let safeResponse = response.value else {
                    completion(.failure(.customError("Failed to decode spreedly response")))
                    return
                }
                completion(.success(safeResponse))
            case .failure:
                completion(.failure(.failedToGetSpreedlyToken))
            }
        }
    }
    
    func addPaymentCard(withRequestModel model: PaymentAccountCreateRequest, completion: @escaping ServiceCompletionResultRawResponseHandler<PaymentAccountResponseModel, WalletServiceError>) {
        let request = BinkNetworkRequest(endpoint: .createPaymentAccount, method: .post, headers: nil, isUserDriven: true)
        Current.apiClient.performRequestWithBody(request, body: model, expecting: Safe<PaymentAccountResponseModel>.self) { (result, rawResponse) in
            switch result {
            case .success(let response):
                guard let safeResponse = response.value else {
                    completion(.failure(.customError("Failed to decode new payment card")), rawResponse)
                    return
                }
                completion(.success(safeResponse), rawResponse)
            case .failure:
                completion(.failure(.failedToAddPaymentAccount), rawResponse)
            }
        }
    }
    
    func getWallet(isUserDriven: Bool, completion: @escaping ServiceCompletionResultHandler<WalletModel, WalletServiceError>) {
        let request = BinkNetworkRequest(endpoint: .wallet, method: .get, isUserDriven: false)
        Current.apiClient.performRequest(request, expecting: Safe<WalletModel>.self) { result, rawResponse in
            switch result {
            case .success(let response):
                guard let safeResponse = response.value else {
                    completion(.failure(.failedToDecodeWallet))
                    return
                }
                completion(.success(safeResponse))
            case .failure(let error):
                print(error.localizedDescription)
                completion(.failure(.failedToGetWallet))
            }
        }
    }
}
