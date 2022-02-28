//
//  SafeDecoding.swift
//  LocalHero
//
//  Created by Sean Williams on 23/02/2022.
//

import Foundation

struct Safe<Base: Decodable>: Decodable {
    let value: Base?

    init(from decoder: Decoder) throws {
        do {
            let container = try decoder.singleValueContainer()
            self.value = try container.decode(Base.self)
        } catch {
            self.value = nil
            print(String(describing: error))
        }
    }
}
