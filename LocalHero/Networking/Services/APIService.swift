//
//  APIService.swift
//  LocalHero
//
//  Created by Sean Williams on 10/03/2022.
//

import Foundation

typealias ServiceCompletionResultHandler<ObjectType: Any, ErrorType: BinkError> = (Result<ObjectType, ErrorType>) -> Void
