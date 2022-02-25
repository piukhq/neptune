//
//  ViewController.swift
//  LocalHero
//
//  Created by Sean Williams on 16/02/2022.
//

import UIKit

class LoginViewController: LocalHeroViewController {
    // MARK: - Properties
    
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
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureUI() {
        super.configureUI()
        NSLayoutConstraint.activate([
            loginButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40),
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            loginButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    
    // MARK: - Private methods

    @objc private func loginButtonTapped() {
        let vc = BarcodeScannerViewController(viewModel: BarcodeScannerViewModel(), delegate: self)
        navigationController?.present(vc, animated: true)
    }
}


// MARK: - Barcode scanner delegate

extension LoginViewController: BarcodeScannerViewControllerDelegate {
    
    func barcodeScannerViewController(_ viewController: BarcodeScannerViewController, didScanBarcode barcode: String, completion: (() -> Void)?) {
        dismiss(animated: true)
        let loginResponse = LoginResponse(apiKey: nil, userEmail: nil, uid: nil, accessToken: barcode)
        guard loginResponse.isValidJWT else  {
            showError(title: "Unsupported Barcode")
            return
        }
        
        Current.userManager.setNewUser(with: loginResponse)
        
        Current.wallet.getLoyaltyPlans { [weak self] error in
            guard error == nil else {
                if case .unauthorized = error {
                    self?.showError(title: "Invalid Token")
                } else {
                    self?.showError(title: error?.localizedDescription ?? "Error")
                }
                
                return
            }
            
            let vc = LoyaltyPlansTableViewController()
            self?.navigationController?.show(vc, sender: self)
        }
    }
    
    func showError(title: String) {
        let ac = self.makeAlertController(title: title, message: nil)
        self.present(ac, animated: true)
    }
    
    func makeAlertController(title: String?, message: String?, completion: (() -> Void)? = nil) -> UIAlertController {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
            completion?()
        }))
        
        return ac
    }
}
