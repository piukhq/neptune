//
//  APIConstants.swift
//  LocalHero
//
//  Created by Sean Williams on 16/02/2022.
//

import Foundation

enum APIConstants {
    static var apiBaseURLString: String {
        do {
            let apiBaseURL = try Configuration.value(for: .apiBaseUrl)
            return apiBaseURL
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
