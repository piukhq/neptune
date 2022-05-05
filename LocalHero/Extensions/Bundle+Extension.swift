//
//  Bundle+Extension.swift
//  LocalHero
//
//  Created by Sean Williams on 23/02/2022.
//

import Foundation

extension Bundle {
    static let shortVersionNumber = main.infoDictionary?["CFBundleShortVersionString"] as? String
    static let bundleVersion = main.infoDictionary?["CFBundleVersion"] as? String
}
