//
//  AddPaymentAccountViewModel.swift
//  LocalHero
//
//  Created by Sean Williams on 09/03/2022.
//

import Foundation

class AddPaymentAccountViewModel {
    let repository = PaymentWalletRepository()
    var paymentAccount: PaymentAccountCreateModel
    
    init(paymentAccount: PaymentAccountCreateModel? = nil) {
        self.paymentAccount = paymentAccount ?? PaymentAccountCreateModel(fullPan: nil, expiryMonth: nil, expiryYear: nil, nameOnCard: nil, cardNickname: nil, token: nil, lastFourDigits: nil, firstSixDigits: nil, fingerprint: nil)
    }
    
    var paymentAccountType: PaymentAccountType? {
        return paymentAccount.provider
    }
    
    func setPaymentAccopuntType(_ type: PaymentAccountType?) {
        paymentAccount.provider = type
    }
    
    func setPaymentAccountFullPan(_ fullPan: String?) {
        paymentAccount.fullPan = fullPan
    }
    
    func setPaymentAccountCardName(_ name: String?) {
        paymentAccount.nameOnCard = name
    }
    
    func setPaymentAccountNickname(_ name: String?) {
        paymentAccount.cardNickname = name
    }
    
    func setPaymentAccountExpiry(month: Int?, year: Int?) {
        paymentAccount.expiryMonth = month
        paymentAccount.expiryYear = year
    }
    
    func addPaymentCard(onError: @escaping () -> Void) {
        repository.addPaymentCard(paymentAccount, onSuccess: { paymentAccount in
            Current.wallet.refreshLocal()
            let name = paymentAccount?.nameOnCard ?? ""
            let nickName = paymentAccount?.cardNickname ?? ""
            let expiry = paymentAccount?.expiryMonth ?? "" + " /" + (paymentAccount?.expiryYear ?? "")
            let message = name + ", " + nickName + ", " + expiry
            let ac = ViewControllerFactory.makeAlertController(title: "Payment Account Added!", message: message) {
                Current.navigate.close()
            }
            
            let navigationRequest = AlertNavigationRequest(alertController: ac)
            Current.navigate.to(navigationRequest)
            
        }) { _ in
            onError()
            
            let ac = ViewControllerFactory.makeAlertController(title: "Error", message: "Failed to add payment account")
            let navigationRequest = AlertNavigationRequest(alertController: ac)
            Current.navigate.to(navigationRequest)
        }
    }
}
