//
//  LoginResponse.swift
//  LocalHero
//
//  Created by Sean Williams on 23/02/2022.
//

import Foundation
import JWTDecode

struct LoginResponse: Codable {
    // Regular login, and renew token response
    var apiKey: String?
    
    // Regular login additional keys
    let userEmail: String?
    let uid: String?
    
    // Magic Link response
    let accessToken: String?
    
    
    // Abstractions
    
    // Abstract the two possible token response keys we can get
    var jwt: String? {
        return apiKey ?? accessToken
    }
    
    // Return the email if we have it, otherwise attempt to extract it from the token
    var email: String? {
        if let email = userEmail {
            return email
        }
        
        guard let jwt = jwt else { return nil }
        let decodedToken = try? decode(jwt: jwt)
        return decodedToken?.body["user_id"] as? String
    }
    
    var isValidJWT: Bool {
        do {
            let decodedToken = try decode(jwt: accessToken ?? "")
            print(decodedToken.body)
            return true
        } catch {
            print(error.localizedDescription)
        }
        return false
    }
    
    enum CodingKeys: String, CodingKey {
        case userEmail = "email"
        case uid
        case apiKey = "api_key"
        case accessToken = "access_token"
    }
}
