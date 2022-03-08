//
//  AddPaymentAccountViewController.swift
//  LocalHero
//
//  Created by Sean Williams on 08/03/2022.
//

import Foundation
import UIKit

class AddPaymentAccountViewModel {
    
}

class AddPaymentAccountViewController: BaseFormViewController {
        
    init() {
        super.init(dataSource: FormDataSource(model: PaymentAccountCreateModel()))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add Payment Account"
    }
}
