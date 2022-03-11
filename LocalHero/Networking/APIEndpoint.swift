//
//  APIEndpoint.swift
//  LocalHero
//
//  Created by Sean Williams on 22/02/2022.
//

import Alamofire
import Foundation
import Keys

enum APIEndpoint {
    case wallet
    case getSinglePlan(planID: String)
    case getLoyaltyPlans
    case addLoyaltyCard
    case joinLoyaltyPlan
    case createPaymentAccount
    case spreedly
    case login
    case logout
    case magicLinks
    case magicLinksAccessTokens
    
    var headers: [BinkHTTPHeader] {
        var headers: [BinkHTTPHeader] = [.defaultUserAgent, .defaultContentType]
        headers.append(.defaultAccept)
        
        if authRequired {
            guard let token = Current.userManager.currentToken else { return headers }
            headers.append(.authorization(token))
        }
        
//        if requiresBinkTestAuthHeader {
//            headers.append(.binkTestAuth())
//        }
        
        return headers
    }

    var urlString: String? {
        guard usesComponents else {
            return path
        }
        var components = URLComponents()
        components.scheme = scheme

        components.host = APIConstants.baseURLString
        components.path = path
        return components.url?.absoluteString.removingPercentEncoding
    }
    
    func urlString(withQueryParameters params: [String: String]) -> String? {
        guard usesComponents else {
            return path
        }
        var components = URLComponents()
        components.scheme = scheme
        
        components.host = APIConstants.baseURLString
        components.path = path
        components.queryItems = params.map { URLQueryItem(name: $0.key, value: $0.value) }
        return components.url?.absoluteString.removingPercentEncoding
    }
    
    var allowedMethods: [HTTPMethod] {
        return [.get,.put, .post, .patch, .delete]
    }
    
    private var authRequired: Bool {
        switch self {
        case .login, .spreedly:
            return false
        default: return true
        }
    }

    private var shouldVersionPin: Bool {
        switch self {
        case .spreedly:
            return false
        default: return true
        }
    }

    private var usesComponents: Bool {
        switch self {
        case .spreedly:
            return false
        default: return true
        }
    }
    
    private var requiresBinkTestAuthHeader: Bool {
        switch self {
        case .spreedly:
            return false
        default: return !APIConstants.isProduction
        }
    }
    
    /// There are cases where an endpoint requires authorization, but shouldn't respond to a 401 response code such as .logout.
    var shouldRespondToUnauthorizedStatus: Bool {
        switch self {
        case .logout, .magicLinks, .magicLinksAccessTokens:
            return false
        default: return true
        }
    }
    
    private var scheme: String {
        return "https"
    }
    
    var path: String {
        switch self {
        case .login:
            return "/users/login"
        case .wallet:
            return "/v2/wallet"
        case .getSinglePlan(let id):
            return "/v2/loyalty_plans/\(id)"
        case .getLoyaltyPlans:
            return "/v2/loyalty_plans"
        case .addLoyaltyCard:
            return "/v2/loyalty_cards/add"
        case .joinLoyaltyPlan:
            return "/v2/loyalty_cards/join"
        case .createPaymentAccount:
            return "/v2/payment_accounts"
        case .spreedly:
            return "https://core.spreedly.com/v1/payment_methods?environment_key=\(LocalHeroKeys().spreedlyEnvironmentKey)"
        default:
            return ""
        }
    }
}
