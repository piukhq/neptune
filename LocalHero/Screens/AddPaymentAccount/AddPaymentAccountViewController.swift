//
//  AddPaymentAccountViewController.swift
//  LocalHero
//
//  Created by Sean Williams on 08/03/2022.
//

import Foundation
import UIKit
import SwiftUI

class AddPaymentAccountViewController: BaseFormViewController {
    private var viewModel: AddPaymentAccountViewModel
    
    private lazy var addAccountButton: HeroButton = {
        return HeroButton(dataSource: dataSource, title: "Add Payment Account", buttonTapped: {
            self.viewModel.addPaymentCard()
        })
    }()
    
    init(viewModel: AddPaymentAccountViewModel) {
        self.viewModel = viewModel
        super.init(dataSource: FormDataSource(model: PaymentAccountCreateModel()))
        dataSource.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add Payment Account"

        addFooterButtons([addAccountButton])
    }
    
    override func formValidityUpdated(fullFormIsValid: Bool) {
//        addAccountButton.disabled = !fullFormIsValid
    }
}

extension AddPaymentAccountViewController: FormDataSourceDelegate {
    func formDataSource(_ dataSource: FormDataSource, textField: UITextField, shouldChangeTo newValue: String?, in range: NSRange, for field: FormField) -> Bool {
        if let type = viewModel.paymentAccountType, let newValue = newValue, let text = textField.text, field.fieldType == .paymentAccountNumber {
            /*
            Potentially "needlessly" complex, but the below will insert whitespace to format card numbers correctly according
            to the pattern available in PaymentCardType.
            EXAMPLE: 4242424242424242 becomes 4242 4242 4242 4242
            */
            
            if !newValue.isEmpty {
                let values = type.lengthRange()
                let cardLength = values.length + values.whitespaceIndexes.count
                
                if let textFieldText = textField.text, values.whitespaceIndexes.contains(range.location) && !newValue.isEmpty {
                    textField.text = textFieldText + " "
                }
                
                if text.count >= cardLength && range.length == 0 {
                    return false
                } else {
                    let filtered = newValue.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
                    return newValue == filtered
                }
            } else {
                // If newValue length is 0 then we can assume this is a delete, and if the next character after
                // this one is a whitespace string then let's remove it.
                
                let secondToLastCharacterLocation = range.location - 1
                if secondToLastCharacterLocation > 0, text.count > secondToLastCharacterLocation {
                    let stringRange = text.index(text.startIndex, offsetBy: secondToLastCharacterLocation)
                    let secondToLastCharacter = text[stringRange]
                    
                    if secondToLastCharacter == " " {
                        var mutableText = text
                        mutableText.remove(at: stringRange)
                        textField.text = mutableText
                    }
                }
                
                return true
            }
        }
        
        return true
    }

    
    func formDataSource(_ dataSource: FormDataSource, changed value: String?, for field: FormField) {
        switch field.fieldType {
        case .paymentAccountNumber:
            let type = PaymentAccountType.type(from: value)
            viewModel.setPaymentAccopuntType(type)
            viewModel.setPaymentAccountFullPan(value)
            let imageView = UIImageView(image: UIImage(named: type?.logoName ?? ""))
            navigationItem.titleView = imageView
        case .text:
            viewModel.setPaymentAccountCardName(value)
        case .paymentAccountNickname:
            viewModel.setPaymentAccountNickname(value)
        default:
            break
        }
    }
    
    func formDataSource(_ dataSource: FormDataSource, selected options: [Any], for field: FormField) {
        // For mapping to the payment card expiry fields, we only care if we have BOTH
        guard options.count > 1 else { return }
        
        let month = options.first as? String
        let year = options.last as? String
        
        viewModel.setPaymentAccountExpiry(month: month, year: year)
    }
    
    func formDataSource(_ dataSource: FormDataSource, manualValidate field: FormField) -> Bool {
        switch field.fieldType {
        case .expiry(months: _, years: _):
            // Create date using components from string e.g. 11/2019
            guard let dateStrings = field.value?.components(separatedBy: "/") else { return false }
            guard let monthString = dateStrings[safe: 0] else { return false }
            guard let yearString = dateStrings[safe: 1] else { return false }
            guard let month = Int(monthString) else { return false }
            guard let year = Int(yearString) else { return false }
            guard let expiryDate = Date.makeDate(year: year, month: month, day: 01, hr: 12, min: 00, sec: 00) else { return false }
            
            return expiryDate.monthHasNotExpired
        default:
            return false
        }
    }
    
}

extension AddPaymentAccountViewController: FormCollectionViewCellDelegate {
    func formCollectionViewCell(_ cell: FormCollectionViewCell, didSelectField: UITextField) {
        
    }
    
    func formCollectionViewCell(_ cell: FormCollectionViewCell, shouldResignTextField textField: UITextField) {
        
    }
}
