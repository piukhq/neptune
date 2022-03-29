// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CD_LoyaltyCardCard.swift instead.

import Foundation
import CoreData

public enum CD_LoyaltyCardCardAttributes: String {
    case barcode = "barcode"
    case barcodeType = "barcodeType"
    case cardNumber = "cardNumber"
    case colour = "colour"
}

public enum CD_LoyaltyCardCardRelationships: String {
    case loyaltyCard = "loyaltyCard"
}

open class _CD_LoyaltyCardCard: CD_BaseObject {

    // MARK: - Class methods

    override open class func entityName () -> String {
        return "CD_LoyaltyCardCard"
    }

    override open class func entity(managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: self.entityName(), in: managedObjectContext)
    }

    @nonobjc
    open class func fetchRequest() -> NSFetchRequest<CD_LoyaltyCardCard> {
        return NSFetchRequest(entityName: self.entityName())
    }

    // MARK: - Life cycle methods

    public override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

    public convenience init?(managedObjectContext: NSManagedObjectContext) {
        guard let entity = _CD_LoyaltyCardCard.entity(managedObjectContext: managedObjectContext) else { return nil }
        self.init(entity: entity, insertInto: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged open
    var barcode: String?

    @NSManaged open
    var barcodeType: Int64 // Optional scalars not supported

    @NSManaged open
    var cardNumber: String?

    @NSManaged open
    var colour: String?

    // MARK: - Relationships

    @NSManaged open
    var loyaltyCard: CD_LoyaltyCard?

}

