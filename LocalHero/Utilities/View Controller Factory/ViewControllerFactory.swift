//
//  ViewControllerFactory.swift
//  LocalHero
//
//  Created by Sean Williams on 28/02/2022.
//

import UIKit

enum ViewControllerFactory {

    //MARK: - Alerts
    
    static func makeAlertController(title: String?, message: String?, completion: (() -> Void)? = nil) -> UIAlertController {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: L10n.alertOk, style: .cancel, handler: { _ in
            completion?()
        }))
        
        return ac
    }
    
    static func makeHomeScreenMenuActionSheetController(addPaymentCardAction: @escaping (() -> Void), settingsAction: @escaping (() -> Void), mapAction: @escaping (() -> Void)) -> UIAlertController {
        let ac = UIAlertController(title: "NEPTUNE GOD MODE", message: nil, preferredStyle: .actionSheet)
        ac.view.tintColor = .label
        ac.addAction(UIAlertAction(title: "Add Payment Card", style: .default, handler: { _ in
            addPaymentCardAction()
        }))
        
        ac.addAction(UIAlertAction(title: "Settings", style: .default, handler: { _ in
            settingsAction()
        }))
        
        ac.addAction(UIAlertAction(title: "Map", style: .default, handler: { _ in
            mapAction()
        }))
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        return ac
    }
}
