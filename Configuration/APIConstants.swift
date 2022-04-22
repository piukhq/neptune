//
//  APIConstants.swift
//  LocalHero
//
//  Created by Sean Williams on 16/02/2022.
//

import Foundation

private var debugBaseURL = "" {
    didSet {
        Current.userDefaults.set(debugBaseURL, forDefaultsKey: .debugBaseURL)
    }
}

enum EnvironmentType: String, CaseIterable {
    case dev = "api.dev.gb.bink.com"
    case staging = "api.staging.gb.bink.com"
    case preprod = "api.preprod.gb.bink.com"
    case production = "api.gb.bink.com"
}

enum APIConstants {
    static var baseURLString: String {
        if let _ = try? Configuration.value(for: .debug) {
            // If we have set the environment from the debug menu
            if let debugBaseURLString = Current.userDefaults.value(forDefaultsKey: .debugBaseURL) as? String {
                return debugBaseURLString
            }
        }
        
        do {
            let apiBaseURL = try Configuration.value(for: .apiBaseUrl)
            return apiBaseURL
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    static func changeEnvironment(_ environment: EnvironmentType) {
        debugBaseURL = environment.rawValue
        NotificationCenter.default.post(name: .shouldLogout, object: nil)
    }
    
    static let bundleID = "com.bink.localhero"
    
    static var isProduction: Bool {
        return baseURLString == EnvironmentType.production.rawValue
    }
    
    static var isPreProduction: Bool {
        return baseURLString == EnvironmentType.preprod.rawValue
    }
}
