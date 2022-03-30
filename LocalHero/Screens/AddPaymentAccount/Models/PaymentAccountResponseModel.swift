//
//  PaymentAccountResponseModel.swift
//  LocalHero
//
//  Created by Sean Williams on 11/03/2022.
//

import CoreData
import Foundation

struct PaymentAccountResponseModel: Codable {
    var apiId: Int?
    let status: String?
    let expiryMonth: String?
    let expiryYear: String?
    let nameOnCard: String?
    let cardNickname: String?
    var firstSix: String?
    let lastFour: String?
    let provider: PaymentAccountType?
    let images: [ImageModel]?
    let pllLinks: [PaymentAccountPllLink]?

    enum CodingKeys: String, CodingKey {
        case expiryMonth = "expiry_month"
        case expiryYear = "expiry_year"
        case nameOnCard = "name_on_card"
        case cardNickname = "card_nickname"
        case firstSix = "first_six_digits"
        case lastFour = "last_four_digits"
        case pllLinks = "pll_links"
        case apiId = "id"
        case status, provider, images
    }
}

extension PaymentAccountResponseModel: CoreDataMappable, CoreDataIDMappable {
    func objectToMapTo(_ cdObject: CD_PaymentAccount, in context: NSManagedObjectContext, delta: Bool, overrideID: String?) -> CD_PaymentAccount {
        update(cdObject, \.id, with: overrideID ?? id, delta: delta)
        update(cdObject, \.status, with: status, delta: delta)
        update(cdObject, \.expiryMonth, with: expiryMonth, delta: delta)
        update(cdObject, \.expiryYear, with: expiryYear, delta: delta)
        update(cdObject, \.nameOnCard, with: nameOnCard, delta: delta)
        update(cdObject, \.cardNickname, with: cardNickname, delta: delta)
        update(cdObject, \.firstSix, with: firstSix, delta: delta)
        update(cdObject, \.lastFour, with: lastFour, delta: delta)
        update(cdObject, \.provider, with: provider?.rawValue, delta: delta)
        
        // TODO: - map images and PLL links

        if let images = images {
            for (i, image) in images.enumerated() {
                let indexID = ImageModel.overrideId(forParentId: overrideID ?? id) + String(i)
                let cdImage = image.mapToCoreData(context, .update, overrideID: indexID)
                update(cdImage, \.paymentAccount, with: cdObject, delta: delta)
                cdObject.addImagesObject(cdImage)
            }
        }
    
        return cdObject
    }
}
