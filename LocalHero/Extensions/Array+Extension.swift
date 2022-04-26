//
//  Array+Extension.swift
//  LocalHero
//
//  Created by Sean Williams on 08/03/2022.
//

import Foundation

extension Array {
    subscript (safe index: Int) -> Element? {
        return index < count ? self[index] : nil
    }
}
