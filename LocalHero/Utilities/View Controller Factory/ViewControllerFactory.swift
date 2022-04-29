//
//  ViewControllerFactory.swift
//  LocalHero
//
//  Created by Sean Williams on 28/02/2022.
//

import UIKit

enum ViewControllerFactory {
    static func makeWalletViewController() -> HeroNavigationController {
        return HeroNavigationController(rootViewController: WalletViewController())
    }
    
    
    // MARK: - Onboarding
    
    static func makeLoginViewController() -> HeroNavigationController {
        return HeroNavigationController(rootViewController: LoginViewController())
    }
    

    //MARK: - Alerts
        
    static func makeAlertController(title: String?, message: String?, showCancelButton: Bool? = false, completion: (() -> Void)? = nil) -> UIAlertController {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.view.tintColor = .label
        ac.addAction(UIAlertAction(title: L10n.alertOk, style: .default, handler: { _ in
            completion?()
        }))
        
        if showCancelButton ?? false {
            ac.addAction(UIAlertAction(title: L10n.cancel, style: .cancel))
        }
        
        return ac
    }
    
    static func makeHomeScreenMenuActionSheetController(addPaymentCardAction: @escaping (() -> Void), settingsAction: @escaping (() -> Void), mapAction: @escaping (() -> Void)) -> UIAlertController {
        let ac = UIAlertController(title: L10n.walletSettingsActionSheetTitle, message: nil, preferredStyle: .actionSheet)
        ac.view.tintColor = .label
        ac.addAction(UIAlertAction(title: L10n.walletSettingsActionSheetAddPaymentCard, style: .default, handler: { _ in
            addPaymentCardAction()
        }))
        
        ac.addAction(UIAlertAction(title: L10n.walletSettingsActionSheetSettings, style: .default, handler: { _ in
            settingsAction()
        }))
        
        ac.addAction(UIAlertAction(title: L10n.walletSettingsActionSheetMap, style: .default, handler: { _ in
            mapAction()
        }))
        
        ac.addAction(UIAlertAction(title: L10n.cancel, style: .cancel))
        return ac
    }
    
    static func makeSettingsActionSheetController() -> UIAlertController {
        let ac = UIAlertController(title: L10n.settingsChooseEnvironmentActionSheetTitle, message: nil, preferredStyle: .actionSheet)
        ac.view.tintColor = .label
        ac.addAction(UIAlertAction(title: L10n.settingsChooseEnvironmentActionSheetDev, style: .default, handler: { _ in
            APIConstants.changeEnvironment(.dev)
        }))
        ac.addAction(UIAlertAction(title: L10n.settingsChooseEnvironmentActionSheetStaging, style: .default, handler: { _ in
            APIConstants.changeEnvironment(.staging)
        }))
        
        ac.addAction(UIAlertAction(title: L10n.cancel, style: .cancel))
        return ac
    }
    
    static func makeAlertViewControllerWithTextfield(title: String?, message: String?, cancelButton: Bool? = nil, okActionHandler: @escaping (String) -> Void, cancelActionHandler: EmptyCompletionBlock? = nil ) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.view.tintColor = .label
        alert.addTextField()
        alert.addAction(UIAlertAction(title: L10n.ok, style: .default, handler: { _ in
            okActionHandler(alert.textFields?[0].text ?? "")
        }))
        
        alert.addAction(UIAlertAction(title: L10n.cancel, style: .cancel, handler: { _ in
            cancelActionHandler?()
        }))
        return alert
    }
    
    static func barcodeScannerEnterManuallyAlertController(enterManuallyAction: @escaping () -> Void) -> UIAlertController? {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return nil }
        
        let alert = UIAlertController(title: L10n.permissionsDeniedTitle, message: L10n.permissionsDeniedBody, preferredStyle: .alert)
        alert.view.tintColor = .label
        let allowAction = UIAlertAction(title: L10n.permissionsDeniedAllowAccess, style: .default, handler: { _ in
            UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
        })
        let enterManuallyAction = UIAlertAction(title: L10n.permissionsDeniedEnterManualy, style: .default) { _ in
            enterManuallyAction()
        }
        
        alert.addAction(enterManuallyAction)
        alert.addAction(allowAction)
        alert.addAction(UIAlertAction(title: L10n.cancel, style: .cancel, handler: nil))
        
        return alert
    }
} 
