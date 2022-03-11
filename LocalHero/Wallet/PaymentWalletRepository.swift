//
//  PaymentWalletRepository.swift
//  LocalHero
//
//  Created by Sean Williams on 10/03/2022.
//

import Foundation
import CoreData

class PaymentWalletRepository: WalletServiceProtocol {

    func addPaymentCard(_ paymentCard: PaymentAccountCreateModel, onSuccess: @escaping (SpreedlyResponse?) -> Void, onError: @escaping(BinkError?) -> Void) {
//        if Current.apiClient.isProduction || Current.apiClient.isPreProduction {
//            #if DEBUG
//            fatalError("You are targetting production, but on a debug scheme. You should use a release scheme to test adding production payment cards.")
//            #else
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
//            #endif
//        } else {
////            createPaymentCard(paymentCard, onSuccess: { createdPaymentCard in
////                onSuccess(createdPaymentCard)
////            }, onError: { error in
////                onError(error)
////            })
//        }
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

    private func createPaymentCard(_ paymentCard: PaymentAccountCreateModel, spreedlyResponse: SpreedlyResponse? = nil, onSuccess: @escaping (CD_PaymentCard?) -> Void, onError: @escaping(BinkError?) -> Void) {
        var paymentCreateRequest: PaymentAccountCreateRequest?

        if let spreedlyResponse = spreedlyResponse {
            paymentCreateRequest = PaymentAccountCreateRequest(spreedlyResponse: spreedlyResponse)
        } else {
//            paymentCreateRequest = PaymentCardCreateRequest(model: paymentCard)
        }

        guard let request = paymentCreateRequest else {
            onError(nil)
            return
        }

        addPaymentCard(withRequestModel: request) { (result, responseData) in
            switch result {
            case .success(let response):
                Current.database.performBackgroundTask { context in
                    let newObject = response.mapToCoreData(context, .update, overrideID: nil)

                    // The uuid will have already been set in the mapToCoreData call, but thats fine we can set it to the desired value here from the initial post request
                    newObject.uuid = paymentCard.uuid

                    if let statusCode = responseData?.urlResponse?.statusCode {
                        BinkAnalytics.track(CardAccountAnalyticsEvent.addPaymentCardResponseSuccess(request: paymentCard, paymentCard: newObject, statusCode: statusCode))
                    }

                    try? context.save()

                    DispatchQueue.main.async {
                        Current.database.performTask(with: newObject) { (_, safeObject) in
                            onSuccess(safeObject)
                        }
                    }
                }
            case .failure(let error):
                BinkAnalytics.track(CardAccountAnalyticsEvent.addPaymentCardResponseFail(request: paymentCard, responseData: responseData))
                if #available(iOS 14.0, *) {
                    BinkLogger.error(PaymentCardLoggerError.addPaymentCardFailure, value: responseData?.urlResponse?.statusCode.description)
                }
                onError(error)
            }
        }
    }
}
