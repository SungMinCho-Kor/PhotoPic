//
//  PhotoDetail.swift
//  PhotoPic
//
//  Created by 조성민 on 1/19/25.
//

struct PhotoDetail: Decodable {
    let id: String
    let image: ImageURL
    let likes: Int
    let likedByUser: Bool
    let width, height: Int
    let user: User
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case image = "urls"
        case likes
        case likedByUser = "liked_by_user"
        case width
        case height
        case user
        case createdAt = "created_at"
    }
}

struct ImageURL: Decodable {
    let value: String
    
    enum CodingKeys: String, CodingKey {
        case value = "regular"
    }
}
