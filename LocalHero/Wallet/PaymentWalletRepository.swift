//
//  PaymentWalletRepository.swift
//  LocalHero
//
//  Created by Sean Williams on 10/03/2022.
//

import Foundation
import CoreData

class PaymentWalletRepository: WalletServiceProtocol {
    func addPaymentCard(_ paymentCard: PaymentAccountCreateModel, onSuccess: @escaping (PaymentAccountResponseModel?) -> Void, onError: @escaping(BinkError?) -> Void) {
        if Current.apiClient.isProduction || Current.apiClient.isPreProduction {
            #if DEBUG
            fatalError("You are targetting production, but on a debug scheme. You should use a release scheme to test adding production payment cards.")
            #else
            requestSpreedlyToken(paymentCard: paymentCard, onSuccess: { [weak self] spreedlyResponse in
                guard spreedlyResponse.isValid else {
                    onError(nil)
                    return
                }
                self?.createPaymentCard(paymentCard, spreedlyResponse: spreedlyResponse, onSuccess: { createdPaymentCard in
                    onSuccess(createdPaymentCard)
                }, onError: { error in
                    onError(error)
                })
            }) { error in
                onError(error)
            }
            return
            #endif
        } else {
            createPaymentCard(paymentCard, onSuccess: { createdPaymentCard in
                onSuccess(createdPaymentCard)
            }, onError: { error in
                onError(error)
            })
        }
    }

    private func requestSpreedlyToken(paymentCard: PaymentAccountCreateModel, onSuccess: @escaping (SpreedlyResponse) -> Void, onError: @escaping (BinkError?) -> Void) {
        let spreedlyRequest = SpreedlyRequest(fullName: paymentCard.nameOnCard, number: paymentCard.fullPan, month: paymentCard.expiryMonth, year: paymentCard.expiryYear)

        getSpreedlyToken(withRequest: spreedlyRequest) { result in
            switch result {
            case .success(let response):
                onSuccess(response)
            case .failure(let error):
                onError(error)
            }
        }
    }

    private func createPaymentCard(_ paymentAccount: PaymentAccountCreateModel, spreedlyResponse: SpreedlyResponse? = nil, onSuccess: @escaping (PaymentAccountResponseModel?) -> Void, onError: @escaping(BinkError?) -> Void) {
        var paymentCreateRequest: PaymentAccountCreateRequest?

        if let spreedlyResponse = spreedlyResponse {
            paymentCreateRequest = PaymentAccountCreateRequest(spreedlyResponse: spreedlyResponse, paymentAccount: paymentAccount)
        } else {
            paymentCreateRequest = PaymentAccountCreateRequest(model: paymentAccount)
        }

        guard let request = paymentCreateRequest else {
            onError(nil)
            return
        }

        addPaymentCard(withRequestModel: request) { (result, responseData) in
            switch result {
            case .success(let response):
                onSuccess(response)
            case .failure(let error):
                onError(error)
            }
        }
    }
}
