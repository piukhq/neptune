//
//  World.swift
//  LocalHero
//
//  Created by Sean Williams on 22/02/2022.
//

import Foundation

let Current = World()

class World {
    lazy var rootStateMachine = RootStateMachine()
    lazy var database = Database(named: "localhero")
    lazy var apiClient = APIClient()
    lazy var userManager = UserManager()
    lazy var userDefaults: HeroUserDefaults = UserDefaults.standard
    lazy var wallet = Wallet()
    lazy var navigate = Navigate()
}


protocol HeroUserDefaults {
    // HeroUserDefaults specific methods supporting Keys
    func set(_ value: Any?, forDefaultsKey defaultName: UserDefaults.Keys)
    func string(forDefaultsKey defaultName: UserDefaults.Keys) -> String?
    func bool(forDefaultsKey defaultName: UserDefaults.Keys) -> Bool
    func value(forDefaultsKey defaultName: UserDefaults.Keys) -> Any?

    // UserDefault methods where we cannot support Keys
    func set(_ value: Any?, forKey defaultName: String)
    func string(forKey defaultName: String) -> String?
    func bool(forKey defaultName: String) -> Bool
    func value(forKey defaultName: String) -> Any?
}

extension UserDefaults: HeroUserDefaults {
    enum Keys {
        case localWalletOrder(userId: String, walletType: Wallet.WalletType)
        case debugBaseURL
        
        var keyValue: String {
            switch self {
            case .localWalletOrder(let userId, let type):
                return "localWalletOrders_user:_\(userId)_ \(type.rawValue)"
            case .debugBaseURL:
                return "debugBaseURL"
            }
        }
    }
    
    func set(_ value: Any?, forDefaultsKey defaultName: UserDefaults.Keys) {
        set(value, forKey: defaultName.keyValue)
    }

    func string(forDefaultsKey defaultName: UserDefaults.Keys) -> String? {
        return string(forKey: defaultName.keyValue)
    }

    func bool(forDefaultsKey defaultName: UserDefaults.Keys) -> Bool {
        return bool(forKey: defaultName.keyValue)
    }

    func value(forDefaultsKey defaultName: UserDefaults.Keys) -> Any? {
        return value(forKey: defaultName.keyValue)
    }
}
