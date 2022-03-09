//
//  LocalHeroViewController.swift
//  LocalHero
//
//  Created by Sean Williams on 23/02/2022.
//

import Foundation
import UIKit
import SwiftUI

class LocalHeroViewController: UIViewController {
    lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView(image: Asset.neptune.image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        return imageView
    }()
    
    override func viewDidLoad() {
        view.backgroundColor = .secondarySystemBackground
        configureUI()
    }
    
    func addFooterButtons(_ buttons: [HeroButton]) {
        let hostingController = UIHostingController(rootView: HeroButtonStack(buttons: buttons))
        hostingController.view.backgroundColor = .clear
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func configureUI() {
        NSLayoutConstraint.activate([
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImageView.heightAnchor.constraint(equalToConstant: view.frame.height / 2)
        ])
    }
}
