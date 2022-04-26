//
//  SecureUtility.swift
//  binkapp
//
//  Created by Nick Farrant on 27/02/2020.
//  Copyright © 2020 Bink. All rights reserved.
//

import Foundation
import Keys
import SwiftyRSA

enum SecureUtility {
    static func encryptedSensitiveFieldValue(_ value: String?) -> String? {
        guard let value = value else { return nil }
        guard let publicKeyName = publicKeyName() else { return nil }
        do {
            let publicKey = try PublicKey(derNamed: publicKeyName)
            let clear = try ClearMessage(string: value, using: .utf8)
            let encrypted = try clear.encrypted(with: publicKey, padding: .OAEP)
            return encrypted.base64String
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }

    private static func publicKeyName() -> String? {
        if APIConstants.baseURLString == EnvironmentType.dev.rawValue {
            return "devPublicKey"
        } else if APIConstants.baseURLString == EnvironmentType.staging.rawValue {
            return "stagingPublicKey"
        } else if APIConstants.baseURLString == EnvironmentType.production.rawValue || APIConstants.baseURLString == EnvironmentType.preprod.rawValue {
            return "prodPublicKey"
        } else {
            return nil
        }
    }
}

extension String {
    func base64Decoded() -> String? {
        guard let decodedData = Data(base64Encoded: self) else { return nil }
        guard let decodedString = String(data: decodedData, encoding: .utf8) else { return nil }
        return decodedString
    }

    func base64Encoded() -> String? {
        return data(using: .utf8)?.base64EncodedString()
    }
}
