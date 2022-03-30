// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CD_PaymentAccountPllLink.swift instead.

import Foundation
import CoreData

public enum CD_PaymentAccountPllLinkAttributes: String {
    case loyaltyCardID = "loyaltyCardID"
    case loyaltyPlan = "loyaltyPlan"
    case status = "status"
}

public enum CD_PaymentAccountPllLinkRelationships: String {
    case paymentAccount = "paymentAccount"
}

open class _CD_PaymentAccountPllLink: CD_BaseObject {

    // MARK: - Class methods

    override open class func entityName () -> String {
        return "CD_PaymentAccountPllLink"
    }

    override open class func entity(managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: self.entityName(), in: managedObjectContext)
    }

    @nonobjc
    open class func fetchRequest() -> NSFetchRequest<CD_PaymentAccountPllLink> {
        return NSFetchRequest(entityName: self.entityName())
    }

    // MARK: - Life cycle methods

    public override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

    public convenience init?(managedObjectContext: NSManagedObjectContext) {
        guard let entity = _CD_PaymentAccountPllLink.entity(managedObjectContext: managedObjectContext) else { return nil }
        self.init(entity: entity, insertInto: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged open
    var loyaltyCardID: NSNumber?

    @NSManaged open
    var loyaltyPlan: String?

    @NSManaged open
    var status: String?

    // MARK: - Relationships

    @NSManaged open
    var paymentAccount: CD_PaymentAccount?

}

