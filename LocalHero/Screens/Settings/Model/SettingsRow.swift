//
//  SettingsRow.swift
//  LocalHero
//
//  Created by Sean Williams on 20/04/2022.
//

import Foundation

struct SettingsRow: Hashable {
    enum RowType {
        case currentLogin
        case changeEnvironment
        case logout
        
        var title: String {
            switch self {
            case .currentLogin:
                return "Current Login"
            case .changeEnvironment:
                return "Change Environment"
            case .logout:
                return "Logout"
            }
        }
        
        var subtitle: String? {
            switch self {
            case .currentLogin:
                return Current.userManager.currentEmailAddress
            case .changeEnvironment:
                return APIConstants.baseURLString
            case .logout:
                return "Remove token from secure storage etc."
            }
        }
    }
    
    var type: RowType
    
    var title: String {
        return type.title
    }
    
    var subtitle: String? {
        return type.subtitle
    }
}