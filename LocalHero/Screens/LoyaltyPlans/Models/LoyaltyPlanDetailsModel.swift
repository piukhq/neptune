//
//  PlanDetailsModel.swift
//  LocalHero
//
//  Created by Sean Williams on 28/02/2022.
//

import CoreData
import Foundation

struct LoyaltyPlanDetailsModel: Codable {
    let apiId: Int?
    let companyName, planName, planLabel: String?
    let planURL: String?
    let planSummary, planDescription, redeemInstructions, planRegisterInfo: String?
    let joinIncentive, category: String?
    let tiers: [TierModel]?

    enum CodingKeys: String, CodingKey {
        case apiId = "id"
        case companyName = "company_name"
        case planName = "plan_name"
        case planLabel = "plan_label"
        case planURL = "plan_url"
        case planSummary = "plan_summary"
        case planDescription = "plan_description"
        case redeemInstructions = "redeem_instructions"
        case planRegisterInfo = "plan_register_info"
        case joinIncentive = "join_incentive"
        case category, tiers
    }
}

extension LoyaltyPlanDetailsModel: CoreDataMappable, CoreDataIDMappable {
    func objectToMapTo(_ cdObject: CD_LoyaltyPlanDetails, in context: NSManagedObjectContext, delta: Bool, overrideID: String?) -> CD_LoyaltyPlanDetails {
        update(cdObject, \.id, with: overrideID ?? id, delta: delta)
        update(cdObject, \.companyName, with: companyName, delta: delta)
        update(cdObject, \.planName, with: planName, delta: delta)
        update(cdObject, \.planLabel, with: planLabel, delta: delta)
        update(cdObject, \.planURL, with: planURL, delta: delta)
        update(cdObject, \.planSummary, with: planSummary, delta: delta)
        update(cdObject, \.planDescription, with: planDescription, delta: delta)
        update(cdObject, \.redeemInstructions, with: redeemInstructions, delta: delta)
        update(cdObject, \.planRegisterInfo, with: planRegisterInfo, delta: delta)
        update(cdObject, \.joinIncentive, with: joinIncentive, delta: delta)
        update(cdObject, \.category, with: category, delta: delta)

        // TODO: - tiers

        return cdObject
    }
}
