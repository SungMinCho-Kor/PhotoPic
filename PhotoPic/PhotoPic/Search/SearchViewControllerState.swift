//
//  SearchViewControllerState.swift
//  PhotoPic
//
//  Created by 조성민 on 1/19/25.
//

struct SearchViewControllerState {
    var currentPage: Int = 1
    var totalPages: Int = 1
    var list: [SearchResult] = []
    var order: SearchOrder = .relevant
    var filterColorIndex: Int? = nil
    var searchText: String = ""
}
