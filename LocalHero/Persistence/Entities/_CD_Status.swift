// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CD_Status.swift instead.

import Foundation
import CoreData

public enum CD_StatusAttributes: String {
    case slug = "slug"
    case state = "state"
    case statusDescription = "statusDescription"
}

public enum CD_StatusRelationships: String {
    case join = "join"
    case loyaltyCard = "loyaltyCard"
}

open class _CD_Status: CD_BaseObject {

    // MARK: - Class methods

    override open class func entityName () -> String {
        return "CD_Status"
    }

    override open class func entity(managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: self.entityName(), in: managedObjectContext)
    }

    @nonobjc
    open class func fetchRequest() -> NSFetchRequest<CD_Status> {
        return NSFetchRequest(entityName: self.entityName())
    }

    // MARK: - Life cycle methods

    public override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

    public convenience init?(managedObjectContext: NSManagedObjectContext) {
        guard let entity = _CD_Status.entity(managedObjectContext: managedObjectContext) else { return nil }
        self.init(entity: entity, insertInto: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged open
    var slug: String?

    @NSManaged open
    var state: String?

    @NSManaged open
    var statusDescription: String?

    // MARK: - Relationships

    @NSManaged open
    var join: CD_Join?

    @NSManaged open
    var loyaltyCard: CD_LoyaltyCard?

}

