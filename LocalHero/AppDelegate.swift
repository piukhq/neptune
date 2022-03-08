//
//  AppDelegate.swift
//  LocalHero
//
//  Created by Sean Williams on 16/02/2022.
//

import Firebase
import UIKit

 @main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {        
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        
        if let mainWindow = self.window {
            Current.rootStateMachine.launch(withWindow: mainWindow)
        }
        return true
    }
}
