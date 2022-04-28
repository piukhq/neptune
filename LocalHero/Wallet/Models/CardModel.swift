//
//  CardModel.swift
//  LocalHero
//
//  Created by Sean Williams on 05/04/2022.
//

import CoreData
import Foundation

struct CardModel: Codable {
    let apiId: Int?
    let barcode: String?
    let barcodeType: Int?
    let cardNumber, colour: String?
    let textColour: String?

    enum CodingKeys: String, CodingKey {
        case apiId = "id"
        case barcode
        case barcodeType = "barcode_type"
        case cardNumber = "card_number"
        case textColour = "text_colour"
        case colour
    }
}

extension CardModel: CoreDataMappable, CoreDataIDMappable {
    func objectToMapTo(_ cdObject: CD_LoyaltyCardCard, in context: NSManagedObjectContext, delta: Bool, overrideID: String?) -> CD_LoyaltyCardCard {
        update(cdObject, \.id, with: overrideID ?? id, delta: delta)
        update(cdObject, \.barcode, with: barcode, delta: delta)
        update(cdObject, \.barcodeType, with: NSNumber(value: barcodeType ?? 0), delta: delta)
        update(cdObject, \.colour, with: colour, delta: delta)
        update(cdObject, \.cardNumber, with: cardNumber, delta: delta)
        update(cdObject, \.textColour, with: textColour, delta: delta)
        return cdObject
    }
}
