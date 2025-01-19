//
//  SearchRequest.swift
//  PhotoPic
//
//  Created by 조성민 on 1/19/25.
//

import UIKit

struct SearchRequest: Encodable {
    let query: String
    let page: Int
    let per_page: Int
    let order_by: SearchOrder
    let color: SearchColor?
}

enum SearchOrder: String, Encodable {
    case latest
    case relevant
    
    var buttonTitle: String {
        switch self {
        case .latest:
            return "최신순"
        case .relevant:
            return "관련순"
        }
    }
    
    mutating func toggle() {
        self = self == .latest ? .relevant : .latest
    }
}

enum SearchColor: String, Encodable, CaseIterable {
    case black
    case white
    case yellow
    case red
    case purple
    case green
    case blue
    
    var chipName: String {
        switch self {
        case .black:
            return "블랙"
        case .white:
            return "화이트"
        case .yellow:
            return "옐로우"
        case .red:
            return "레드"
        case .purple:
            return "퍼플"
        case .green:
            return "그린"
        case .blue:
            return "블루"
        }
    }
    
    var uiColor: UIColor {
        switch self {
        case .black:
            return .black
        case .white:
            return .white
        case .yellow:
            return .systemYellow
        case .red:
            return .systemRed
        case .purple:
            return .systemPurple
        case .green:
            return .systemGreen
        case .blue:
            return .systemBlue
        }
    }
}
