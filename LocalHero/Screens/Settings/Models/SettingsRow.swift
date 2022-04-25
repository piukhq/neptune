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
                return L10n.settingsRowTitleCurrentLogin
            case .changeEnvironment:
                return L10n.settingsRowTitleChangeEnvironment
            case .logout:
                return L10n.settingsRowTitleLogout
            }
        }
        
        var subtitle: String? {
            switch self {
            case .currentLogin:
                return Current.userManager.currentEmailAddress
            case .changeEnvironment:
                return APIConstants.baseURLString
            case .logout:
                return L10n.settingsRowSubtitleLogout
            }
        }
        
        func action() {
            switch self {
            case .changeEnvironment:
                let alertController = ViewControllerFactory.makeSettingsActionSheetController()
                let navigationRequest = AlertNavigationRequest(alertController: alertController)
                Current.navigate.to(navigationRequest)
            case .logout:
                let alertController = ViewControllerFactory.makeAlertController(title: L10n.settingsLogoutAlertTitle, message: L10n.settingsLogoutAlertMessage, showCancelButton: true, completion: {
                    NotificationCenter.default.post(name: .shouldLogout, object: nil)
                })
                let navigationRequest = AlertNavigationRequest(alertController: alertController)
                Current.navigate.to(navigationRequest)
            default:
                break
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
