//
//  FormField.swift
//  LocalHero
//
//  Created by Sean Williams on 07/03/2022.
//

import Foundation

enum FieldCommonName: String, Codable {
    case email
    case username
    case password
    case placeOfBirth = "place_of_birth"
    case postcode
    case title
    case firstName = "first_name"
    case lastName = "last_name"
    case favoritePlace = "favorite_place"
    case gender
    case address1 = "address_1"
    case address2 = "address_2"
    case address3 = "address_3"
    case townCity = "town_city"
    case county
    case country
    case phoneNumber = "phone"
    case dateOfBirth = "date_of_birth"
    case memorableDate = "memorable_date"
    case barcode
    case pan
}

class FormField: Identifiable {
    enum FieldInputType {
        case text
        case paymentAccountNumber
        case expiry
        case choice
        case string
    }
    
    let title: String
    let placeholder: String
    let validation: String?
    let validationErrorMessage: String?
    let fieldType: FieldInputType
    let forcedValue: String?
    let isReadOnly: Bool
    let fieldCommonName: FieldCommonName?
    let alternatives: [FieldCommonName]?
    let hidden: Bool
    private(set) var value: String?
    
    init(title: String, placeholder: String, validation: String?, validationErrorMessage: String? = nil, fieldType: FieldInputType, value: String? = nil, forcedValue: String? = nil, isReadOnly: Bool = false, fieldCommonName: FieldCommonName? = nil, alternatives: [FieldCommonName]? = nil, hidden: Bool = false) {
        self.title = title
        self.placeholder = placeholder
        self.validation = validation
        self.validationErrorMessage = validationErrorMessage
        self.fieldType = fieldType
        self.value = value
        self.forcedValue = forcedValue
        self.value = forcedValue // Initialise the field's value with any forced value. If there isn't a forced value, the value will default to nil as normal.
        self.isReadOnly = isReadOnly
        self.fieldCommonName = fieldCommonName
        self.alternatives = alternatives
        self.hidden = hidden
    }
}
