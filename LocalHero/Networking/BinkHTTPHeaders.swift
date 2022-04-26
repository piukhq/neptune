//
//  BinkHTTPHeaders.swift
//  LocalHero
//
//  Created by Sean Williams on 22/02/2022.
//

import UIKit
import Keys

enum BinkHTTPHeaders {
    static func asDictionary(_ headers: [BinkHTTPHeader]) -> [String: String] {
        var dictionary: [String: String] = [:]
        headers.forEach {
            dictionary[$0.name] = $0.value
        }
        return dictionary
    }
}

struct BinkHTTPHeader {
    let name: String
    let value: String
    
    // MARK: - Headers

    static func userAgent(_ value: String) -> BinkHTTPHeader {
        return BinkHTTPHeader(name: "User-Agent", value: value)
    }
    
    static func contentType(_ value: String) -> BinkHTTPHeader {
        return BinkHTTPHeader(name: "Content-Type", value: value)
    }
    
    static func accept(_ value: String) -> BinkHTTPHeader {
        return BinkHTTPHeader(name: "Accept", value: value)
    }
    
    static func authorization(_ value: String) -> BinkHTTPHeader {
        return BinkHTTPHeader(name: "Authorization", value: "bearer \(value)")
    }
    
    static func binkTestAuth() -> BinkHTTPHeader {
        return BinkHTTPHeader(name: "Bink-Test-Auth", value: LocalHeroKeys().binkTestAuthHeaderToken)
    }
    
    // MARK: - Defaults

    static let defaultUserAgent: BinkHTTPHeader = {
        return userAgent("Local Hero / iOS \(Bundle.shortVersionNumber ?? "") / \(UIDevice.current.systemVersion)")
    }()
    
    static let defaultContentType: BinkHTTPHeader = {
        return contentType("application/json")
    }()
    
    static let defaultAccept: BinkHTTPHeader = {
        return accept("application/json")
    }()
}
