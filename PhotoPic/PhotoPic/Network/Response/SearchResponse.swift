//
//  SearchResponse.swift
//  PhotoPic
//
//  Created by 조성민 on 1/19/25.
//

struct SearchResponse: Decodable {
    let totalPages: Int
    let results: [SearchResult]
    
    enum CodingKeys: String, CodingKey {
        case totalPages = "total_pages"
        case results
    }
}

struct SearchResult: Decodable {
    let id: String
    let image: ImageURL
    let likes: Int
    let likedByUser: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case image = "urls"
        case likes
        case likedByUser = "liked_by_user"
    }
}
