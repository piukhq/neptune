//
//  FormDataSource.swift
//  LocalHero
//
//  Created by Sean Williams on 08/03/2022.
//

import Foundation
import UIKit

class FormDataSource: NSObject {
    var fields: [FormField] = []
}

extension FormDataSource {
    convenience init(model: PaymentAccountCreateModel) {
        self.init()
        
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
            forcedValue: model.fullPan,
            fieldCommonName: .pan)
        
        let nameOnCardField = FormField(
            title: "Name on card",
            placeholder: "J Appleseed",
            validation: "^(((?=.{1,}$)[A-Za-z\\-\\u00C0-\\u00FF' ])+\\s*)$",
            fieldType: .text
        )
        
        let nickNameField = FormField(
            title: "Nickname",
            placeholder: "",
            validation: "^(((?=.{1,}$)[A-Za-z\\-\\u00C0-\\u00FF' ])+\\s*)$",
            fieldType: .text
        )
        
        let expiryField = FormField(
            title: "Expiry",
            placeholder: "MM/YY",
            validation: "^(0[1-9]|1[012])[\\/](19|20)\\d\\d$",
            validationErrorMessage: "Invalid expiry date",
            fieldType: .expiry(months: monthData, years: yearData),

            /// It's fine to force unwrap here, as we are already guarding against the values being nil and we don't want to provide default values
            /// We will never reach the force unwrapping if either value is nil
            forcedValue: model.expiryMonth == nil || model.expiryYear == nil ? nil : "\(String(format: "%02d", model.expiryMonth ?? 0))/\(model.expiryYear ?? "0")"
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
        }
        return cell
    }
}

extension FormDataSource: FormCollectionViewCellDelegate {
    func formCollectionViewCell(_ cell: FormCollectionViewCell, didSelectField: UITextField) {
        print("did select field")
    }
    
    func formCollectionViewCell(_ cell: FormCollectionViewCell, shouldResignTextField textField: UITextField) {
        print("Should resign field")
    }
}
