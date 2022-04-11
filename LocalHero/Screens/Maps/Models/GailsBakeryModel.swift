//
//  GailsBakeryModel.swift
//  LocalHero
//
//  Created by Sean Williams on 11/04/2022.
//

import MapKit
import Foundation

// MARK: - Gails Bread
struct GailsBread: Codable {
    let type: String
    let features: [BakeryModel]
}

// MARK: - Feature
struct BakeryModel: Codable, Identifiable {
    var id: UUID? {
        return UUID()
    }
    let type: FeatureType
    let properties: Properties
    let geometry: Geometry
    
    var location: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: geometry.coordinates[1], longitude: geometry.coordinates[0])
    }
}

// MARK: - Geometry
struct Geometry: Codable {
    let type: GeometryType
    let coordinates: [Double]
}

enum GeometryType: String, Codable {
    case point = "Point"
}

// MARK: - Properties
struct Properties: Codable {
    let placekey: String?
    let parentPlacekey: ParentPlacekey?
    let locationName: Brands?
    let safegraphBrandIDS: SafegraphBrandIDS?
    let brands: Brands?
    let topCategory: TopCategory?
    let subCategory: SubCategory?
    let naicsCode: Int?
    let streetAddress, city, region, postalCode: String?
    let isoCountryCode: ISOCountryCode?
    let phoneNumber, openHours, categoryTags, openedOn: String?
    let closedOn, trackingClosedSince: String?
    let geometryType: GeometryTypeEnum?

    enum CodingKeys: String, CodingKey {
        case placekey
        case parentPlacekey = "parent_placekey"
        case locationName = "location_name"
        case safegraphBrandIDS = "safegraph_brand_ids"
        case brands
        case topCategory = "top_category"
        case subCategory = "sub_category"
        case naicsCode = "naics_code"
        case streetAddress = "street_address"
        case city, region
        case postalCode = "postal_code"
        case isoCountryCode = "iso_country_code"
        case phoneNumber = "phone_number"
        case openHours = "open_hours"
        case categoryTags = "category_tags"
        case openedOn = "opened_on"
        case closedOn = "closed_on"
        case trackingClosedSince = "tracking_closed_since"
        case geometryType = "geometry_type"
    }
}

enum Brands: String, Codable {
    case gailSBread = "GAIL's Bread"
}

enum GeometryTypeEnum: String, Codable {
    case polygon = "POLYGON"
}

enum ISOCountryCode: String, Codable {
    case gb = "GB"
}

enum ParentPlacekey: String, Codable {
    case empty = ""
    case the22P2264Hq8MSPsq = "22p-226@4hq-8ms-psq"
    case zzw2224Hj23JDvz = "zzw-222@4hj-23j-dvz"
    case zzw2274Hq53TY5F = "zzw-227@4hq-53t-y5f"
    case zzy22M4Hk4RtKxq = "zzy-22m@4hk-4rt-kxq"
    case zzy22R4Hq4KpQvf = "zzy-22r@4hq-4kp-qvf"
}

enum SafegraphBrandIDS: String, Codable {
    case sgBRAND1978982F6D2Eb698 = "SG_BRAND_1978982f6d2eb698"
}

enum SubCategory: String, Codable {
    case snackAndNonalcoholicBeverageBars = "Snack and Nonalcoholic Beverage Bars"
}

enum TopCategory: String, Codable {
    case restaurantsAndOtherEatingPlaces = "Restaurants and Other Eating Places"
}

enum FeatureType: String, Codable {
    case feature = "Feature"
}
