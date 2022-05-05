//
//  StatusModel.swift
//  LocalHero
//
//  Created by Sean Williams on 05/04/2022.
//

import CoreData
import Foundation

enum MembershipCardStatus: String, Codable {
    case authorised
    case unauthorised
    case pending
    case failed
}

struct StatusModel: Codable {
    let apiId: Int?
    let state: MembershipCardStatus?
    let slug: String?
    let statusDescription: String?

    enum CodingKeys: String, CodingKey {
        case apiId = "id"
        case state, slug
        case statusDescription = "description"
    }
}

extension StatusModel: CoreDataMappable, CoreDataIDMappable {
    func objectToMapTo(_ cdObject: CD_Status, in context: NSManagedObjectContext, delta: Bool, overrideID: String?) -> CD_Status {
        update(cdObject, \.id, with: overrideID ?? id, delta: delta)
        update(cdObject, \.state, with: state?.rawValue, delta: delta)
        update(cdObject, \.slug, with: slug, delta: delta)
        update(cdObject, \.statusDescription, with: statusDescription, delta: delta)
        return cdObject
    }
}
