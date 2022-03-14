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
    
    func configure(with model: PaymentAccountResponseModel) {
        let name = (model.cardNickname ?? "") + " / " + (model.nameOnCard ?? "")
        accountNameLabel.text = name
        accountProviderLabel.text = model.provider?.rawValue

        switch model.provider {
        case .visa, .mastercard:
            accountNumberLabel.text = "**** \(model.lastFour ?? "")"
        case .amex:
            accountNumberLabel.text = "***** \(model.lastFour ?? "")"
        default:
            break
        }
    }
}
