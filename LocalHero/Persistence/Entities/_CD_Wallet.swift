// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CD_Wallet.swift instead.

import Foundation
import CoreData

public enum CD_WalletRelationships: String {
    case joins = "joins"
    case loyaltyCards = "loyaltyCards"
    case paymentAccounts = "paymentAccounts"
}

open class _CD_Wallet: CD_BaseObject {

    // MARK: - Class methods

    override open class func entityName () -> String {
        return "CD_Wallet"
    }

    override open class func entity(managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: self.entityName(), in: managedObjectContext)
    }

    @nonobjc
    open class func fetchRequest() -> NSFetchRequest<CD_Wallet> {
        return NSFetchRequest(entityName: self.entityName())
    }

    // MARK: - Life cycle methods

    public override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

    public convenience init?(managedObjectContext: NSManagedObjectContext) {
        guard let entity = _CD_Wallet.entity(managedObjectContext: managedObjectContext) else { return nil }
        self.init(entity: entity, insertInto: managedObjectContext)
    }

    // MARK: - Properties

    // MARK: - Relationships

    @NSManaged open
    var joins: NSSet

    open func joinsSet() -> NSMutableSet {
        return self.joins.mutableCopy() as! NSMutableSet
    }

    @NSManaged open
    var loyaltyCards: NSSet

    open func loyaltyCardsSet() -> NSMutableSet {
        return self.loyaltyCards.mutableCopy() as! NSMutableSet
    }

    @NSManaged open
    var paymentAccounts: NSSet

    open func paymentAccountsSet() -> NSMutableSet {
        return self.paymentAccounts.mutableCopy() as! NSMutableSet
    }

}

extension _CD_Wallet {

    open func addJoins(_ objects: NSSet) {
        let mutable = self.joins.mutableCopy() as! NSMutableSet
        mutable.union(objects as Set<NSObject>)
        self.joins = mutable.copy() as! NSSet
    }

    open func removeJoins(_ objects: NSSet) {
        let mutable = self.joins.mutableCopy() as! NSMutableSet
        mutable.minus(objects as Set<NSObject>)
        self.joins = mutable.copy() as! NSSet
    }

    open func addJoinsObject(_ value: CD_Join) {
        let mutable = self.joins.mutableCopy() as! NSMutableSet
        mutable.add(value)
        self.joins = mutable.copy() as! NSSet
    }

    open func removeJoinsObject(_ value: CD_Join) {
        let mutable = self.joins.mutableCopy() as! NSMutableSet
        mutable.remove(value)
        self.joins = mutable.copy() as! NSSet
    }

}

extension _CD_Wallet {

    open func addLoyaltyCards(_ objects: NSSet) {
        let mutable = self.loyaltyCards.mutableCopy() as! NSMutableSet
        mutable.union(objects as Set<NSObject>)
        self.loyaltyCards = mutable.copy() as! NSSet
    }

    open func removeLoyaltyCards(_ objects: NSSet) {
        let mutable = self.loyaltyCards.mutableCopy() as! NSMutableSet
        mutable.minus(objects as Set<NSObject>)
        self.loyaltyCards = mutable.copy() as! NSSet
    }

    open func addLoyaltyCardsObject(_ value: CD_LoyaltyCard) {
        let mutable = self.loyaltyCards.mutableCopy() as! NSMutableSet
        mutable.add(value)
        self.loyaltyCards = mutable.copy() as! NSSet
    }

    open func removeLoyaltyCardsObject(_ value: CD_LoyaltyCard) {
        let mutable = self.loyaltyCards.mutableCopy() as! NSMutableSet
        mutable.remove(value)
        self.loyaltyCards = mutable.copy() as! NSSet
    }

}

extension _CD_Wallet {

    open func addPaymentAccounts(_ objects: NSSet) {
        let mutable = self.paymentAccounts.mutableCopy() as! NSMutableSet
        mutable.union(objects as Set<NSObject>)
        self.paymentAccounts = mutable.copy() as! NSSet
    }

    open func removePaymentAccounts(_ objects: NSSet) {
        let mutable = self.paymentAccounts.mutableCopy() as! NSMutableSet
        mutable.minus(objects as Set<NSObject>)
        self.paymentAccounts = mutable.copy() as! NSSet
    }

    open func addPaymentAccountsObject(_ value: CD_PaymentAccount) {
        let mutable = self.paymentAccounts.mutableCopy() as! NSMutableSet
        mutable.add(value)
        self.paymentAccounts = mutable.copy() as! NSSet
    }

    open func removePaymentAccountsObject(_ value: CD_PaymentAccount) {
        let mutable = self.paymentAccounts.mutableCopy() as! NSMutableSet
        mutable.remove(value)
        self.paymentAccounts = mutable.copy() as! NSSet
    }

}

