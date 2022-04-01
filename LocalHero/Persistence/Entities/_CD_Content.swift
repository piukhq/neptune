// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CD_Content.swift instead.

import Foundation
import CoreData

public enum CD_ContentAttributes: String {
    case column = "column"
    case value = "value"
}

public enum CD_ContentRelationships: String {
    case plan = "plan"
}

open class _CD_Content: CD_BaseObject {

    // MARK: - Class methods

    override open class func entityName () -> String {
        return "CD_Content"
    }

    override open class func entity(managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: self.entityName(), in: managedObjectContext)
    }

    @nonobjc
    open class func fetchRequest() -> NSFetchRequest<CD_Content> {
        return NSFetchRequest(entityName: self.entityName())
    }

    // MARK: - Life cycle methods

    public override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

    public convenience init?(managedObjectContext: NSManagedObjectContext) {
        guard let entity = _CD_Content.entity(managedObjectContext: managedObjectContext) else { return nil }
        self.init(entity: entity, insertInto: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged open
    var column: String?

    @NSManaged open
    var value: String?

    // MARK: - Relationships

    @NSManaged open
    var plan: CD_LoyaltyPlan?

}

