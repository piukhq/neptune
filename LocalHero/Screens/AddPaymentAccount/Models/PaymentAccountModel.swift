//
//  PaymentAccountModel.swift
//  LocalHero
//
//  Created by Sean Williams on 29/03/2022.
//

import CoreData
import Foundation

// MARK: - PaymentAccount
//struct PaymentAccountModel: Codable {
//    let id: Int?
//    let status: String?
//    let expiryMonth: String?
//    let expiryYear: String?
//    let nameOnCard: String?
//    let cardNickname: String?
//    let lastFour: String?
//    let provider: PaymentAccountType?
//    let images: [ImageModel]?
//    let pllLinks: [PaymentAccountPllLink]?
//
//    enum CodingKeys: String, CodingKey {
//        case id, status, provider, images
//        case expiryMonth = "expiry_month"
//        case expiryYear = "expiry_year"
//        case nameOnCard = "name_on_card"
//        case cardNickname = "card_nickname"
//        case pllLinks = "pll_links"
//        case lastFour = "last_four_digits"
//    }
//}
//
//extension PaymentAccountModel: CoreDataMappable, CoreDataIDMappable {
//    func objectToMapTo(_ cdObject: CD_PaymentAccount, in context: NSManagedObjectContext, delta: Bool, overrideID: String?) -> CD_PaymentAccount {
//        
//    }
//}
