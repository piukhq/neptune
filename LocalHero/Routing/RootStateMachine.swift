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
        let navigationController = UINavigationController(rootViewController: loginViewController)
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
