//
//  StatisticsResponse.swift
//  PhotoPic
//
//  Created by 조성민 on 1/20/25.
//

struct StatisticsResponse: Decodable {
    let downloads: Statistics
    let views: Statistics
}

struct Statistics: Decodable {
    let total: Int
    let historical: Historical
}

struct Historical: Decodable {
    let values: [HistoricalValue]
}

struct HistoricalValue: Decodable, Hashable {
    let date: String
    let value: Int
}
