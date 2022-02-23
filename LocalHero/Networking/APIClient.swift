//
//  APIClient.swift
//  LocalHero
//
//  Created by Sean Williams on 22/02/2022.
//

import Alamofire
import Foundation

// MARK: - Config and init
struct NetworkResponseData {
    var urlResponse: HTTPURLResponse?
    var errorMessage: String?
}

typealias APIClientCompletionHandler<ResponseType: Any> = (Result<ResponseType, NetworkingError>, NetworkResponseData?) -> Void

final class APIClient {
    enum Certificates {
        static let bink = Certificates.certificate(filename: "bink")

        private static func certificate(filename: String) -> SecCertificate {
            let filePath = Bundle.main.path(forResource: filename, ofType: "der")!
            let data = try! Data(contentsOf: URL(fileURLWithPath: filePath))
            let certificate = SecCertificateCreateWithData(nil, data as CFData)!

            return certificate
        }
    }
    
    private let networkReachabilityManager = NetworkReachabilityManager()
    private let session: Session
    
    init() {
        let url = EnvironmentType.production.rawValue
        let evaluators = [
            url:
                PinnedCertificatesTrustEvaluator(certificates: [
                    Certificates.bink
                ])
        ]

        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10.0
        
        session = Session(configuration: configuration, serverTrustManager: ServerTrustManager(allHostsMustBeEvaluated: false, evaluators: evaluators))
    }
    
    private var networkIsReachable: Bool {
        return networkReachabilityManager?.isReachable ?? false
    }
    
}


struct BinkNetworkRequest {
    var endpoint: APIEndpoint
    var method: HTTPMethod
    var queryParameters: [String: String]?
    var headers: [BinkHTTPHeader]?
    var isUserDriven: Bool
}

struct ValidatedNetworkRequest {
    var requestUrl: String
    var headers: HTTPHeaders
}

extension APIClient {
    
    func performRequest<ResponseType: Decodable>(_ request: BinkNetworkRequest, expecting responseType: ResponseType.Type, completion: APIClientCompletionHandler<ResponseType>?) {
        validateRequest(request) { [weak self] (validatedRequest, error) in
            if let error = error {
                completion?(.failure(error), nil)
                return
            }
            guard let validatedRequest = validatedRequest else {
                completion?(.failure(.invalidRequest), nil)
                return
            }
            session.request(validatedRequest.requestUrl, method: request.method, headers: validatedRequest.headers).cacheResponse(using: ResponseCacher.doNotCache).responseJSON { [weak self] response in
//                self?.handleResponse(response, endpoint: request.endpoint, expecting: responseType, isUserDriven: request.isUserDriven, completion: completion)
            }
        }
    }
    
    private func validateRequest(_ request: BinkNetworkRequest, completion: (ValidatedNetworkRequest?, NetworkingError?) -> Void) {
        if !networkIsReachable && request.isUserDriven {
            completion(nil, .noInternetConnection)
        }
        
        var requestUrl: String?
        if let params = request.queryParameters {
            requestUrl = request.endpoint.urlString(withQueryParameters: params)
        } else {
            requestUrl = request.endpoint.urlString
        }
        guard let url = requestUrl else {
            completion(nil, .invalidUrl)
            return
        }
        
        guard request.endpoint.allowedMethods.contains(request.method) else {
            completion(nil, .methodNotAllowed)
            return
        }

        let requestHeaders = HTTPHeaders(BinkHTTPHeaders.asDictionary(request.headers ?? request.endpoint.headers))
        completion(ValidatedNetworkRequest(requestUrl: url, headers: requestHeaders), nil)
    }
}
