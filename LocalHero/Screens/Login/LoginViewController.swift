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
    
    private lazy var loginButton: BinkButton = {
        return BinkButton(type: .plain, title: L10n.loginButtonTitle, action: loginButtonTapped)
    }()
    
    private weak var delegate: BarcodeScannerViewControllerDelegate?


    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        footerButtons = [loginButton]
    }

    // MARK: - Private methods

    private func loginButtonTapped() {
        PermissionsUtility.launchLoginScanner() { [weak self] in
            self?.toBarcodeScanner()
        } enterManuallyAction: { [weak self] in
            self?.toBarcodeScanner()
        }
    }
    
    private func toBarcodeScanner() {
        let barcodeScannerViewController = BarcodeScannerViewController(viewModel: BarcodeScannerViewModel(), delegate: self)
        let navigationRequest = ModalNavigationRequest(viewController: barcodeScannerViewController)
        Current.navigate.to(navigationRequest)
    }
    
    private func showError(title: String) {
        let ac = ViewControllerFactory.makeAlertController(title: title, message: nil)
        let navigationRequest = AlertNavigationRequest(alertController: ac)
        Current.navigate.to(navigationRequest)
    }
}


// MARK: - Barcode scanner delegate

extension LoginViewController: BarcodeScannerViewControllerDelegate {
    func barcodeScannerViewController(_ viewController: BarcodeScannerViewController, didScanBarcode barcode: String, completion: (() -> Void)?) {
        
        let loginResponse = LoginResponse(apiKey: nil, userEmail: nil, uid: nil, accessToken: barcode)
        guard loginResponse.isValidJWT else  {
            showError(title: L10n.alertUnsupportedBarcodeTitle)
            return
        }
        
        Current.userManager.setNewUser(with: loginResponse)
        
        Current.wallet.launch() { [weak self] success, error in
            guard success else {
                if case .failedToGetLoyaltyPlans(let networkingError) = error {
                    if case .unauthorized = networkingError {
                        self?.showError(title: L10n.alertInvalidToken)
                    } else {
                        self?.showError(title: networkingError.localizedDescription)
                    }
                }
                return
            }
            
            Current.rootStateMachine.handleLogin()
        }
    }
}
