//
//  WalletServiceProtocol.swift
//  LocalHero
//
//  Created by Sean Williams on 10/03/2022.
//

import Foundation

enum WalletServiceError: BinkError {
    case failedToGetSpreedlyToken
    case customError(String)
    
    var domain: BinkErrorDomain {
        return .walletService
    }
    
    var message: String {
        switch self {
        case .failedToGetSpreedlyToken:
            return "Failed to get Spreedly token"
        case .customError(let message):
            return message
        }
    }
}

protocol WalletServiceProtocol {}

extension WalletServiceProtocol {
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
}
