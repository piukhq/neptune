//
//  PermissionsUtility.swift
//  LocalHero
//
//  Created by Sean Williams on 26/04/2022.
//

import AVKit
import Foundation

enum PermissionsUtility {
    // MARK: - Camera permissions
    
    static var videoCaptureIsAuthorized: Bool {
        return AVCaptureDevice.authorizationStatus(for: .video) == .authorized
    }
    
    static var videoCaptureIsDenied: Bool {
        return AVCaptureDevice.authorizationStatus(for: .video) == .denied
    }
    
    static func requestVideoCaptureAuthorization(completion: @escaping (Bool) -> Void) {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    }
}

extension PermissionsUtility {
    static func launchLoginScanner(grantedAction: @escaping EmptyCompletionBlock, enterManuallyAction: EmptyCompletionBlock? = nil) {
        launchScanner(grantedAction: grantedAction, enterManuallyAction: enterManuallyAction)
    }

    private static func launchScanner(grantedAction: @escaping EmptyCompletionBlock, enterManuallyAction: EmptyCompletionBlock? = nil) {
        let enterManuallyAlert = ViewControllerFactory.barcodeScannerEnterManuallyAlertController() {
            enterManuallyAction?()
        }

        if PermissionsUtility.videoCaptureIsAuthorized {
            grantedAction()
        } else if PermissionsUtility.videoCaptureIsDenied {
            if let alert = enterManuallyAlert {
                let navigationRequest = AlertNavigationRequest(alertController: alert)
                Current.navigate.to(navigationRequest)
            }
        } else {
            PermissionsUtility.requestVideoCaptureAuthorization { granted in
                if granted {
                    grantedAction()
                } else {
                    if let alert = enterManuallyAlert {
                        let navigationRequest = AlertNavigationRequest(alertController: alert)
                        Current.navigate.to(navigationRequest)
                    }
                }
            }
        }
    }
}
