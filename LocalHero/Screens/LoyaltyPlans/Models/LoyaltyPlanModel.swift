//
//  LoyaltyPlans.swift
//  Local Hero
//
//  Created by Sean Williams on 10/12/2021.
//

import Foundation

struct LoyaltyPlanModel: Codable {
    let loyaltyPlanID: Int?
    let planPopularity: Int?
    let planFeatures: PlanFeaturesModel?
    let images: [ImageModel]?
    let planDetails: PlanDetailsModel?
    let journeyFields: JourneyFieldsModel?
    let content: [ContentModel]?

    enum CodingKeys: String, CodingKey {
        case loyaltyPlanID = "loyalty_plan_id"
        case planPopularity = "plan_popularity"
        case planFeatures = "plan_features"
        case images, content
        case planDetails = "plan_details"
        case journeyFields = "journey_fields"
    }
}
