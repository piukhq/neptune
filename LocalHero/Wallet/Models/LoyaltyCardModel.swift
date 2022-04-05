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
    let status: StatusModel?
    let balance: LoyaltyCardBalanceModel?
    let transactions: [LoyaltyCardTransactionModel]?
    let vouchers: [VoucherModel]?
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
        
        if let planID = loyaltyPlanID {
            // get plan for id from core data
            let plan = context.fetchWithApiID(CD_LoyaltyPlan.self, id: String(planID))

            // update loyalty card with this loyalty plan
            update(cdObject, \.loyaltyPlan, with: plan, delta: delta)

            // add this loyalty card core data object to the plan
            plan?.addLoyaltyCardObject(cdObject)
        }
        
        if let status = status{
            let cdStatus = status.mapToCoreData(context, .update, overrideID: StatusModel.overrideId(forParentId: overrideID ?? id))
            update(cdStatus, \.loyaltyCard, with: cdObject, delta: delta)
            update(cdObject, \.status, with: cdStatus, delta: delta)
        }
        
        
        if let balance = balance {
            let cdBalance = balance.mapToCoreData(context, .update, overrideID: LoyaltyCardBalanceModel.overrideId(forParentId: overrideID ?? id))
            update(cdBalance, \.loyaltyCard, with: cdObject, delta: delta)
            update(cdObject, \.balance, with: cdBalance, delta: delta)
        }
        
        if let transactions = transactions {
            for (index, transaction) in transactions.enumerated() {
                let indexID = LoyaltyCardTransactionModel.overrideId(forParentId: overrideID ?? id) + String(index)
                let cdTransaction = transaction.mapToCoreData(context, .update, overrideID: indexID)
                cdObject.addTransactionObject(cdTransaction)
                update(cdTransaction, \.loyaltyCard, with: cdObject, delta: delta)
            }
        }
        
        if let vouchers = vouchers {
            for (index, voucher) in vouchers.enumerated() {
                let indexID = VoucherModel.overrideId(forParentId: overrideID ?? id) + String(index)
                let cdVoucher = voucher.mapToCoreData(context, .update, overrideID: indexID)
                update(cdVoucher, \.loyaltyCard, with: cdObject, delta: false)
                cdObject.addVoucherObject(cdVoucher)
            }
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
