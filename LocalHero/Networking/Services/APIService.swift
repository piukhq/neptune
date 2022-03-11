//
//  APIService.swift
//  LocalHero
//
//  Created by Sean Williams on 10/03/2022.
//

import Foundation

/// Used when we need to pass an object or set of objects through the completion handler rather than just a success bool.
typealias ServiceCompletionResultHandler<ObjectType: Any, ErrorType: BinkError> = (Result<ObjectType, ErrorType>) -> Void

/// Used when we need to pass an object or set of objects through the completion handler rather than just a success bool, and the completion handler requires context of the raw http response.
typealias ServiceCompletionResultRawResponseHandler<ObjectType: Any, ErrorType: BinkError> = (Result<ObjectType, ErrorType>, NetworkResponseData?) -> Void
