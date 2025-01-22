//
//  GCDAPIService.swift
//  PhotoPic
//
//  Created by 조성민 on 1/22/25.
//

import Alamofire
import Foundation

enum CustomError: Error {
    case badRequest
    case unauthorized
    case forbidden
    case notFound
    case wrongEnd
    case unknown
    case alamofireError
    case deinitialized
}

final class GCDAPIService {
    static let shared = GCDAPIService()
    
    private init() {}
    
    func request<T: Router, U: Decodable>(
        api: T,
        successCompletion: @escaping (U) -> Void,
        failureCompletion: @escaping (CustomError) -> Void
    ) {
        AF.request(api)
            .validate()
            .responseDecodable(of: U.self) { [weak self] response in
                switch response.result {
                case .success(let data):
                    successCompletion(data)
                case .failure(let error):
                    dump(error)
                    failureCompletion(self?.handleWrongStatusCode(response.response?.statusCode) ?? .deinitialized)
                }
            }
    }
    
    private func handleWrongStatusCode(_ code: Int?) -> CustomError {
        guard let code else {
            return .alamofireError
        }
        switch code {
        case 400:
            return .badRequest
        case 401:
            return .unauthorized
        case 403:
            return .forbidden
        case 404:
            return .notFound
        case 500, 503:
            return .wrongEnd
        default:
            return .unknown
        }
    }
}
