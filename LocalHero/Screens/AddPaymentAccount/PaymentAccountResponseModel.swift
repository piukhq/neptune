//
//  PaymentAccountResponseModel.swift
//  LocalHero
//
//  Created by Sean Williams on 11/03/2022.
//

import Foundation

struct PaymentAccountResponseModel: Codable {
    let expiryMonth: String?
    let expiryYear: String?
    let nameOnCard: String?
    let cardNickname: String?
    let issuer: String?
    let id: Int?
    let status: String?

    enum CodingKeys: String, CodingKey {
        case expiryMonth = "expiry_month"
        case expiryYear = "expiry_year"
        case nameOnCard = "name_on_card"
        case cardNickname = "card_nickname"
        case issuer, id, status
    }
}
