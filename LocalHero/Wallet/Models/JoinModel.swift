//
//  JoinModel.swift
//  LocalHero
//
//  Created by Sean Williams on 28/03/2022.
//

import Foundation


// MARK: - Join
struct JoinModel: Codable {
    let loyaltyCardID, loyaltyPlanID: Int?
    let status: Status?

    enum CodingKeys: String, CodingKey {
        case loyaltyCardID = "loyalty_card_id"
        case loyaltyPlanID = "loyalty_plan_id"
        case status
    }
}

// MARK: - Status
struct Status: Codable {
    let state: String?
    let slug, statusDescription: String?

    enum CodingKeys: String, CodingKey {
        case state, slug
        case statusDescription = "description"
    }
}

// MARK: - LoyaltyCard
struct LoyaltyCardModel: Codable {
    let id: Int?
    let loyaltyPlanID: Int?
    let status: Status?
    let balance: Balance?
    let transactions: [Transaction]?
    let vouchers: [Voucher]?
    let card: CardModel?
    let pllLinks: [LoyaltyCardPllLink]?

    enum CodingKeys: String, CodingKey {
        case id
        case loyaltyPlanID = "loyalty_plan_id"
        case status, balance, transactions, vouchers, card
        case pllLinks = "pll_links"
    }
}

// MARK: - Balance
struct Balance: Codable {
    let updatedAt: Int?
    let currentDisplayValue: String?

    enum CodingKeys: String, CodingKey {
        case updatedAt = "updated_at"
        case currentDisplayValue = "current_display_value"
    }
}

// MARK: - Card
struct CardModel: Codable {
    let barcode: String?
    let barcodeType: Int?
    let cardNumber, colour: String?
    let textColour: String?

    enum CodingKeys: String, CodingKey {
        case barcode
        case barcodeType = "barcode_type"
        case cardNumber = "card_number"
        case textColour = "text_colour"
        case colour
    }
}

// MARK: - LoyaltyCardPllLink
struct LoyaltyCardPllLink: Codable {
    let paymentAccountID: Int?
    let paymentScheme, status: String?

    enum CodingKeys: String, CodingKey {
        case paymentAccountID = "payment_account_id"
        case paymentScheme = "payment_scheme"
        case status
    }
}

// MARK: - Transaction
struct Transaction: Codable {
    let id: String?
    let timestamp: Int?
    let transactionDescription, displayValue: String?

    enum CodingKeys: String, CodingKey {
        case id, timestamp
        case transactionDescription = "description"
        case displayValue = "display_value"
    }
}

// MARK: - Voucher
struct Voucher: Codable {
    let state, earnType, rewardText, headline: String?
    let voucherCode: String?
    let barcodeType: Int?
    let progressDisplayText: String?
    let bodyText: String?
    let termsAndConditions: String?
    let issuedDate, expiryDate: Int?
    let redeemedDate: Int?

    enum CodingKeys: String, CodingKey {
        case state
        case earnType = "earn_type"
        case rewardText = "reward_text"
        case headline
        case voucherCode = "voucher_code"
        case barcodeType = "barcode_type"
        case progressDisplayText = "progress_display_text"
        case bodyText = "body_text"
        case termsAndConditions = "terms_and_conditions"
        case issuedDate = "issued_date"
        case expiryDate = "expiry_date"
        case redeemedDate = "redeemed_date"
    }
}
