//
//  ViewController.swift
//  LocalHero
//
//  Created by Sean Williams on 16/02/2022.
//

import UIKit
import SwiftUI

class LoginViewController: LocalHeroViewController {
    // MARK: - Properties

    private lazy var loginButton: HeroButton = {
        return HeroButton(viewModel: ButtonViewModel(disabled: false, title: L10n.loginButtonTitle, action: loginButtonTapped))
    }()
    
    private weak var delegate: BarcodeScannerViewControllerDelegate?


    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let addPaymentCardviewController = AddPaymentAccountViewController(viewModel: AddPaymentAccountViewModel())
        let navigationRequest = ModalNavigationRequest(viewController: addPaymentCardviewController)
        Current.navigate.to(navigationRequest)
        
        addFooterButtons([loginButton])
    }

    // MARK: - Private methods

    private func loginButtonTapped() {
//        let vc = BarcodeScannerViewController(viewModel: BarcodeScannerViewModel(), delegate: self)
//        navigationController?.present(vc, animated: true)
        
//        let addPaymentCardviewController = AddPaymentAccountViewController()
//        let navigationRequest = ModalNavigationRequest(viewController: addPaymentCardviewController)
//        Current.navigate.to(navigationRequest)
        
        let addPaymentCardviewController = AddPaymentAccountViewController(viewModel: AddPaymentAccountViewModel())
//        let navigationRequest = ModalNavigationRequest(viewController: addPaymentCardviewController)
        let push = PushNavigationRequest(viewController: addPaymentCardviewController)
        Current.navigate.to(push)
    }
    
    private func showError(title: String) {
        let ac = ViewControllerFactory.makeAlertController(title: title, message: nil)
        self.present(ac, animated: true)
    }
}


// MARK: - Barcode scanner delegate

extension LoginViewController: BarcodeScannerViewControllerDelegate {
    func barcodeScannerViewController(_ viewController: BarcodeScannerViewController, didScanBarcode barcode: String, completion: (() -> Void)?) {
        dismiss(animated: true)
        let loginResponse = LoginResponse(apiKey: nil, userEmail: nil, uid: nil, accessToken: barcode)
        guard loginResponse.isValidJWT else  {
            showError(title: L10n.alertUnsupportedBarcodeTitle)
            return
        }
        
        Current.userManager.setNewUser(with: loginResponse)
        
        Current.wallet.getLoyaltyPlans { [weak self] error in
            guard error == nil else {
                if case .unauthorized = error {
                    self?.showError(title: L10n.alertInvalidToken)
                } else {
                    self?.showError(title: error?.localizedDescription ?? L10n.alertError)
                }
                
                return
            }
            
            let loyaltyPlansViewController = LoyaltyPlansTableViewController()
            self?.navigationController?.show(loyaltyPlansViewController, sender: self)
        }
    }
}
