//
//  PaymentAccountCreateModel.swift
//  LocalHero
//
//  Created by Sean Williams on 07/03/2022.
//

import Foundation

struct PaymentAccountCreateModel: Codable {
    var fullPan, expiryMonth, expiryYear, nameOnCard, cardNickname: String?
    var token, lastFourDigits, firstSixDigits: String?
    var fingerprint, provider: String?

    enum CodingKeys: String, CodingKey {
        case expiryMonth = "expiry_month"
        case expiryYear = "expiry_year"
        case nameOnCard = "name_on_card"
        case cardNickname = "card_nickname"
        case token
        case lastFourDigits = "last_four_digits"
        case firstSixDigits = "first_six_digits"
        case fingerprint, provider
    }
}


struct PaymentAccountResponseModel: Codable {
    let expiryMonth, expiryYear, nameOnCard, cardNickname: String?
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
