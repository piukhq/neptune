// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CD_LoyaltyCardBalance.swift instead.

import Foundation
import CoreData

public enum CD_LoyaltyCardBalanceAttributes: String {
    case currentDisplayValue = "currentDisplayValue"
    case updatedAt = "updatedAt"
}

public enum CD_LoyaltyCardBalanceRelationships: String {
    case loyaltyCard = "loyaltyCard"
}

open class _CD_LoyaltyCardBalance: CD_BaseObject {

    // MARK: - Class methods

    override open class func entityName () -> String {
        return "CD_LoyaltyCardBalance"
    }

    override open class func entity(managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: self.entityName(), in: managedObjectContext)
    }

    @nonobjc
    open class func fetchRequest() -> NSFetchRequest<CD_LoyaltyCardBalance> {
        return NSFetchRequest(entityName: self.entityName())
    }

    // MARK: - Life cycle methods

    public override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

    public convenience init?(managedObjectContext: NSManagedObjectContext) {
        guard let entity = _CD_LoyaltyCardBalance.entity(managedObjectContext: managedObjectContext) else { return nil }
        self.init(entity: entity, insertInto: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged open
    var currentDisplayValue: String?

    @NSManaged open
    var updatedAt: NSNumber?

    // MARK: - Relationships

    @NSManaged open
    var loyaltyCard: CD_LoyaltyCard?

}

