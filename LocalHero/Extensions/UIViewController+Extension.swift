//
//  UIViewController+Extension.swift
//  LocalHero
//
//  Created by Sean Williams on 08/03/2022.
//

import UIKit

extension UIViewController {
    var isModal: Bool {
        return self.presentingViewController?.presentedViewController == self
            || (self.navigationController != nil && self.navigationController?.presentingViewController?.presentedViewController == self.navigationController)
            || self.tabBarController?.presentingViewController is UITabBarController
    }
    
    static func topMostViewController() -> UIViewController? {
        let window = UIApplication.shared.windows.first { $0.isKeyWindow }
        if var topController = window?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            return topController
        }
        return nil
    }

    var isShieldView: Bool {
        return self.restorationIdentifier == "LaunchScreen"
    }
}
