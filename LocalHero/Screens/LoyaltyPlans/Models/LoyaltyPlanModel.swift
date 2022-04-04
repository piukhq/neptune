//
//  LoyaltyPlans.swift
//  Local Hero
//
//  Created by Sean Williams on 10/12/2021.
//

import CoreData
import Foundation

struct LoyaltyPlanModel: Codable {
    let apiId: Int?
    let planPopularity: Int?
    let planFeatures: LoyaltyPlanFeaturesModel?
    let images: [ImageModel]?
    let planDetails: LoyaltyPlanDetailsModel?
    let journeyFields: JourneyFieldsModel?
    let content: [ContentModel]?

    enum CodingKeys: String, CodingKey {
        case apiId = "loyalty_plan_id"
        case planPopularity = "plan_popularity"
        case planFeatures = "plan_features"
        case images, content
        case planDetails = "plan_details"
        case journeyFields = "journey_fields"
    }
}

extension LoyaltyPlanModel: CoreDataMappable, CoreDataIDMappable {
    func objectToMapTo(_ cdObject: CD_LoyaltyPlan, in context: NSManagedObjectContext, delta: Bool, overrideID: String?) -> CD_LoyaltyPlan {
        update(cdObject, \.id, with: overrideID ?? id, delta: delta)
        update(cdObject, \.planPopularity, with: NSNumber(value: planPopularity ?? 0), delta: delta)
        
        if let planDetails = planDetails {
            let cdPlanDetails = planDetails.mapToCoreData(context, .update, overrideID: LoyaltyPlanDetailsModel.overrideId(forParentId: overrideID ?? id))
            update(cdPlanDetails, \.plan, with: cdObject, delta: delta)
            update(cdObject, \.planDetails, with: cdPlanDetails, delta: delta)
        } else {
            update(cdObject, \.planDetails, with: nil, delta: false)
        }
        
        // TODO: - Map remaining properties
        
        return cdObject
    }
    
}
