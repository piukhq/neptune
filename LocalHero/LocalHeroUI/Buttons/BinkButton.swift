//
//  BinkButton.swift
//  binkapp
//
//  Created by Nick Farrant on 16/12/2020.
//  Copyright © 2020 Bink. All rights reserved.
//

import UIKit

typealias BinkButtonAction = () -> Void

class BinkButton {
    enum ButtonType: Equatable {
//        case pill(BinkPillButton.PillButtonType)
//        case gradient
        case plain
    }

    private let type: ButtonType
    private var title: String
    private let action: BinkButtonAction
    private lazy var button = makeButton()

    var enabled: Bool {
        didSet {
            button.isEnabled = enabled
        }
    }

    init(type: ButtonType, title: String = "", enabled: Bool = true, action: @escaping BinkButtonAction) {
        self.type = type
        self.title = title
        self.enabled = enabled
        self.action = action
    }

    func setTitle(_ title: String) {
        button.setTitle(title, for: .normal)
    }

    @objc private func performAction() {
        action()
    }
    
    func setAlpha(_ value: CGFloat) {
        button.alpha = value
    }

    private func makeButton() -> UIButton {
        switch type {
        case .plain:
            let button = UIButton(type: .roundedRect)
            button.setTitle(title, for: .normal)
            button.setTitleColor(.systemBlue, for: .normal)
            button.setTitleColor(.systemGray, for: .disabled)
            button.isEnabled = enabled
            button.addTarget(self, action: #selector(performAction), for: .touchUpInside)
            button.accessibilityIdentifier = title
            return button
        }
    }

    func attachButton(to stackView: UIStackView) {
        stackView.addArrangedSubview(button)
        button.heightAnchor.constraint(equalToConstant: 52).isActive = true
        button.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.75).isActive = true
    }
}
