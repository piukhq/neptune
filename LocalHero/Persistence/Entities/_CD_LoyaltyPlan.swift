// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CD_LoyaltyPlan.swift instead.

import Foundation
import CoreData

public enum CD_LoyaltyPlanAttributes: String {
    case planPopularity = "planPopularity"
}

public enum CD_LoyaltyPlanRelationships: String {
    case content = "content"
    case features = "features"
    case images = "images"
    case journeyFields = "journeyFields"
    case loyaltyCard = "loyaltyCard"
}

open class _CD_LoyaltyPlan: CD_BaseObject {

    // MARK: - Class methods

    override open class func entityName () -> String {
        return "CD_LoyaltyPlan"
    }

    override open class func entity(managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: self.entityName(), in: managedObjectContext)
    }

    @nonobjc
    open class func fetchRequest() -> NSFetchRequest<CD_LoyaltyPlan> {
        return NSFetchRequest(entityName: self.entityName())
    }

    // MARK: - Life cycle methods

    public override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

    public convenience init?(managedObjectContext: NSManagedObjectContext) {
        guard let entity = _CD_LoyaltyPlan.entity(managedObjectContext: managedObjectContext) else { return nil }
        self.init(entity: entity, insertInto: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged open
    var planPopularity: NSNumber?

    // MARK: - Relationships

    @NSManaged open
    var content: NSSet

    open func contentSet() -> NSMutableSet {
        return self.content.mutableCopy() as! NSMutableSet
    }

    @NSManaged open
    var features: CD_LoyaltyPlanFeatures?

    @NSManaged open
    var images: NSSet

    open func imagesSet() -> NSMutableSet {
        return self.images.mutableCopy() as! NSMutableSet
    }

    @NSManaged open
    var journeyFields: CD_JourneyFields?

    @NSManaged open
    var loyaltyCard: NSSet

    open func loyaltyCardSet() -> NSMutableSet {
        return self.loyaltyCard.mutableCopy() as! NSMutableSet
    }

}

extension _CD_LoyaltyPlan {

    open func addContent(_ objects: NSSet) {
        let mutable = self.content.mutableCopy() as! NSMutableSet
        mutable.union(objects as Set<NSObject>)
        self.content = mutable.copy() as! NSSet
    }

    open func removeContent(_ objects: NSSet) {
        let mutable = self.content.mutableCopy() as! NSMutableSet
        mutable.minus(objects as Set<NSObject>)
        self.content = mutable.copy() as! NSSet
    }

    open func addContentObject(_ value: CD_Content) {
        let mutable = self.content.mutableCopy() as! NSMutableSet
        mutable.add(value)
        self.content = mutable.copy() as! NSSet
    }

    open func removeContentObject(_ value: CD_Content) {
        let mutable = self.content.mutableCopy() as! NSMutableSet
        mutable.remove(value)
        self.content = mutable.copy() as! NSSet
    }

}

extension _CD_LoyaltyPlan {

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

extension _CD_LoyaltyPlan {

    open func addLoyaltyCard(_ objects: NSSet) {
        let mutable = self.loyaltyCard.mutableCopy() as! NSMutableSet
        mutable.union(objects as Set<NSObject>)
        self.loyaltyCard = mutable.copy() as! NSSet
    }

    open func removeLoyaltyCard(_ objects: NSSet) {
        let mutable = self.loyaltyCard.mutableCopy() as! NSMutableSet
        mutable.minus(objects as Set<NSObject>)
        self.loyaltyCard = mutable.copy() as! NSSet
    }

    open func addLoyaltyCardObject(_ value: CD_LoyaltyCard) {
        let mutable = self.loyaltyCard.mutableCopy() as! NSMutableSet
        mutable.add(value)
        self.loyaltyCard = mutable.copy() as! NSSet
    }

    open func removeLoyaltyCardObject(_ value: CD_LoyaltyCard) {
        let mutable = self.loyaltyCard.mutableCopy() as! NSMutableSet
        mutable.remove(value)
        self.loyaltyCard = mutable.copy() as! NSSet
    }

}

