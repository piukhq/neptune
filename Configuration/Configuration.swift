//
//  Configuration.swift
//  LocalHero
//
//  Created by Sean Williams on 16/02/2022.
//

import Foundation

enum Configuration {
    enum ConfigurationError {
        case missingKey
        case invalidValue

        var domain: String {
            return "Configuration"
        }

        var message: String {
            switch self {
            case .missingKey:
                return "Missing key"
            case .invalidValue:
                return "Invalid value"
            }
        }
    }
    
    enum Error: Swift.Error {
        case missingKey, missingValue
    }
    
    enum ConfigurationKey: String {
        case apiBaseUrl = "API_BASE_URL"
        case secret = "SECRET"
        case debug = "DEBUG"
    }
    
    static func value(for key: ConfigurationKey) throws -> String {
        guard let object = Bundle.main.object(forInfoDictionaryKey: key.rawValue) else { throw Error.missingKey }
        guard let string = object as? String, !string.isEmpty else { throw Error.missingValue }
        return string
    }
    
    static func isDebug() -> Bool {
        if let _ = try? value(for: .debug) {
            return true
        }
        return false
    }
}
