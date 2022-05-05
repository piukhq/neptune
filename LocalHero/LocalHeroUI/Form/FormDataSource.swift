//
//  FormDataSource.swift
//  LocalHero
//
//  Created by Sean Williams on 08/03/2022.
//

import Foundation
import UIKit
import SwiftUI

protocol FormDataSourceDelegate: NSObjectProtocol {
    func formDataSource(_ dataSource: FormDataSource, changed value: String?, for field: FormField)
    func formDataSource(_ dataSource: FormDataSource, selected options: [Any], for field: FormField)
    func formDataSource(_ dataSource: FormDataSource, textField: UITextField, shouldChangeTo newValue: String?, in range: NSRange, for field: FormField) -> Bool
    func formDataSource(_ dataSource: FormDataSource, fieldDidExit: FormField)
    func formDataSource(_ dataSource: FormDataSource, manualValidate field: FormField) -> Bool
    func formDataSourceShouldScrollToBottom(_ dataSource: FormDataSource)
    func formDataSourceShouldRefresh(_ dataSource: FormDataSource)
    
}

extension FormDataSourceDelegate {
    func formDataSource(_ dataSource: FormDataSource, changed value: String?, for field: FormField) {}
    func formDataSource(_ dataSource: FormDataSource, selected options: [Any], for field: FormField) {}
    func formDataSource(_ dataSource: FormDataSource, fieldDidExit: FormField) {}
    func formDataSource(_ dataSource: FormDataSource, manualValidate field: FormField) -> Bool {
        return false
    }
    func formDataSourceShouldScrollToBottom(_ dataSource: FormDataSource) {}
    func formDataSourceShouldRefresh(_ dataSource: FormDataSource) {}
}


class FormDataSource: NSObject {
    var fields: [FormField] = []
    private var cellTextFields: [Int: UITextField] = [:]
    
    typealias MultiDelegate = FormDataSourceDelegate & FormCollectionViewCellDelegate
    weak var delegate: MultiDelegate?
    
    var fullFormIsValid: Bool {
        return fields.allSatisfy({ $0.isValid() })
    }
}

extension FormDataSource {
    convenience init(model: PaymentAccountCreateModel) {
        self.init()
        
        let updatedBlock: FormField.ValueUpdatedBlock = { [weak self] field, newValue in
            guard let self = self else { return }
            self.delegate?.formDataSource(self, changed: newValue, for: field)
        }
        
        let shouldChangeBlock: FormField.TextFieldShouldChange = { [weak self] (field, textField, range, newValue) in
            guard let self = self, let delegate = self.delegate else { return true }
            return delegate.formDataSource(self, textField: textField, shouldChangeTo: newValue, in: range, for: field)
        }
        
        let pickerUpdatedBlock: FormField.PickerUpdatedBlock = { [weak self] field, options in
            guard let self = self else { return }
            self.delegate?.formDataSource(self, selected: options, for: field)
        }
        
        let fieldExitedBlock: FormField.FieldExitedBlock = { [weak self] field in
            guard let self = self else { return }
            self.delegate?.formDataSource(self, fieldDidExit: field)
        }

        let manualValidateBlock: FormField.ManualValidateBlock = { [weak self] field in
            guard let self = self, let delegate = self.delegate else { return false }
            return delegate.formDataSource(self, manualValidate: field)
        }
        
        let monthData = Calendar.current.monthSymbols.enumerated().compactMap { index, _ in
            FormPickerData(String(format: "%02d", index + 1), backingData: index + 1)
        }
        
        let yearValue = Calendar.current.component(.year, from: Date())
        let yearData = Array(yearValue...yearValue + 50).compactMap { FormPickerData("\($0)", backingData: $0) }
        
        let cardNumberField = FormField(
            title: "Card Number",
            placeholder: "xxxx xxxx xxxx xxxx",
            validation: nil,
            fieldType: .paymentAccountNumber,
            updated: updatedBlock,
            shouldChange: shouldChangeBlock,
            fieldExited: fieldExitedBlock,
            forcedValue: model.fullPan,
            fieldCommonName: .pan
        )
        
        let nameOnCardField = FormField(
            title: "Name on Card",
            placeholder: "J Appleseed",
            validation: "^(((?=.{1,}$)[A-Za-z\\-\\u00C0-\\u00FF' ])+\\s*)$",
            fieldType: .text,
            updated: updatedBlock,
            shouldChange: shouldChangeBlock,
            fieldExited: fieldExitedBlock
        )
        
        let nickNameField = FormField(
            title: "Nickname",
            placeholder: "My favourite account",
            validation: "^(((?=.{1,}$)[A-Za-z\\-\\u00C0-\\u00FF' ])+\\s*)$",
            fieldType: .paymentAccountNickname,
            updated: updatedBlock,
            shouldChange: shouldChangeBlock,
            fieldExited: fieldExitedBlock
        )
        
        let expiryField = FormField(
            title: "Expiry",
            placeholder: "MM/YY",
            validation: "^(0[1-9]|1[012])[\\/](19|20)\\d\\d$",
            validationErrorMessage: "Invalid expiry date",
            fieldType: .expiry(months: monthData, years: yearData),
            updated: updatedBlock,
            shouldChange: shouldChangeBlock,
            fieldExited: fieldExitedBlock,
            pickerSelected: pickerUpdatedBlock,
            manualValidate: manualValidateBlock,
            /// It's fine to force unwrap here, as we are already guarding against the values being nil and we don't want to provide default values
            /// We will never reach the force unwrapping if either value is nil
            forcedValue: model.expiryMonth == nil || model.expiryYear == nil ? nil : "\(String(format: "%02d", model.expiryMonth ?? 0))/\(model.expiryYear ?? 0)"
        )
        
        fields = [cardNumberField, nameOnCardField, nickNameField, expiryField]
    }
}

extension FormDataSource: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fields.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: FormCollectionViewCell = collectionView.dequeue(indexPath: indexPath)
        
        if let field = fields[safe: indexPath.item] {
            cell.configure(with: field, delegate: self)
            cellTextFields[indexPath.item] = cell.textField
        }
        return cell
    }
}

extension FormDataSource: FormCollectionViewCellDelegate {
    func formCollectionViewCell(_ cell: FormCollectionViewCell, didSelectField: UITextField) {
        delegate?.formCollectionViewCell(cell, didSelectField: didSelectField)
        
        if cellTextFields.first(where: { $0.value == didSelectField })?.key == cellTextFields.count - 1 {
            didSelectField.returnKeyType = .done
        } else {
            didSelectField.returnKeyType = .next
        }
    }
    
    func formCollectionViewCell(_ cell: FormCollectionViewCell, shouldResignTextField textField: UITextField) {
        guard let key = cellTextFields.first(where: { $0.value == textField })?.key else { return }
        
        if let nextTextField = cellTextFields[key + 1] {
            nextTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
    }
    
}
