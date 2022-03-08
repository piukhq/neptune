//
//  HeroNavigationController.swift
//  LocalHero
//
//  Created by Sean Williams on 07/03/2022.
//

import Foundation
import UIKit

class HeroNavigationController: UINavigationController {
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        navigationBar.standardAppearance = navBarAppearance()
        navigationBar.scrollEdgeAppearance = navBarAppearance()
        navigationBar.tintColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func navBarAppearance() -> UINavigationBarAppearance {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.shadowImage = UIImage()
        appearance.backgroundColor = UIColor(hexString: "#3b48ea", alpha: 0.94)
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white.cgColor]
        return appearance
    }
    
}

extension UIColor {
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if hexString.hasPrefix("#") {
            scanner.currentIndex = hexString.index(hexString.startIndex, offsetBy: 1)
        }
        var color: UInt64 = 0
        scanner.scanHexInt64(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue = CGFloat(b) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
