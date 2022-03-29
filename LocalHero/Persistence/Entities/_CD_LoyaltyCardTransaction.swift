// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CD_LoyaltyCardTransaction.swift instead.

import Foundation
import CoreData

public enum CD_LoyaltyCardTransactionAttributes: String {
    case displayValue = "displayValue"
    case timestamp = "timestamp"
    case transactionDescription = "transactionDescription"
}

public enum CD_LoyaltyCardTransactionRelationships: String {
    case loyaltyCard = "loyaltyCard"
}

open class _CD_LoyaltyCardTransaction: CD_BaseObject {

    // MARK: - Class methods

    override open class func entityName () -> String {
        return "CD_LoyaltyCardTransaction"
    }

    override open class func entity(managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: self.entityName(), in: managedObjectContext)
    }

    @nonobjc
    open class func fetchRequest() -> NSFetchRequest<CD_LoyaltyCardTransaction> {
        return NSFetchRequest(entityName: self.entityName())
    }

    // MARK: - Life cycle methods

    public override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

    public convenience init?(managedObjectContext: NSManagedObjectContext) {
        guard let entity = _CD_LoyaltyCardTransaction.entity(managedObjectContext: managedObjectContext) else { return nil }
        self.init(entity: entity, insertInto: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged open
    var displayValue: String?

    @NSManaged open
    var timestamp: Int64 // Optional scalars not supported

    @NSManaged open
    var transactionDescription: String?

    // MARK: - Relationships

    @NSManaged open
    var loyaltyCard: CD_LoyaltyCard?

}

