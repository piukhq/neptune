//
//  ViewController.swift
//  LocalHero
//
//  Created by Sean Williams on 16/02/2022.
//

import UIKit

class LoginViewController: LocalHeroViewController {
    private lazy var loginButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .white
        button.setTitle(L10n.loginButtonTitle, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        button.layer.cornerRadius = 25
        button.layer.cornerCurve = .continuous
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.systemBlue.cgColor
        view.addSubview(button)
        return button
    }()
    
    private weak var delegate: BarcodeScannerViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSLayoutConstraint.activate([
            loginButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40),
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            loginButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        
    }
    
    @objc private func loginButtonTapped() {
        // Store token from QR code in User Manager

        let vc = BarcodeScannerViewController(viewModel: BarcodeScannerViewModel(), delegate: self)
        navigationController?.present(vc, animated: true)
    }
}

extension LoginViewController: BarcodeScannerViewControllerDelegate {
    func barcodeScannerViewController(_ viewController: BarcodeScannerViewController, didScanBarcode barcode: String, completion: (() -> Void)?) {
        print(barcode)
        dismiss(animated: true)
    }
}

