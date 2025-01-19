//
//  Topic.swift
//  PhotoPic
//
//  Created by 조성민 on 1/18/25.
//

struct TopicContent {
    let topic: Topic
    let list: [PhotoDetail]
}

enum Topic: String, Encodable, CaseIterable {
    case architectureInterior = "건축 및 인테리어"
    case film = "필름"
    case goldenHour = "골든아워"
    case archival = "기록의"
    case wallpapers = "배경 화면"
    case experimental = "실험적인"
    case nature = "자연"
    case animals = "동물"
    case threeDRenders = "3D 렌더링"
    case fashionBeauty = "패션 및 뷰티"
    case travel = "여행하다"
    case people = "사람"
    case texturesPatterns = "텍스쳐 및 패턴"
    case businessWork = "비즈니스 및 업무"
    case streetPhotography = "거리 사진"
    case foodDrink = "식음료"

    var path: String {
        switch self {
        case .architectureInterior:
            return "architecture-interior"
        case .film:
            return "film"
        case .goldenHour:
            return "golden-hour"
        case .archival:
            return "archival"
        case .wallpapers:
            return "wallpapers"
        case .experimental:
            return "experimental"
        case .nature:
            return "nature"
        case .animals:
            return "animals"
        case .threeDRenders:
            return "3d-renders"
        case .fashionBeauty:
            return "fashion-beauty"
        case .travel:
            return "travel"
        case .people:
            return "people"
        case .texturesPatterns:
            return "textures-patterns"
        case .businessWork:
            return "business-work"
        case .streetPhotography:
            return "street-photography"
        case .foodDrink:
            return "food-drink"
        }
    }
}
