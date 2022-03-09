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
        return true
    }
    
    func formDataSource(_ dataSource: FormDataSource, changed value: String?, for field: FormField) {
        switch field.fieldType {
        case .paymentAccountNumber:
            let type = PaymentAccountType.type(from: value)
            viewModel.setPaymentAccopuntType(type)
            viewModel.setPaymentAccountFullPan(value)
            print(type?.logoName)
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
