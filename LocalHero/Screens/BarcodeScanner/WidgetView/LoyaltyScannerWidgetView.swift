//
//  LoyaltyScannerWidgetView.swift
//  binkapp
//
//  Created by Nick Farrant on 06/04/2020.
//  Copyright © 2020 Bink. All rights reserved.
//

import UIKit

class LoyaltyScannerWidgetView: CustomView {
    enum Constants {
        static let cornerRadius: CGFloat = 4
    }

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var explainerLabel: UILabel!

    private var state: WidgetState = .enterManually

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }

    func addTarget(_ target: Any?, selector: Selector?) {
        addGestureRecognizer(UITapGestureRecognizer(target: target, action: selector))
    }

    func configure() {
        clipsToBounds = true
        layer.cornerRadius = Constants.cornerRadius

        backgroundColor = UIColor(hexString: "#3b48ea", alpha: 0.94)
        titleLabel.font = .boldSystemFont(ofSize: 20)
        titleLabel.textColor = .white
        explainerLabel.font = .systemFont(ofSize: 14)
        explainerLabel.numberOfLines = 2
        explainerLabel.textColor = .white.withAlphaComponent(0.7)
        imageView.tintColor = .green

        setState(state)
    }
    
    func animateOnTap() {
        layer.addLocalHeroAnimation(.shake)
        HapticFeedbackUtil.giveFeedback(forType: .selection)
    }

    private func error(state: WidgetState) {
        layer.addLocalHeroAnimation(.shake)
        HapticFeedbackUtil.giveFeedback(forType: .notification(type: .error))
        setState(state)
    }

    private func setState(_ state: WidgetState) {
        titleLabel.text = state.title
        explainerLabel.text = state.explainerText
        imageView.image = UIImage(named: state.imageName)
        self.state = state
    }
}

extension LoyaltyScannerWidgetView {
    enum WidgetState {
        case enterManually

        var title: String {
            switch self {
            case .enterManually:
                return L10n.barcodeScannerWidgetTitleEnterManuallyText
            }
        }

        var explainerText: String {
            switch self {
            case .enterManually:
                return L10n.barcodeScannerWidgetExplainerEnterManuallyText
            }
        }

        var imageName: String {
            switch self {
            case .enterManually:
                return Asset.loyaltyScannerEnterManually.name
            }
        }
    }
}
