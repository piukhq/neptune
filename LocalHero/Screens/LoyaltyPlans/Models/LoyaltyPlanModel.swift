//
//  LoyaltyPlans.swift
//  Local Hero
//
//  Created by Sean Williams on 10/12/2021.
//

import Foundation


// MARK: - Welcome
struct LoyaltyPlanModel: Codable {
    let loyaltyPlanID: Int?
    let planPopularity: Int?
    let planFeatures: PlanFeatures?
    let images: [Image]?
    let planDetails: PlanDetails?
    let journeyFields: JourneyFieldsModel?
    let content: [Content]?

    enum CodingKeys: String, CodingKey {
        case loyaltyPlanID = "loyalty_plan_id"
        case planPopularity = "plan_popularity"
        case planFeatures = "plan_features"
        case images, content
        case planDetails = "plan_details"
        case journeyFields = "journey_fields"
    }
}

// MARK: - PlanDetails
struct PlanDetails: Codable {
    let companyName, planName, planLabel: String?
    let planURL: String?
    let planSummary, planDescription, redeemInstructions, planRegisterInfo: String?
    let joinIncentive, category: String?
    let tiers: [Tier]?

    enum CodingKeys: String, CodingKey {
        case companyName = "company_name"
        case planName = "plan_name"
        case planLabel = "plan_label"
        case planURL = "plan_url"
        case planSummary = "plan_summary"
        case planDescription = "plan_description"
        case redeemInstructions = "redeem_instructions"
        case planRegisterInfo = "plan_register_info"
        case joinIncentive = "join_incentive"
        case category, tiers
    }
}

struct Tier: Codable {
    let name: String?
    let description: String?
}

// MARK: - Image
struct Image: Codable {
    let id, type: Int?
    let url: String?
    let imageDescription, encoding: String?

    enum CodingKeys: String, CodingKey {
        case id, type, url
        case imageDescription = "description"
        case encoding
    }
}

struct Content: Codable {
    let column: String?
    let value: String?
}

// MARK: - PlanFeatures
struct PlanFeatures: Codable {
    let hasPoints, hasTransactions: Bool?
    let planType, barcodeType: Int?
    let colour: String?
    let journeys: [Journey]?

    enum CodingKeys: String, CodingKey {
        case hasPoints = "has_points"
        case hasTransactions = "has_transactions"
        case planType = "plan_type"
        case barcodeType = "barcode_type"
        case colour, journeys
    }
}

struct Journey: Codable {
    let type: Int?
    let description: String?
}

struct JourneyFieldsModel: Codable {
    let loyaltyPlanID: Int?
    let registerGhostCardFields: FieldsModel?
    let joinFields: FieldsModel?
    let addFields: FieldsModel?
    let authoriseFields: FieldsModel?

    enum CodingKeys: String, CodingKey {
        case loyaltyPlanID = "loyalty_plan_id"
        case registerGhostCardFields = "register_ghost_card_fields"
        case joinFields = "join_fields"
        case addFields = "add_fields"
        case authoriseFields = "authorise_fields"
    }
}

struct FieldsModel: Codable {
    let credentials: [Credentials]?
    let planDocuments: [PlanDocument]?
    let consents: [Consents]?

    enum CodingKeys: String, CodingKey {
        case credentials
        case planDocuments = "plan_documents"
        case consents
    }
}

// MARK: - Credential
class Credentials: Codable {
    let order: Int?
    let displayLabel: String?
    let validation: String?
    let credentialDescription, credentialSlug: String?
    let type: String?
    let isSensitive: Bool?
    let choice: [String]?
    let alternative: Credentials?
    var value: String?

    enum CodingKeys: String, CodingKey {
        case order
        case displayLabel = "display_label"
        case validation
        case credentialDescription = "description"
        case credentialSlug = "credential_slug"
        case type
        case isSensitive = "is_sensitive"
        case choice, alternative
    }

    init(order: Int?, displayLabel: String?, validation: String?, credentialDescription: String?, credentialSlug: String?, type: String?, isSensitive: Bool?, choice: [String]?, alternative: Credentials?) {
        self.order = order
        self.displayLabel = displayLabel
        self.validation = validation
        self.credentialDescription = credentialDescription
        self.credentialSlug = credentialSlug
        self.type = type
        self.isSensitive = isSensitive
        self.choice = choice
        self.alternative = alternative
    }
}

enum TypeEnum: String, Codable {
    case choice = "choice"
    case string = "string"
    case text = "text"
}

// MARK: - PlanDocument
struct PlanDocument: Codable {
    let name: String?
    let url: String?
    let isAcceptanceRequired: Bool?
    let order: Int?
    let planDocumentDescription: String?

    enum CodingKeys: String, CodingKey {
        case name, url
        case isAcceptanceRequired = "is_acceptance_required"
        case order
        case planDocumentDescription = "description"
    }
}

// MARK: - Ent
struct Consents: Codable {
    let consentSlug: String?
    let isAcceptanceRequired: Bool?
    let order: Int?
    let entDescription, name: String?
    let url: String?

    enum CodingKeys: String, CodingKey {
        case consentSlug = "consent_slug"
        case isAcceptanceRequired = "is_acceptance_required"
        case order
        case entDescription = "description"
        case name, url
    }
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    func hash(into hasher: inout Hasher) {}

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
