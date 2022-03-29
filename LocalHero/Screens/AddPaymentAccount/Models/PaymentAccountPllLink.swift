//
//  PaymentAccountPllLink.swift
//  LocalHero
//
//  Created by Sean Williams on 29/03/2022.
//

import Foundation


// MARK: - PaymentAccountPllLink
struct PaymentAccountPllLink: Codable {
    let loyaltyPlanID: Int?
    let loyaltyPlan, status: String?

    enum CodingKeys: String, CodingKey {
        case loyaltyPlanID = "loyalty_plan_id"
        case loyaltyPlan = "loyalty_plan"
        case status
    }
}
