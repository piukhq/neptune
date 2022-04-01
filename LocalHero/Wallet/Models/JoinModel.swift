//
//  JoinModel.swift
//  LocalHero
//
//  Created by Sean Williams on 28/03/2022.
//

import Foundation


// MARK: - Join
struct JoinModel: Codable {
    let loyaltyCardID, loyaltyPlanID: Int?
    let status: Status?

    enum CodingKeys: String, CodingKey {
        case loyaltyCardID = "loyalty_card_id"
        case loyaltyPlanID = "loyalty_plan_id"
        case status
    }
}

// MARK: - Status
struct Status: Codable {
    let state: String?
    let slug, statusDescription: String?

    enum CodingKeys: String, CodingKey {
        case state, slug
        case statusDescription = "description"
    }
}
