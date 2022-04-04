//
//  BalanceModel.swift
//  LocalHero
//
//  Created by Sean Williams on 04/04/2022.
//

import CoreData
import Foundation

// MARK: - Balance
struct LoyaltyCardBalanceModel: Codable {
    let apiId: Int?
    let updatedAt: Int?
    let currentDisplayValue: String?

    enum CodingKeys: String, CodingKey {
        case apiId = "id"
        case updatedAt = "updated_at"
        case currentDisplayValue = "current_display_value"
    }
}

extension LoyaltyCardBalanceModel: CoreDataMappable, CoreDataIDMappable {
    func objectToMapTo(_ cdObject: CD_LoyaltyCardBalance, in context: NSManagedObjectContext, delta: Bool, overrideID: String?) -> CD_LoyaltyCardBalance {
        update(cdObject, \.id, with: overrideID ?? id, delta: delta)
        update(cdObject, \.updatedAt, with: NSNumber(value: updatedAt ?? 0), delta: delta)
        update(cdObject, \.currentDisplayValue, with: currentDisplayValue, delta: delta)
        return cdObject
    }
}
