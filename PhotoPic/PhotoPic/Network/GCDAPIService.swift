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
    
    var alert: String {
        switch self {
        case .badRequest:
            "파라미터 오류"
        case .unauthorized:
            "토큰 오류"
        case .forbidden:
            "권한 오류"
        case .notFound:
            "페이지 오류"
        case .wrongEnd:
            "서버 오류"
        case .unknown:
            "알 수 없는 오류"
        case .alamofireError:
            "내부 오류"
        case .deinitialized:
            "내부 메모리 오류"
        }
    }
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
