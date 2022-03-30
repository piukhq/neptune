// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CD_LoyaltyCard.swift instead.

import Foundation
import CoreData

public enum CD_LoyaltyCardAttributes: String {
    case loyaltyPlanID = "loyaltyPlanID"
}

public enum CD_LoyaltyCardRelationships: String {
    case balance = "balance"
    case card = "card"
    case pllLink = "pllLink"
    case status = "status"
    case transaction = "transaction"
    case voucher = "voucher"
    case wallet = "wallet"
}

open class _CD_LoyaltyCard: CD_BaseObject {

    // MARK: - Class methods

    override open class func entityName () -> String {
        return "CD_LoyaltyCard"
    }

    override open class func entity(managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: self.entityName(), in: managedObjectContext)
    }

    @nonobjc
    open class func fetchRequest() -> NSFetchRequest<CD_LoyaltyCard> {
        return NSFetchRequest(entityName: self.entityName())
    }

    // MARK: - Life cycle methods

    public override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

    public convenience init?(managedObjectContext: NSManagedObjectContext) {
        guard let entity = _CD_LoyaltyCard.entity(managedObjectContext: managedObjectContext) else { return nil }
        self.init(entity: entity, insertInto: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged open
    var loyaltyPlanID: NSNumber?

    // MARK: - Relationships

    @NSManaged open
    var balance: CD_LoyaltyCardBalance?

    @NSManaged open
    var card: CD_LoyaltyCardCard?

    @NSManaged open
    var pllLink: NSSet

    open func pllLinkSet() -> NSMutableSet {
        return self.pllLink.mutableCopy() as! NSMutableSet
    }

    @NSManaged open
    var status: CD_Status?

    @NSManaged open
    var transaction: NSSet

    open func transactionSet() -> NSMutableSet {
        return self.transaction.mutableCopy() as! NSMutableSet
    }

    @NSManaged open
    var voucher: NSSet

    open func voucherSet() -> NSMutableSet {
        return self.voucher.mutableCopy() as! NSMutableSet
    }

    @NSManaged open
    var wallet: CD_Wallet?

}

extension _CD_LoyaltyCard {

    open func addPllLink(_ objects: NSSet) {
        let mutable = self.pllLink.mutableCopy() as! NSMutableSet
        mutable.union(objects as Set<NSObject>)
        self.pllLink = mutable.copy() as! NSSet
    }

    open func removePllLink(_ objects: NSSet) {
        let mutable = self.pllLink.mutableCopy() as! NSMutableSet
        mutable.minus(objects as Set<NSObject>)
        self.pllLink = mutable.copy() as! NSSet
    }

    open func addPllLinkObject(_ value: CD_LoyaltyCardPllLink) {
        let mutable = self.pllLink.mutableCopy() as! NSMutableSet
        mutable.add(value)
        self.pllLink = mutable.copy() as! NSSet
    }

    open func removePllLinkObject(_ value: CD_LoyaltyCardPllLink) {
        let mutable = self.pllLink.mutableCopy() as! NSMutableSet
        mutable.remove(value)
        self.pllLink = mutable.copy() as! NSSet
    }

}

extension _CD_LoyaltyCard {

    open func addTransaction(_ objects: NSSet) {
        let mutable = self.transaction.mutableCopy() as! NSMutableSet
        mutable.union(objects as Set<NSObject>)
        self.transaction = mutable.copy() as! NSSet
    }

    open func removeTransaction(_ objects: NSSet) {
        let mutable = self.transaction.mutableCopy() as! NSMutableSet
        mutable.minus(objects as Set<NSObject>)
        self.transaction = mutable.copy() as! NSSet
    }

    open func addTransactionObject(_ value: CD_LoyaltyCardTransaction) {
        let mutable = self.transaction.mutableCopy() as! NSMutableSet
        mutable.add(value)
        self.transaction = mutable.copy() as! NSSet
    }

    open func removeTransactionObject(_ value: CD_LoyaltyCardTransaction) {
        let mutable = self.transaction.mutableCopy() as! NSMutableSet
        mutable.remove(value)
        self.transaction = mutable.copy() as! NSSet
    }

}

extension _CD_LoyaltyCard {

    open func addVoucher(_ objects: NSSet) {
        let mutable = self.voucher.mutableCopy() as! NSMutableSet
        mutable.union(objects as Set<NSObject>)
        self.voucher = mutable.copy() as! NSSet
    }

    open func removeVoucher(_ objects: NSSet) {
        let mutable = self.voucher.mutableCopy() as! NSMutableSet
        mutable.minus(objects as Set<NSObject>)
        self.voucher = mutable.copy() as! NSSet
    }

    open func addVoucherObject(_ value: CD_Voucher) {
        let mutable = self.voucher.mutableCopy() as! NSMutableSet
        mutable.add(value)
        self.voucher = mutable.copy() as! NSSet
    }

    open func removeVoucherObject(_ value: CD_Voucher) {
        let mutable = self.voucher.mutableCopy() as! NSMutableSet
        mutable.remove(value)
        self.voucher = mutable.copy() as! NSSet
    }

}

