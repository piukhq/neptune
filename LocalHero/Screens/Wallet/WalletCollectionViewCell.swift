//
//  WalletCollectionViewCell.swift
//  LocalHero
//
//  Created by Sean Williams on 14/03/2022.
//

import UIKit

class WalletCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var primaryLabel: UILabel!
    @IBOutlet private weak var secondaryLabel: UILabel!
    @IBOutlet private weak var accountProviderLabel: UILabel!
    
    private lazy var width: NSLayoutConstraint = {
        let width = contentView.widthAnchor.constraint(equalToConstant: bounds.size.width)
        width.isActive = true
        return width
    }()
    
    private lazy var height: NSLayoutConstraint = {
        let height = contentView.heightAnchor.constraint(equalToConstant: bounds.size.height)
        height.isActive = true
        return height
    }()
    
    func configure(with model: CD_PaymentAccount) {
        if let nickname = model.cardNickname {
            primaryLabel.text = nickname.capitalized + " / " + (model.nameOnCard ?? "")
        } else {
            primaryLabel.text = model.nameOnCard ?? ""
        }

        accountProviderLabel.text = model.provider?.uppercased() ?? "Pending"
        accountProviderLabel.isHidden = false
        
        let provider = PaymentAccountType(rawValue: model.provider ?? "")
        switch provider {
        case .visa, .mastercard:
            secondaryLabel.text = "**** \(model.lastFour ?? "****")"
        case .amex:
            secondaryLabel.text = "**** *\(model.lastFour ?? "****")"
        default:
            break
        }
    }
    
    func configure(with model: CD_LoyaltyCard) {
        primaryLabel.text = model.loyaltyPlan?.planDetails?.companyName
        secondaryLabel.text = model.balance?.currentDisplayValue
        accountProviderLabel.isHidden = true
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        width.priority = .almostRequired
        width.constant = bounds.size.width
        height.constant = bounds.size.height
        return contentView.systemLayoutSizeFitting(CGSize(width: targetSize.width, height: targetSize.height))
    }
}
