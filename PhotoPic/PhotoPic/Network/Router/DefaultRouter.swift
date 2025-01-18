//
//  DefaultRouter.swift
//  PhotoPic
//
//  Created by 조성민 on 1/18/25.
//

import Alamofire
import Foundation

enum DefaultRouter {
    case fetchTopicList(topic: Topic)
}

extension DefaultRouter: Router {
    var baseURL: String {
        dump(Environment.baseURL.value)
        return Environment.baseURL.value
    }
    
    var path: String {
        switch self {
        case .fetchTopicList(let topic):
            return "/topics/\(topic.path)/photos"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchTopicList:
                .get
        }
    }
    
    var headers: [String : String] {
        switch self {
        default:
            [
                "Content-Type": "application/json",
                "Authorization": "Client-ID \(Environment.accessToken.value)"
            ]
        }
    }
    
    var parameters: [String : Any] {
        switch self {
        case .fetchTopicList:
            return [:]
        }
    }
    
    var encoding: (any ParameterEncoding)? {
        switch self {
        default:
            nil
        }
    }
    
}
