// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CD_LoyaltyCardPllLink.swift instead.

import Foundation
import CoreData

public enum CD_LoyaltyCardPllLinkAttributes: String {
    case paymentAccountID = "paymentAccountID"
    case paymentScheme = "paymentScheme"
    case status = "status"
}

public enum CD_LoyaltyCardPllLinkRelationships: String {
    case loyaltyCard = "loyaltyCard"
}

open class _CD_LoyaltyCardPllLink: CD_BaseObject {

    // MARK: - Class methods

    override open class func entityName () -> String {
        return "CD_LoyaltyCardPllLink"
    }

    override open class func entity(managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: self.entityName(), in: managedObjectContext)
    }

    @nonobjc
    open class func fetchRequest() -> NSFetchRequest<CD_LoyaltyCardPllLink> {
        return NSFetchRequest(entityName: self.entityName())
    }

    // MARK: - Life cycle methods

    public override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

    public convenience init?(managedObjectContext: NSManagedObjectContext) {
        guard let entity = _CD_LoyaltyCardPllLink.entity(managedObjectContext: managedObjectContext) else { return nil }
        self.init(entity: entity, insertInto: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged open
    var paymentAccountID: NSNumber?

    @NSManaged open
    var paymentScheme: String?

    @NSManaged open
    var status: String?

    // MARK: - Relationships

    @NSManaged open
    var loyaltyCard: CD_LoyaltyCard?

}

