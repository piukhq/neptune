// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CD_LoyaltyPlanDetails.swift instead.

import Foundation
import CoreData

public enum CD_LoyaltyPlanDetailsAttributes: String {
    case category = "category"
    case companyName = "companyName"
    case joinIncentive = "joinIncentive"
    case planDescription = "planDescription"
    case planLabel = "planLabel"
    case planName = "planName"
    case planRegisterInfo = "planRegisterInfo"
    case planSummary = "planSummary"
    case planURL = "planURL"
    case redeemInstructions = "redeemInstructions"
}

public enum CD_LoyaltyPlanDetailsRelationships: String {
    case tiers = "tiers"
}

open class _CD_LoyaltyPlanDetails: CD_BaseObject {

    // MARK: - Class methods

    override open class func entityName () -> String {
        return "CD_LoyaltyPlanDetails"
    }

    override open class func entity(managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: self.entityName(), in: managedObjectContext)
    }

    @nonobjc
    open class func fetchRequest() -> NSFetchRequest<CD_LoyaltyPlanDetails> {
        return NSFetchRequest(entityName: self.entityName())
    }

    // MARK: - Life cycle methods

    public override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

    public convenience init?(managedObjectContext: NSManagedObjectContext) {
        guard let entity = _CD_LoyaltyPlanDetails.entity(managedObjectContext: managedObjectContext) else { return nil }
        self.init(entity: entity, insertInto: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged open
    var category: String?

    @NSManaged open
    var companyName: String?

    @NSManaged open
    var joinIncentive: String?

    @NSManaged open
    var planDescription: String?

    @NSManaged open
    var planLabel: String?

    @NSManaged open
    var planName: String?

    @NSManaged open
    var planRegisterInfo: String?

    @NSManaged open
    var planSummary: String?

    @NSManaged open
    var planURL: String?

    @NSManaged open
    var redeemInstructions: String?

    // MARK: - Relationships

    @NSManaged open
    var tiers: NSSet

    open func tiersSet() -> NSMutableSet {
        return self.tiers.mutableCopy() as! NSMutableSet
    }

}

extension _CD_LoyaltyPlanDetails {

    open func addTiers(_ objects: NSSet) {
        let mutable = self.tiers.mutableCopy() as! NSMutableSet
        mutable.union(objects as Set<NSObject>)
        self.tiers = mutable.copy() as! NSSet
    }

    open func removeTiers(_ objects: NSSet) {
        let mutable = self.tiers.mutableCopy() as! NSMutableSet
        mutable.minus(objects as Set<NSObject>)
        self.tiers = mutable.copy() as! NSSet
    }

    open func addTiersObject(_ value: CD_Tier) {
        let mutable = self.tiers.mutableCopy() as! NSMutableSet
        mutable.add(value)
        self.tiers = mutable.copy() as! NSSet
    }

    open func removeTiersObject(_ value: CD_Tier) {
        let mutable = self.tiers.mutableCopy() as! NSMutableSet
        mutable.remove(value)
        self.tiers = mutable.copy() as! NSSet
    }

}

