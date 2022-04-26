//
//  Notification+Extension.swift
//  LocalHero
//
//  Created by Sean Williams on 30/03/2022.
//

import Foundation

extension Notification.Name {
    // MARK: - Wallet
    static let didLoadWallet = Notification.Name("did_download_wallets")
    static let didLoadLocalWallet = Notification.Name("did_load_local_wallets")
}
