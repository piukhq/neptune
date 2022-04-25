//
//  WalletCardDetailsViewModel.swift
//  LocalHero
//
//  Created by Sean Williams on 25/04/2022.
//

import Foundation

class WalletCardDetailsViewModel {
    var loyaltyCard: CD_LoyaltyCard?
    var paymentAccount: CD_PaymentAccount?
    
    var walletCardType: WalletCardType
    
    init(loyaltyCard: CD_LoyaltyCard?, paymentAccount: CD_PaymentAccount?) {
        self.loyaltyCard = loyaltyCard
        self.paymentAccount = paymentAccount
        self.walletCardType = loyaltyCard != nil ? .loyalty : .payment
    }
    
    var title: String {
        switch walletCardType {
        case .loyalty:
            return loyaltyCard?.loyaltyPlan?.planDetails?.companyName ?? ""
        case .payment:
            return paymentAccount?.provider ?? ""
        }
    }
    
    var cardDetailsText: String? {
        return walletCardType == .loyalty ? loyaltyCardDetailsText() : paymentAccountDetailsText()
    }
    
    func loyaltyCardDetailsText() -> String? {
        guard let loyaltyCard = loyaltyCard else { return nil }
        var cardDetails = ""
        cardDetails = "Status: \(loyaltyCard.status?.state ?? "")".capitalized + "\n"
        cardDetails += "ID: \(loyaltyCard.id ?? "")" + "\n"
        cardDetails += "Balance: \(loyaltyCard.balance?.currentDisplayValue ?? "Zero")" + "\n"
        cardDetails += "Barcode: \(loyaltyCard.card?.barcode ?? "None")" + "\n"
        
        cardDetails += (loyaltyCard.pllLink.count == 0 ? "No PLL links" : "\(loyaltyCard.pllLink.count) PLL links") + "\n"
        cardDetails += (loyaltyCard.transaction.count == 0 ? "No transactions" : "\(loyaltyCard.transaction.count) transactions") + "\n"
        cardDetails += (loyaltyCard.voucher.count == 0 ? "No vouchers" : "\(loyaltyCard.voucher.count) vouchers") + "\n"
        return cardDetails
    }
    
    func paymentAccountDetailsText() -> String? {
        guard let paymentAccount = paymentAccount else { return nil }
        var cardDetails = ""
        cardDetails = (paymentAccount.cardNickname ?? "") + "\n"
        cardDetails += (paymentAccount.nameOnCard ?? "") + "\n"
        cardDetails += "ID: \(paymentAccount.id ?? "")" + "\n"
        cardDetails += "Expiry: \(paymentAccount.expiryMonth ?? "") / \(paymentAccount.expiryYear ?? "")" + "\n"
        cardDetails += "Last four digits: \(paymentAccount.lastFour ?? "")" + "\n"
        cardDetails += "Status: \(paymentAccount.status ?? "")".capitalized + "\n"
        cardDetails += (paymentAccount.pllLinks.count == 0 ? "No PLL links" : "\(paymentAccount.pllLinks.count) PLL links") + "\n"
        return cardDetails
    }
}
