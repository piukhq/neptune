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
        textView.isScrollEnabled = false
        textView.isUserInteractionEnabled = true
        textView.isEditable = false
        textView.backgroundColor = .clear
        textView.font = .systemFont(ofSize: 20)
        textView.textContainerInset = UIEdgeInsets(top: 20, left: 20, bottom: 0, right:20)
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
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            textView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        var cardDetails = ""
        
        if let loyaltyCard = loyaltyCard {
            title = loyaltyCard.loyaltyPlan?.planDetails?.companyName ?? ""
            cardDetails = "Status: \(loyaltyCard.status?.state ?? "")".capitalized + "\n"
            cardDetails += "ID: \(loyaltyCard.id ?? "")" + "\n"
            cardDetails += "Balance: \(loyaltyCard.balance?.currentDisplayValue ?? "Zero")" + "\n"
            cardDetails += "Barcode: \(loyaltyCard.card?.barcode ?? "None")" + "\n"

            cardDetails += (loyaltyCard.pllLink.count == 0 ? "No PLL links" : "\(loyaltyCard.pllLink.count) PLL links") + "\n"
            cardDetails += (loyaltyCard.transaction.count == 0 ? "No transactions" : "\(loyaltyCard.transaction.count) transactions") + "\n"
            cardDetails += (loyaltyCard.voucher.count == 0 ? "No vouchers" : "\(loyaltyCard.voucher.count) vouchers") + "\n"
        }
        
        if let paymentAccount = paymentAccount {
            cardDetails = (paymentAccount.cardNickname ?? "") + "\n"
            cardDetails += (paymentAccount.nameOnCard ?? "") + "\n"
            cardDetails += "ID: \(paymentAccount.id ?? "")" + "\n"
            cardDetails += "Expiry: \(paymentAccount.expiryMonth ?? "") / \(paymentAccount.expiryYear ?? "")" + "\n"
            cardDetails += "Last four digits: \(paymentAccount.lastFour ?? "")" + "\n"
            cardDetails += "Status: \(paymentAccount.status ?? "")".capitalized + "\n"
            cardDetails += (paymentAccount.pllLinks.count == 0 ? "No PLL links" : "\(paymentAccount.pllLinks.count) PLL links") + "\n"
            title = paymentAccount.provider
        }
        
        textView.text = cardDetails
    }
}
