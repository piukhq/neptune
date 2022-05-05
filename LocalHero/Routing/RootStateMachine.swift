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
        NotificationCenter.default.addObserver(self, selector: #selector(logout), name: .shouldLogout, object: nil)
        
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
    
    @objc func logout() {
        clearLocalStorage { [weak self] in
            self?.completeLogout()
        }
    }
    
    private func clearLocalStorage(completion: @escaping () -> Void) {
        Current.database.performBackgroundTask { context in
            context.deleteAll(CD_LoyaltyCard.self)
            context.deleteAll(CD_PaymentAccount.self)
            context.deleteAll(CD_BaseObject.self) // Cleanup any orphaned objects
            try? context.save()
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    private func completeLogout() {
        Current.userManager.removeUser()
        Current.wallet.handleLogout()
        moveTo(ViewControllerFactory.makeLoginViewController())
    }
    
    func moveTo(_ viewController: UIViewController) {
        guard let window = window else { fatalError("Window does not exist. This should never happen") }
        window.rootViewController = viewController
        Current.navigate.setRootViewController(viewController)
    }
}
