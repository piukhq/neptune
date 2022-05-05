//
//  LoyaltyCardTransaction.swift
//  LocalHero
//
//  Created by Sean Williams on 05/04/2022.
//

import CoreData
import Foundation

struct LoyaltyCardTransactionModel: Codable {
    let apiId: Int?
    let timestamp: Double?
    let transactionDescription: String?
    let displayValue: String?

    enum CodingKeys: String, CodingKey {
        case apiId = "id"
        case timestamp
        case transactionDescription = "description"
        case displayValue = "display_value"
    }
}

extension LoyaltyCardTransactionModel: CoreDataMappable, CoreDataIDMappable {
    func objectToMapTo(_ cdObject: CD_LoyaltyCardTransaction, in context: NSManagedObjectContext, delta: Bool, overrideID: String?) -> CD_LoyaltyCardTransaction {
        update(cdObject, \.id, with: overrideID ?? id, delta: delta)
        update(cdObject, \.timestamp, with: NSNumber(value: timestamp ?? 0.0), delta: delta)
        update(cdObject, \.transactionDescription, with: transactionDescription, delta: delta)
        update(cdObject, \.displayValue, with: displayValue, delta: delta)
        return cdObject
    }
}
