//
//  APIErrorResponses.swift
//  LocalHero
//
//  Created by Sean Williams on 23/02/2022.
//

struct ResponseErrors: Decodable {
    var nonFieldErrors: [String]?

    enum CodingKeys: String, CodingKey {
        case nonFieldErrors = "non_field_errors"
    }
}
