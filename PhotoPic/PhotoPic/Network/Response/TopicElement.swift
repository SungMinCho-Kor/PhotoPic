//
//  TopicElement.swift
//  PhotoPic
//
//  Created by 조성민 on 1/18/25.
//

struct TopicElement: Decodable {
    let id: String
    let image: ImageURL
    let likes: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case image = "urls"
        case likes = "likes"
    }
}

struct ImageURL: Decodable {
    let value: String
    
    enum CodingKeys: String, CodingKey {
        case value = "regular"
    }
}
