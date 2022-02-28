//
//  PlanDetailsModel.swift
//  LocalHero
//
//  Created by Sean Williams on 28/02/2022.
//

import Foundation

struct PlanDetailsModel: Codable {
    let companyName, planName, planLabel: String?
    let planURL: String?
    let planSummary, planDescription, redeemInstructions, planRegisterInfo: String?
    let joinIncentive, category: String?
    let tiers: [TierModel]?

    enum CodingKeys: String, CodingKey {
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
