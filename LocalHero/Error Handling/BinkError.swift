//
//  BinkError.swift
//  LocalHero
//
//  Created by Sean Williams on 22/02/2022.
//

import Foundation

enum BinkErrorDomain: Int {
    case networking
    case configuration
    case walletService
    case userService
}

protocol BinkError: Error {
    var domain: BinkErrorDomain { get }
    var message: String { get }
}

extension BinkError {
    var localizedDescription: String {
        return message
    }
}
