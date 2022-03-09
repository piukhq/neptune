//
//  AddPaymentAccountViewModel.swift
//  LocalHero
//
//  Created by Sean Williams on 09/03/2022.
//

import Foundation

class AddPaymentAccountViewModel {
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
    
    func setPaymentAccountExpiry(month: String?, year: String?) {
        paymentAccount.expiryMonth = month
        paymentAccount.expiryYear = year
    }
    
    func addPaymentCard() {
        print("Payment card added")
    }
}
