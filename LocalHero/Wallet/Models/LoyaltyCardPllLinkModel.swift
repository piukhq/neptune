//
//  LoyaltyCardPllLink.swift
//  
//
//  Created by Sean Williams on 05/04/2022.
//

import CoreData
import Foundation

struct LoyaltyCardPllLinkModel: Codable {
    var apiId: Int?
    let paymentAccountID: Int?
    let paymentScheme, status: String?

    enum CodingKeys: String, CodingKey {
        case apiId = "id"
        case paymentAccountID = "payment_account_id"
        case paymentScheme = "payment_scheme"
        case status
    }
}

extension LoyaltyCardPllLinkModel: CoreDataMappable, CoreDataIDMappable {
    func objectToMapTo(_ cdObject: CD_LoyaltyCardPllLink, in context: NSManagedObjectContext, delta: Bool, overrideID: String?) -> CD_LoyaltyCardPllLink {
        update(cdObject, \.id, with: overrideID ?? id, delta: delta)
        update(cdObject, \.paymentAccountID, with: NSNumber(value: paymentAccountID ?? 0), delta: delta)
        update(cdObject, \.paymentScheme, with: paymentScheme, delta: delta)
        update(cdObject, \.status, with: status, delta: delta)

        return cdObject
    }
}
