//
//  APIConstants.swift
//  LocalHero
//
//  Created by Sean Williams on 16/02/2022.
//

import Foundation


enum EnvironmentType: String, CaseIterable {
    case dev = "api.dev.gb.bink.com"
    case staging = "api.staging.gb.bink.com"
    case preprod = "api.preprod.gb.bink.com"
    case production = "api.gb.bink.com"
}

enum APIConstants {
    static var baseURLString: String {
        do {
            let apiBaseURL = try Configuration.value(for: .apiBaseUrl)
            return apiBaseURL
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    static let bundleID = "com.bink.localhero"
    
    static var isProduction: Bool {
        return baseURLString == EnvironmentType.production.rawValue
    }
    
    static var isPreProduction: Bool {
        return baseURLString == EnvironmentType.preprod.rawValue
    }
}
