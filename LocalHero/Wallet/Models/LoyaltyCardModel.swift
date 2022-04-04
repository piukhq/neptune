//
//  LoyaltyCardModel.swift
//  LocalHero
//
//  Created by Sean Williams on 01/04/2022.
//

import CoreData
import Foundation

// MARK: - LoyaltyCard
struct LoyaltyCardModel: Codable {
    let apiId: Int?
    let loyaltyPlanID: Int?
    let status: Status?
    let balance: LoyaltyCardBalanceModel?
    let transactions: [Transaction]?
    let vouchers: [Voucher]?
    let card: CardModel?
    let pllLinks: [LoyaltyCardPllLink]?

    enum CodingKeys: String, CodingKey {
        case apiId = "id"
        case loyaltyPlanID = "loyalty_plan_id"
        case status, balance, transactions, vouchers, card
        case pllLinks = "pll_links"
    }
}

extension LoyaltyCardModel: CoreDataMappable, CoreDataIDMappable {
    func objectToMapTo(_ cdObject: CD_LoyaltyCard, in context: NSManagedObjectContext, delta: Bool, overrideID: String?) -> CD_LoyaltyCard {
        update(cdObject, \.id, with: overrideID ?? id, delta: delta)
        
        if let balance = balance {
            let cdBalance = balance.mapToCoreData(context, .update, overrideID: LoyaltyCardBalanceModel.overrideId(forParentId: overrideID ?? id))
            update(cdBalance, \.loyaltyCard, with: cdObject, delta: delta)
            update(cdObject, \.balance, with: cdBalance, delta: delta)
        }
        
        if let planID = loyaltyPlanID {
            // get plan for id from core data
            let plan = context.fetchWithApiID(CD_LoyaltyPlan.self, id: String(planID))

            // update loyalty card with this loyalty plan
            update(cdObject, \.loyaltyPlan, with: plan, delta: delta)

            // add this loyalty card core data object to the plan
            plan?.addLoyaltyCardObject(cdObject)
        }
        
        
        return cdObject
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

