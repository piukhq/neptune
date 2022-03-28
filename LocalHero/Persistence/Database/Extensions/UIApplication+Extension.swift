//
//  UIApplication+Extension.swift
//  LocalHero
//
//  Created by Sean Williams on 25/03/2022.
//

import UIKit

public extension UIApplication {
    static var isRunningUnitTests: Bool {
        return ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
    }
    
    static var isRunningUITests: Bool {
        return CommandLine.arguments.contains("UI-testing")
    }
}
