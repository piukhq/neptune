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
    let pllLinks: [LoyaltyCardPllLinkModel]?

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
        
        if let card = card {
            let cdCard = card.mapToCoreData(context, .update, overrideID: CardModel.overrideId(forParentId: overrideID ?? id))
            update(cdCard, \.loyaltyCard, with: cdObject, delta: delta)
            update(cdObject, \.card, with: cdCard, delta: delta)
        } else {
            update(cdObject, \.card, with: nil, delta: false)
        }
        
        if let pllLinks = pllLinks {
            for (index, pllLink) in pllLinks.enumerated() {
                let indexID = LoyaltyCardPllLinkModel.overrideId(forParentId: overrideID ?? id) + String(index)
                let cdPllLink = pllLink.mapToCoreData(context, .update, overrideID: indexID)
                update(cdPllLink, \.loyaltyCard, with: cdObject, delta: delta)
                cdObject.addPllLinkObject(cdPllLink)
            }
        }
        
        return cdObject
    }
    
}
