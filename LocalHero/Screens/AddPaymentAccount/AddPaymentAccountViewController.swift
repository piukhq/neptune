//
//  AddPaymentAccountViewController.swift
//  LocalHero
//
//  Created by Sean Williams on 08/03/2022.
//

import Foundation
import UIKit

class AddPaymentAccountViewModel {
    var paymentAccount: PaymentAccountCreateModel
    
    init(paymentAccount: PaymentAccountCreateModel? = nil) {
        self.paymentAccount = paymentAccount ?? PaymentAccountCreateModel(fullPan: nil, expiryMonth: nil, expiryYear: nil, nameOnCard: nil, cardNickname: nil, token: nil, lastFourDigits: nil, firstSixDigits: nil, fingerprint: nil)
    }
    
    var paymentAccountType: PaymentAccountType? {
        return paymentAccount.provider
    }
    
    func setPaymentAccopuntType(_ type: PaymentAccountType?) {
        paymentAccount.provider = type
    }
    
    func setPaymentAccountFullPan(_ fullPan: String?) {
        paymentAccount.fullPan = fullPan
    }
    
    func setPaymentAccountCardName(_ name: String?) {
        paymentAccount.nameOnCard = name
    }
    
    func setPaymentAccountNickname(_ name: String?) {
        paymentAccount.cardNickname = name
    }
}

class AddPaymentAccountViewController: BaseFormViewController {
    private var viewModel: AddPaymentAccountViewModel
    
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
}

extension AddPaymentAccountViewController: FormCollectionViewCellDelegate {
    func formCollectionViewCell(_ cell: FormCollectionViewCell, didSelectField: UITextField) {
        
    }
    
    func formCollectionViewCell(_ cell: FormCollectionViewCell, shouldResignTextField textField: UITextField) {
        
    }
    
    
}
