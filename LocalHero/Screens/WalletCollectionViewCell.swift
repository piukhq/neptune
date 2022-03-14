//
//  WalletCollectionViewCell.swift
//  LocalHero
//
//  Created by Sean Williams on 14/03/2022.
//

import UIKit

class WalletCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var accountNameLabel: UILabel!
    @IBOutlet private weak var accountNumberLabel: UILabel!
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
    
    func configure(with model: PaymentAccountModel) {
        let name = (model.cardNickname ?? "") + " / " + (model.nameOnCard ?? "")
        accountNameLabel.text = name
        accountProviderLabel.text = model.provider?.rawValue

        switch model.provider {
        case .visa, .mastercard:
            accountNumberLabel.text = "**** **** **** ****"
        case .amex:
            accountNumberLabel.text = "**** **** **** *****"
        default:
            break
        }
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        width.priority = .almostRequired
        width.constant = bounds.size.width
        height.constant = bounds.size.height
        return contentView.systemLayoutSizeFitting(CGSize(width: targetSize.width, height: targetSize.height))
    }
}
