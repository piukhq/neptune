// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CD_Journey.swift instead.

import Foundation
import CoreData

public enum CD_JourneyAttributes: String {
    case journeyDescription = "journeyDescription"
    case type = "type"
}

public enum CD_JourneyRelationships: String {
    case planFeatures = "planFeatures"
}

open class _CD_Journey: CD_BaseObject {

    // MARK: - Class methods

    override open class func entityName () -> String {
        return "CD_Journey"
    }

    override open class func entity(managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: self.entityName(), in: managedObjectContext)
    }

    @nonobjc
    open class func fetchRequest() -> NSFetchRequest<CD_Journey> {
        return NSFetchRequest(entityName: self.entityName())
    }

    // MARK: - Life cycle methods

    public override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

    public convenience init?(managedObjectContext: NSManagedObjectContext) {
        guard let entity = _CD_Journey.entity(managedObjectContext: managedObjectContext) else { return nil }
        self.init(entity: entity, insertInto: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged open
    var journeyDescription: String?

    @NSManaged open
    var type: NSNumber?

    // MARK: - Relationships

    @NSManaged open
    var planFeatures: CD_LoyaltyPlanFeatures?

}

