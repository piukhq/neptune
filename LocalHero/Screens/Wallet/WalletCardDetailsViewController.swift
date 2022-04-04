//
//  WalletCardDetailsViewController.swift
//  LocalHero
//
//  Created by Sean Williams on 04/04/2022.
//

import UIKit

class WalletCardDetailsViewController: LocalHeroViewController {
    private lazy var textView: UITextView = {
       let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textView)
        return textView
    }()
    
    let loyaltyCard: CD_LoyaltyCard?
    let paymentAccount: CD_PaymentAccount?
    
    init(loyaltyCard: CD_LoyaltyCard?, paymentAccount: CD_PaymentAccount?) {
        self.loyaltyCard = loyaltyCard
        self.paymentAccount = paymentAccount
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.topAnchor),
            textView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        var cardDetails: String?
        
        if let loyaltyCard = loyaltyCard {
            cardDetails = loyaltyCard.loyaltyPlan?.planDetails?.companyName
        }
        
        textView.text = cardDetails
    }
}
