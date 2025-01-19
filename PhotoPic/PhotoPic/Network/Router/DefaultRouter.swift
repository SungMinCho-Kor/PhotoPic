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
    case fetchSearchList(searchRequest: SearchRequest)
    case fetchStatistics(id: String)
}

extension DefaultRouter: Router {
    var baseURL: String {
        return Environment.baseURL.value
    }
    
    var path: String {
        switch self {
        case .fetchTopicList(let topic):
            return "/topics/\(topic.path)/photos"
        case .fetchSearchList(let searchRequest):
            return "/search/photos"
        case .fetchStatistics(let id):
            return "/photos/\(id)/statistics"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchTopicList:
            return .get
        case .fetchSearchList:
            return .get
        case .fetchStatistics:
            return .get
        }
    }
    
    var headers: [String : String] {
        switch self {
        default:
            return [
                "Content-Type": "application/json",
                "Authorization": "Client-ID \(Environment.accessToken.value)"
            ]
        }
    }
    
    var parameters: [String : Any] {
        switch self {
        case .fetchTopicList:
            return [:]
        case .fetchSearchList(let searchRequest):
            return searchRequest.asDictionary()
        case .fetchStatistics:
            return [:]
        }
    }
    
    var encoding: (any ParameterEncoding)? {
        switch self {
        case .fetchSearchList:
            return URLEncoding.default
        default:
            return nil
        }
    }
    
}
