//
//  VoucherModel.swift
//  LocalHero
//
//  Created by Sean Williams on 05/04/2022.
//

import CoreData
import Foundation

struct VoucherModel: Codable {
    var apiId: Int?
    let state: VoucherState?
    let earnType: String?
    let rewardText: String?
    let headline: String?
    let voucherCode: String?
    let barcodeType: Int?
    let progressDisplayText: String?
    let bodyText: String?
    let termsAndConditions: String?
    let issuedDate, expiryDate: Int?
    let redeemedDate: Int?

    enum CodingKeys: String, CodingKey {
        case apiId = "id"
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


enum VoucherState: String, Codable {
    case redeemed
    case issued
    case inProgress = "inprogress"
    case expired
    case cancelled

    var sort: Int {
        switch self {
        case .issued:
            return 0
        case .inProgress:
            return 1
        case .redeemed, .expired, .cancelled:
            return 2
        }
    }
}

extension VoucherModel: CoreDataMappable, CoreDataIDMappable {
    func objectToMapTo(_ cdObject: CD_Voucher, in context: NSManagedObjectContext, delta: Bool, overrideID: String?) -> CD_Voucher {
        update(cdObject, \.id, with: overrideID ?? id, delta: delta)
        update(cdObject, \.state, with: state?.rawValue, delta: delta)
        update(cdObject, \.earnType, with: earnType, delta: delta)
        update(cdObject, \.rewardText, with: rewardText, delta: delta)
        update(cdObject, \.headline, with: headline, delta: delta)
        update(cdObject, \.voucherCode, with: voucherCode, delta: delta)
        update(cdObject, \.barcodeType, with: NSNumber(value: barcodeType ?? 0), delta: delta)
        update(cdObject, \.progressDisplayText, with: progressDisplayText, delta: delta)
        update(cdObject, \.bodyText, with: bodyText, delta: delta)
        update(cdObject, \.termsAndConditions, with: termsAndConditions, delta: delta)
        update(cdObject, \.issuedDate, with: NSNumber(value: issuedDate ?? 0), delta: delta)
        update(cdObject, \.expiryDate, with: NSNumber(value: expiryDate ?? 0), delta: delta)
        update(cdObject, \.redeemedDate, with: NSNumber(value: redeemedDate ?? 0), delta: delta)        
        return cdObject
    }
}
