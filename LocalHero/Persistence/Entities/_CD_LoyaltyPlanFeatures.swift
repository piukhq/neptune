// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CD_LoyaltyPlanFeatures.swift instead.

import Foundation
import CoreData

public enum CD_LoyaltyPlanFeaturesAttributes: String {
    case barcodeType = "barcodeType"
    case colour = "colour"
    case hasPoints = "hasPoints"
    case hasTransactions = "hasTransactions"
    case planType = "planType"
}

public enum CD_LoyaltyPlanFeaturesRelationships: String {
    case journey = "journey"
    case plan = "plan"
}

open class _CD_LoyaltyPlanFeatures: CD_BaseObject {

    // MARK: - Class methods

    override open class func entityName () -> String {
        return "CD_LoyaltyPlanFeatures"
    }

    override open class func entity(managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: self.entityName(), in: managedObjectContext)
    }

    @nonobjc
    open class func fetchRequest() -> NSFetchRequest<CD_LoyaltyPlanFeatures> {
        return NSFetchRequest(entityName: self.entityName())
    }

    // MARK: - Life cycle methods

    public override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

    public convenience init?(managedObjectContext: NSManagedObjectContext) {
        guard let entity = _CD_LoyaltyPlanFeatures.entity(managedObjectContext: managedObjectContext) else { return nil }
        self.init(entity: entity, insertInto: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged open
    var barcodeType: NSNumber?

    @NSManaged open
    var colour: String?

    @NSManaged open
    var hasPoints: Bool // Optional scalars not supported

    @NSManaged open
    var hasTransactions: Bool // Optional scalars not supported

    @NSManaged open
    var planType: NSNumber?

    // MARK: - Relationships

    @NSManaged open
    var journey: NSSet

    open func journeySet() -> NSMutableSet {
        return self.journey.mutableCopy() as! NSMutableSet
    }

    @NSManaged open
    var plan: CD_LoyaltyPlan?

}

extension _CD_LoyaltyPlanFeatures {

    open func addJourney(_ objects: NSSet) {
        let mutable = self.journey.mutableCopy() as! NSMutableSet
        mutable.union(objects as Set<NSObject>)
        self.journey = mutable.copy() as! NSSet
    }

    open func removeJourney(_ objects: NSSet) {
        let mutable = self.journey.mutableCopy() as! NSMutableSet
        mutable.minus(objects as Set<NSObject>)
        self.journey = mutable.copy() as! NSSet
    }

    open func addJourneyObject(_ value: CD_Journey) {
        let mutable = self.journey.mutableCopy() as! NSMutableSet
        mutable.add(value)
        self.journey = mutable.copy() as! NSSet
    }

    open func removeJourneyObject(_ value: CD_Journey) {
        let mutable = self.journey.mutableCopy() as! NSMutableSet
        mutable.remove(value)
        self.journey = mutable.copy() as! NSSet
    }

}

