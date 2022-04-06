// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CD_PaymentAccount.swift instead.

import Foundation
import CoreData

public enum CD_PaymentAccountAttributes: String {
    case cardNickname = "cardNickname"
    case expiryMonth = "expiryMonth"
    case expiryYear = "expiryYear"
    case firstSix = "firstSix"
    case lastFour = "lastFour"
    case nameOnCard = "nameOnCard"
    case provider = "provider"
    case status = "status"
}

public enum CD_PaymentAccountRelationships: String {
    case images = "images"
    case pllLinks = "pllLinks"
    case wallet = "wallet"
}

open class _CD_PaymentAccount: CD_BaseObject {

    // MARK: - Class methods

    override open class func entityName () -> String {
        return "CD_PaymentAccount"
    }

    override open class func entity(managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: self.entityName(), in: managedObjectContext)
    }

    @nonobjc
    open class func fetchRequest() -> NSFetchRequest<CD_PaymentAccount> {
        return NSFetchRequest(entityName: self.entityName())
    }

    // MARK: - Life cycle methods

    public override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

    public convenience init?(managedObjectContext: NSManagedObjectContext) {
        guard let entity = _CD_PaymentAccount.entity(managedObjectContext: managedObjectContext) else { return nil }
        self.init(entity: entity, insertInto: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged open
    var cardNickname: String?

    @NSManaged open
    var expiryMonth: String?

    @NSManaged open
    var expiryYear: String?

    @NSManaged open
    var firstSix: String?

    @NSManaged open
    var lastFour: String?

    @NSManaged open
    var nameOnCard: String?

    @NSManaged open
    var provider: String?

    @NSManaged open
    var status: String?

    // MARK: - Relationships

    @NSManaged open
    var images: NSSet

    open func imagesSet() -> NSMutableSet {
        return self.images.mutableCopy() as! NSMutableSet
    }

    @NSManaged open
    var pllLinks: NSSet

    open func pllLinksSet() -> NSMutableSet {
        return self.pllLinks.mutableCopy() as! NSMutableSet
    }

    @NSManaged open
    var wallet: CD_Wallet?

}

extension _CD_PaymentAccount {

    open func addImages(_ objects: NSSet) {
        let mutable = self.images.mutableCopy() as! NSMutableSet
        mutable.union(objects as Set<NSObject>)
        self.images = mutable.copy() as! NSSet
    }

    open func removeImages(_ objects: NSSet) {
        let mutable = self.images.mutableCopy() as! NSMutableSet
        mutable.minus(objects as Set<NSObject>)
        self.images = mutable.copy() as! NSSet
    }

    open func addImagesObject(_ value: CD_Image) {
        let mutable = self.images.mutableCopy() as! NSMutableSet
        mutable.add(value)
        self.images = mutable.copy() as! NSSet
    }

    open func removeImagesObject(_ value: CD_Image) {
        let mutable = self.images.mutableCopy() as! NSMutableSet
        mutable.remove(value)
        self.images = mutable.copy() as! NSSet
    }

}

extension _CD_PaymentAccount {

    open func addPllLinks(_ objects: NSSet) {
        let mutable = self.pllLinks.mutableCopy() as! NSMutableSet
        mutable.union(objects as Set<NSObject>)
        self.pllLinks = mutable.copy() as! NSSet
    }

    open func removePllLinks(_ objects: NSSet) {
        let mutable = self.pllLinks.mutableCopy() as! NSMutableSet
        mutable.minus(objects as Set<NSObject>)
        self.pllLinks = mutable.copy() as! NSSet
    }

    open func addPllLinksObject(_ value: CD_PaymentAccountPllLink) {
        let mutable = self.pllLinks.mutableCopy() as! NSMutableSet
        mutable.add(value)
        self.pllLinks = mutable.copy() as! NSSet
    }

    open func removePllLinksObject(_ value: CD_PaymentAccountPllLink) {
        let mutable = self.pllLinks.mutableCopy() as! NSMutableSet
        mutable.remove(value)
        self.pllLinks = mutable.copy() as! NSSet
    }

}
