//
//  RootStateMachine.swift
//  LocalHero
//
//  Created by Sean Williams on 22/02/2022.
//

import Foundation
import UIKit

class RootStateMachine: NSObject {
    private var window: UIWindow?
    
    func launch(withWindow window: UIWindow) {
        self.window = window
        let loginViewController = LoginViewController()
        let navigationCOntroller = HeroNavigationController(rootViewController: loginViewController)
        window.rootViewController = navigationCOntroller
        Current.navigate.setRootViewController(navigationCOntroller)
        window.tintColor = .black
        window.makeKeyAndVisible()
    }
    
    func logout() {
        clearLocalStorage()
    }
    
    private func clearLocalStorage() {
        Current.userManager.removeUser()

        Current.database.performBackgroundTask { context in
            context.deleteAll(CD_LoyaltyCard.self)
            context.deleteAll(CD_PaymentAccount.self)
            context.deleteAll(CD_BaseObject.self) // Cleanup any orphaned objects
            try? context.save()
        }
    }
}
