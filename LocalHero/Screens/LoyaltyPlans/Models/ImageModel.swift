//
//  ImageModel.swift
//  LocalHero
//
//  Created by Sean Williams on 28/02/2022.
//

import CoreData
import Foundation

struct ImageModel: Codable {
    let apiId: Int?
    let type: Int?
    let url: String?
    let imageDescription: String?
    let encoding: String?

    enum CodingKeys: String, CodingKey {
        case apiId = "id"
        case type, url
        case imageDescription = "description"
        case encoding
    }
}

extension ImageModel: CoreDataMappable, CoreDataIDMappable {
    func objectToMapTo(_ cdObject: CD_Image, in context: NSManagedObjectContext, delta: Bool, overrideID: String?) -> CD_Image {
        update(cdObject, \.id, with: overrideID ?? id, delta: delta)
        update(cdObject, \.type, with: NSNumber(value: type ?? 0), delta: delta)
        update(cdObject, \.url, with: url, delta: delta)
        update(cdObject, \.imageDescription, with: imageDescription, delta: delta)
        update(cdObject, \.encoding, with: encoding, delta: delta)
        
        return cdObject
    }
}
