//
//  ImageModel.swift
//  LocalHero
//
//  Created by Sean Williams on 28/02/2022.
//

import Foundation

struct ImageModel: Codable {
    let id, type: Int?
    let url: String?
    let imageDescription, encoding: String?

    enum CodingKeys: String, CodingKey {
        case id, type, url
        case imageDescription = "description"
        case encoding
    }
}
