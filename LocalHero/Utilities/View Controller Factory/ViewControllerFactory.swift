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
} 
