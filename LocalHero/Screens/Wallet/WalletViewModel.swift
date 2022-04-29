//
//  WalletViewModel.swift
//  LocalHero
//
//  Created by Sean Williams on 25/04/2022.
//

import Foundation

class WalletViewModel {
    var paymentAccounts: [CD_PaymentAccount]? {
        return Current.wallet.paymentAccounts
    }
    
    var loyaltyCards: [CD_LoyaltyCard]? {
        return Current.wallet.loyaltyCards
    }
    
    var numberSections: Int {
        var sections = 0
        
        if let _ = paymentAccounts {
            sections += 1
        }
        
        if let _ = loyaltyCards {
            sections += 1
        }
        return sections
    }
    
    func getNumberOfItemsForSection(_ section: Int) -> Int {
        switch section {
        case 0:
            return loyaltyCards?.count ?? 0
        case 1:
            return paymentAccounts?.count ?? 0
        default:
            return 0
        }
    }
}
