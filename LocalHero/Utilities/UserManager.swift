//
//  UserManager.swift
//  LocalHero
//
//  Created by Sean Williams on 23/02/2022.
//

import Foundation
import KeychainAccess

enum UserManagerError: Error {
    case missingData
}

class UserManager {
    private enum Constants {
        static let tokenKey = "token_key"
        static let emailKey = "email_key"
    }

    private let keychain = Keychain(service: APIConstants.bundleID)
    
    lazy var currentToken: String? = getKeychainValue(for: Constants.tokenKey)
    lazy var currentEmailAddress: String? = getKeychainValue(for: Constants.emailKey)

    private func getKeychainValue(for key: String) -> String? {
        return try? keychain.getString(key)
    }
    
    func setNewUser(with response: LoginResponse) {
        do {
            try setToken(with: response)
            try setEmail(with: response)
        } catch {
//            print("Failed to store token and / or email to keychain: \(error.localizedDescription)")
        }
    }
    
    private func setToken(with response: LoginResponse) throws {
        guard let token = response.jwt else { throw UserManagerError.missingData }
        try keychain.set(token, key: Constants.tokenKey)
        currentToken = token
    }
    
    private func setEmail(with response: LoginResponse) throws {
        guard let email = response.email else { throw UserManagerError.missingData }
        try keychain.set(email, key: Constants.emailKey)
        currentEmailAddress = email
    }
}