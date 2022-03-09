//
//  LocalHeroViewController.swift
//  LocalHero
//
//  Created by Sean Williams on 23/02/2022.
//

import Foundation
import UIKit

class LocalHeroViewController: UIViewController {
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView(image: Asset.neptune.image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        return imageView
    }()
    
    override func viewDidLoad() {
        view.backgroundColor = .secondarySystemBackground
        configureUI()
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
