// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CD_Voucher.swift instead.

import Foundation
import CoreData

public enum CD_VoucherAttributes: String {
    case barcodeType = "barcodeType"
    case bodyText = "bodyText"
    case earnType = "earnType"
    case expiryDate = "expiryDate"
    case headline = "headline"
    case issuedDate = "issuedDate"
    case progressDisplayText = "progressDisplayText"
    case redeemedDate = "redeemedDate"
    case rewardText = "rewardText"
    case state = "state"
    case termsAndConditions = "termsAndConditions"
    case voucherCode = "voucherCode"
}

public enum CD_VoucherRelationships: String {
    case loyaltyCard = "loyaltyCard"
}

open class _CD_Voucher: CD_BaseObject {

    // MARK: - Class methods

    override open class func entityName () -> String {
        return "CD_Voucher"
    }

    override open class func entity(managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: self.entityName(), in: managedObjectContext)
    }

    @nonobjc
    open class func fetchRequest() -> NSFetchRequest<CD_Voucher> {
        return NSFetchRequest(entityName: self.entityName())
    }

    // MARK: - Life cycle methods

    public override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

    public convenience init?(managedObjectContext: NSManagedObjectContext) {
        guard let entity = _CD_Voucher.entity(managedObjectContext: managedObjectContext) else { return nil }
        self.init(entity: entity, insertInto: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged open
    var barcodeType: String?

    @NSManaged open
    var bodyText: String?

    @NSManaged open
    var earnType: String?

    @NSManaged open
    var expiryDate: NSNumber?

    @NSManaged open
    var headline: String?

    @NSManaged open
    var issuedDate: NSNumber?

    @NSManaged open
    var progressDisplayText: String?

    @NSManaged open
    var redeemedDate: NSNumber?

    @NSManaged open
    var rewardText: String?

    @NSManaged open
    var state: String?

    @NSManaged open
    var termsAndConditions: String?

    @NSManaged open
    var voucherCode: String?

    // MARK: - Relationships

    @NSManaged open
    var loyaltyCard: CD_LoyaltyCard?

}

