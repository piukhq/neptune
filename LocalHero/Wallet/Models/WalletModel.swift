//
//  WalletModel.swift
//  LocalHero
//
//  Created by Sean Williams on 14/03/2022.
//

import Foundation
import CoreData

// MARK: - Welcome
struct WalletModel: Codable {
    let apiId: Int?
    let joins: [JoinModel]?
    let loyaltyCards: [LoyaltyCardModel]?
    let paymentAccounts: [PaymentAccountResponseModel]?

    enum CodingKeys: String, CodingKey {
        case apiId = "id"
        case joins
        case loyaltyCards = "loyalty_cards"
        case paymentAccounts = "payment_accounts"
    }
}

extension WalletModel: CoreDataMappable, CoreDataIDMappable {
    func objectToMapTo(_ cdObject: CD_Wallet, in context: NSManagedObjectContext, delta: Bool, overrideID: String?) -> CD_Wallet {
        update(cdObject, \.id, with: overrideID ?? id, delta: delta)
        
//        cdObject.joins.forEach {
//            guard let join = $0 as? CD_Join else { return }
//            cdObject.removeJoinsObject(join)
//        }
        
//        joins?.forEach({ join in
//            let cdJoin = join.mapToCoreData(context, .update, overrideID: nil)
//            update(cdJoin, \.wallet, with: cdJoin, delta: delta)
//
//        })
        
        cdObject.paymentAccounts.forEach {
            guard let paymentAccount = $0 as? CD_PaymentAccount else { return }
            cdObject.removePaymentAccountsObject(paymentAccount)
        }
        
        paymentAccounts?.forEach({ paymentAccount in
            let cdPaymentAccount = paymentAccount.mapToCoreData(context, .update, overrideID: nil)
            update(cdPaymentAccount, \.wallet, with: cdObject, delta: delta)
            cdObject.addPaymentAccountsObject(cdPaymentAccount)
        })
        
        return cdObject
    }
}
