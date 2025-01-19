//
//  User.swift
//  PhotoPic
//
//  Created by 조성민 on 1/19/25.
//

struct User: Decodable {
    let name: String
    let profileImage: UserProfileImage
    
    enum CodingKeys: String, CodingKey {
        case name
        case profileImage = "profile_image"
    }
    
}

struct UserProfileImage: Decodable {
    let value: String
    
    enum CodingKeys: String,CodingKey {
        case value = "small"
    }
}
