// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CD_Join.swift instead.

import Foundation
import CoreData

public enum CD_JoinAttributes: String {
    case loyaltyCardID = "loyaltyCardID"
    case loyaltyPlanID = "loyaltyPlanID"
}

public enum CD_JoinRelationships: String {
    case status = "status"
    case wallet = "wallet"
}

open class _CD_Join: CD_BaseObject {

    // MARK: - Class methods

    override open class func entityName () -> String {
        return "CD_Join"
    }

    override open class func entity(managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: self.entityName(), in: managedObjectContext)
    }

    @nonobjc
    open class func fetchRequest() -> NSFetchRequest<CD_Join> {
        return NSFetchRequest(entityName: self.entityName())
    }

    // MARK: - Life cycle methods

    public override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

    public convenience init?(managedObjectContext: NSManagedObjectContext) {
        guard let entity = _CD_Join.entity(managedObjectContext: managedObjectContext) else { return nil }
        self.init(entity: entity, insertInto: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged open
    var loyaltyCardID: NSNumber?

    @NSManaged open
    var loyaltyPlanID: NSNumber?

    // MARK: - Relationships

    @NSManaged open
    var status: CD_Status?

    @NSManaged open
    var wallet: CD_Wallet?

}

