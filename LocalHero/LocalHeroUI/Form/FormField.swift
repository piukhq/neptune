//
//  FormField.swift
//  LocalHero
//
//  Created by Sean Williams on 07/03/2022.
//

import UIKit

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

struct FormPickerData: Equatable {
    let title: String
    let backingData: Int?
    
    init?(_ title: String?, backingData: Int? = nil) {
        guard let title = title else { return nil }
        
        self.title = title
        self.backingData = backingData
    }
}

class FormField {
    enum FieldInputType: Equatable {
        case text
        case paymentAccountNumber
        case choice
        case string
        case sensitive
        case expiry(months: [FormPickerData], years: [FormPickerData])
        case email
        case phone
        
        var isSecureTextEntry: Bool {
            switch self {
            case .sensitive:
                return true
            default:
                return false
            }
        }
        
        func capitalization() -> UITextAutocapitalizationType {
            switch self {
            case .text:
                return .words
            default:
                return .none
            }
        }
        
        func keyboardType() -> UIKeyboardType {
            switch self {
            case .text, .sensitive:
                return .default
            case .paymentAccountNumber:
                return .numberPad
            case .email:
                return .emailAddress
            case .phone:
                return .phonePad
            default:
                return .default
            }
        }
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
    let valueUpdated: ValueUpdatedBlock
    let fieldExited: FieldExitedBlock
    let pickerOptionsUpdated: PickerUpdatedBlock?
    let shouldChange: TextFieldShouldChange
    let manualValidate: ManualValidateBlock?
    let dataSourceRefreshBlock: DataSourceRefreshBlock?
    private(set) var value: String?
    
    typealias ValueUpdatedBlock = (FormField, String?) -> Void
    typealias PickerUpdatedBlock = (FormField, [Any]) -> Void
    typealias TextFieldShouldChange = (FormField, UITextField, NSRange, String?) -> (Bool)
    typealias FieldExitedBlock = (FormField) -> Void
    typealias ManualValidateBlock = (FormField) -> (Bool)
    typealias DataSourceRefreshBlock = () -> Void

    init(title: String, placeholder: String, validation: String?, validationErrorMessage: String? = nil, fieldType: FieldInputType, value: String? = nil, updated: @escaping ValueUpdatedBlock, shouldChange: @escaping TextFieldShouldChange, fieldExited: @escaping FieldExitedBlock, pickerSelected: PickerUpdatedBlock? = nil, manualValidate: ManualValidateBlock? = nil, forcedValue: String? = nil, isReadOnly: Bool = false, fieldCommonName: FieldCommonName? = nil, alternatives: [FieldCommonName]? = nil, dataSourceRefreshBlock: DataSourceRefreshBlock? = nil, hidden: Bool = false) {
        self.title = title
        self.placeholder = placeholder
        self.validation = validation
        self.validationErrorMessage = validationErrorMessage
        self.fieldType = fieldType
        self.value = value
        self.valueUpdated = updated
        self.shouldChange = shouldChange
        self.fieldExited = fieldExited
        self.pickerOptionsUpdated = pickerSelected
        self.manualValidate = manualValidate
        self.forcedValue = forcedValue
        self.value = forcedValue // Initialise the field's value with any forced value. If there isn't a forced value, the value will default to nil as normal.
        self.isReadOnly = isReadOnly
        self.fieldCommonName = fieldCommonName
        self.alternatives = alternatives
        self.dataSourceRefreshBlock = dataSourceRefreshBlock
        self.hidden = hidden
    }
    
//    func isValid() -> Bool {
//        // If the field has manual validation, apply it
//        if let validateBlock = manualValidate {
//            return validateBlock(self)
//        }
//        
//        // If our value is unset then we do not pass the validation check
//        guard let value = value else { return false }
//        
//        if fieldType == .paymentAccountNumber {
//            return PaymentCardType.validate(fullPan: value)
//        } else {
//            guard let validation = validation else { return !value.isEmpty || !value.isBlank }
//            
//            let predicate = NSPredicate(format: "SELF MATCHES %@", validation)
//            return predicate.evaluate(with: value)
//        }
//    }
    
    func updateValue(_ value: String?) {
        self.value = value
        valueUpdated(self, value)
    }
    
    func pickerDidSelect(_ options: [Any]) {
        pickerOptionsUpdated?(self, options)
    }
    
    func fieldWasExited() {
        fieldExited(self)
    }
    
    func textField(_ textField: UITextField, shouldChangeInRange: NSRange, newValue: String?) -> Bool {
        return shouldChange(self, textField, shouldChangeInRange, newValue)
    }
}
