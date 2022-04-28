// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CD_Tier.swift instead.

import Foundation
import CoreData

public enum CD_TierAttributes: String {
    case name = "name"
    case tierDescription = "tierDescription"
}

public enum CD_TierRelationships: String {
    case plan = "plan"
}

open class _CD_Tier: CD_BaseObject {

    // MARK: - Class methods

    override open class func entityName () -> String {
        return "CD_Tier"
    }

    override open class func entity(managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: self.entityName(), in: managedObjectContext)
    }

    @nonobjc
    open class func fetchRequest() -> NSFetchRequest<CD_Tier> {
        return NSFetchRequest(entityName: self.entityName())
    }

    // MARK: - Life cycle methods

    public override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

    public convenience init?(managedObjectContext: NSManagedObjectContext) {
        guard let entity = _CD_Tier.entity(managedObjectContext: managedObjectContext) else { return nil }
        self.init(entity: entity, insertInto: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged open
    var name: String?

    @NSManaged open
    var tierDescription: String?

    // MARK: - Relationships

    @NSManaged open
    var plan: CD_LoyaltyPlanDetails?

}

