//
//  SettingsViewModel.swift
//  LocalHero
//
//  Created by Sean Williams on 22/04/2022.
//

import SwiftUI

class SettingsViewModel: BarcodeService {    
    let rowData = [SettingsRow(type: .currentLogin), SettingsRow(type: .changeEnvironment), SettingsRow(type: .logout)]
    
    var barcodeImage: UIImage? {
        return generateQRCode(from: Current.userManager.currentToken ?? "")
    }
}
