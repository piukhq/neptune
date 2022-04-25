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
}
