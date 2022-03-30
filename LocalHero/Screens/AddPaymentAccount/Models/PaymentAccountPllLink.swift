//
//  PaymentAccountPllLink.swift
//  LocalHero
//
//  Created by Sean Williams on 29/03/2022.
//

import CoreData
import Foundation


// MARK: - PaymentAccountPllLink
struct PaymentAccountPllLink: Codable {
    let apiId: Int?
    let loyaltyCardID: Int?
    let loyaltyPlan: String?
    let status: String?

    enum CodingKeys: String, CodingKey {
        case apiId = "id"
        case loyaltyCardID = "loyalty_card_id"
        case loyaltyPlan = "loyalty_plan"
        case status
    }
}

extension PaymentAccountPllLink: CoreDataMappable, CoreDataIDMappable {
    func objectToMapTo(_ cdObject: CD_PaymentAccountPllLink, in context: NSManagedObjectContext, delta: Bool, overrideID: String?) -> CD_PaymentAccountPllLink {
        update(cdObject, \.id, with: overrideID ?? id, delta: delta)
        update(cdObject, \.loyaltyCardID, with: NSNumber(value: loyaltyCardID ?? 0), delta: delta)
        update(cdObject, \.loyaltyPlan, with: loyaltyPlan, delta: delta)
        update(cdObject, \.status, with: status, delta: delta)
        return cdObject
    }
}
