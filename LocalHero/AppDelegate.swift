//
//  AppDelegate.swift
//  LocalHero
//
//  Created by Sean Williams on 16/02/2022.
//

import Firebase
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {        
        
        // Root view
        self.window = UIWindow(frame: UIScreen.main.bounds)

        if let mainWindow = self.window {
            Current.rootStateMachine.launch(withWindow: mainWindow)
        }

        return true
    }
}
