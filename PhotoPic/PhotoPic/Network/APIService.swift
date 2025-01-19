//
//  APIService.swift
//  PhotoPic
//
//  Created by 조성민 on 1/18/25.
//

import Alamofire
import Foundation

final class APIService {
    static let shared = APIService()
    
    private init() {}
    
    func fetchTopic(topic: Topic) async throws -> TopicContent {
        let response = await AF.request(DefaultRouter.fetchTopicList(topic: topic))
            .serializingDecodable([PhotoDetail].self)
            .response
        switch response.result {
        case .success(let element):
            return TopicContent(
                topic: topic,
                list: element
            )
        case .failure(let error):
            throw error
        }
    }
    
    func fetchSearchList(searchRequest: SearchRequest) async throws -> SearchResponse {
        let response = await AF.request(DefaultRouter.fetchSearchList(searchRequest: searchRequest))
            .serializingDecodable(SearchResponse.self)
            .response
        
        switch response.result {
        case .success(let data):
            return data
        case .failure(let error):
            throw error
        }
    }
}
