//
//  PaymentAccountCreateModel.swift
//  LocalHero
//
//  Created by Sean Williams on 07/03/2022.
//

import Foundation

struct PaymentAccountCreateModel: Codable {
    var fullPan: String?
    var expiryMonth: Int?
    var expiryYear: Int?
    var nameOnCard: String?
    var cardNickname: String?
    var token: String?
    var lastFourDigits: String?
    var firstSixDigits: String?
    var fingerprint: String?
    var provider: PaymentAccountType?

    enum CodingKeys: String, CodingKey {
        case expiryMonth = "expiry_month"
        case expiryYear = "expiry_year"
        case nameOnCard = "name_on_card"
        case cardNickname = "card_nickname"
        case token
        case lastFourDigits = "last_four_digits"
        case firstSixDigits = "first_six_digits"
        case fingerprint
    }
}
