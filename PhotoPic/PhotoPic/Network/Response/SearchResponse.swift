//
//  SearchResponse.swift
//  PhotoPic
//
//  Created by 조성민 on 1/19/25.
//

struct SearchResponse: Decodable {
    let totalPages: Int
    let results: [PhotoDetail]
    
    enum CodingKeys: String, CodingKey {
        case totalPages = "total_pages"
        case results
    }
}
