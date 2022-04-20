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
        
        if Current.userManager.hasCurrentUser {
            handleLogin()
        } else {
            handleUnauthenticated()
        }
        
        window.tintColor = .black
        window.makeKeyAndVisible()
    }
    
    func handleUnauthenticated() {
        moveTo(ViewControllerFactory.makeLoginViewController())
    }
    
    func handleLogin() {
        moveTo(ViewControllerFactory.makeWalletViewController())
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
    
    func moveTo(_ viewController: UIViewController) {
        guard let window = window else { fatalError("Window does not exist. This should never happen") }
        window.rootViewController = viewController
        Current.navigate.setRootViewController(viewController)
    }
}
