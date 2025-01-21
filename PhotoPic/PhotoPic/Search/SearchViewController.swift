//
//  SearchViewController.swift
//  PhotoPic
//
//  Created by 조성민 on 1/17/25.
//

import UIKit
import SnapKit

final class SearchViewController: BaseViewController {
    private let emptyStateLabel = UILabel()
    private let searchBar = UISearchBar()
    private let divideView = UIView()
    private let colorScrollView = UIScrollView()
    private let colorStackView = UIStackView()
    private let colorChips: [SearchColorChip] = SearchColor.allCases.map { SearchColorChip(color: $0) }
    private let orderButton = SearchOrderChip()
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: SearchCollectionViewLayout() // TODO: lazy와 let으로 할 때 차이
    )
    
    private var nextState = SearchViewControllerState()
    private var prevState = SearchViewControllerState()
    
    override func configureHierarchy() {
        [
            searchBar,
            divideView,
            colorScrollView,
            orderButton,
            collectionView,
            emptyStateLabel
        ].forEach(view.addSubview)
        colorChips.forEach(colorStackView.addArrangedSubview)
        colorScrollView.addSubview(colorStackView)
    }
    
    override func configureLayout() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(8)
            make.height.equalTo(44)
        }
        
        divideView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(1)
        }
        
        colorScrollView.snp.makeConstraints { make in
            make.top.equalTo(divideView.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(36)
        }
        
        colorStackView.snp.makeConstraints { make in
            make.edges.equalTo(colorScrollView)
            make.height.equalTo(colorScrollView)
        }
        
        orderButton.snp.makeConstraints { make in
            make.centerY.equalTo(colorScrollView)
            make.trailing.equalToSuperview().offset(12)
            make.height.equalTo(40)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(colorScrollView.snp.bottom).offset(8)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        emptyStateLabel.snp.makeConstraints { make in
            make.edges.equalTo(collectionView)
        }
    }
    
    override func configureViews() {
        navigationItem.title = "SEARCH PHOTO"
        
        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal
        searchBar.searchTextField.placeholder = "키워드를 입력하세요"
        searchBar.autocorrectionType = .no
        searchBar.autocapitalizationType = .none
        
        divideView.backgroundColor = .systemGray4
        
        collectionView.prefetchDataSource = self
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(
            SearchCollectionViewCell.self,
            forCellWithReuseIdentifier: SearchCollectionViewCell.identifier
        )
        collectionView.keyboardDismissMode = .onDrag
        
        colorScrollView.showsHorizontalScrollIndicator = false
        colorScrollView.contentInset = UIEdgeInsets(
            top: 0,
            left: 8,
            bottom: 0,
            right: 80
        )
        colorScrollView.keyboardDismissMode = .onDrag
        
        colorStackView.spacing = 8
        colorStackView.distribution = .fillProportionally
        
        for idx in 0..<colorChips.count {
            colorChips[idx].tag = idx
            colorChips[idx].addTarget(
                self,
                action: #selector(colorChipTapped),
                for: .touchUpInside
            )
        }
        
        orderButton.addTarget(
            self,
            action: #selector(orderButtonTapped),
            for: .touchUpInside
        )
        
        emptyStateLabel.textAlignment = .center
        emptyStateLabel.font = .systemFont(
            ofSize: 20,
            weight: .bold
        )
        emptyStateLabel.text = "사진을 검색해보세요"
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(emptyStateLabelTapped)
        )
        emptyStateLabel.addGestureRecognizer(tapGesture)
        emptyStateLabel.isUserInteractionEnabled = true
        
        let backButton = UIBarButtonItem(
            title: "",
            style: .plain,
            target: self,
            action: nil
        )
        backButton.tintColor = .black
        navigationItem.backBarButtonItem = backButton
    }
    
    private func fetchData() async throws -> SearchResponse {
        if let filterColorIndex = prevState.filterColorIndex {
            return try await APIService.shared.fetchSearchList(
                searchRequest: SearchRequest(
                    query: prevState.searchText,
                    page: prevState.currentPage,
                    per_page: 20,
                    order_by: prevState.order,
                    color: SearchColor.allCases[filterColorIndex]
                )
            )
        } else {
            return try await APIService.shared.fetchSearchList(
                searchRequest: SearchRequest(
                    query: prevState.searchText,
                    page: prevState.currentPage,
                    per_page: 20,
                    order_by: prevState.order,
                    color: nil
                )
            )
        }
    }
}

//MARK: Objective-C
@objc
extension SearchViewController {
    @objc
    private func colorChipTapped(_ sender: SearchColorChip) {
        if let filterColorIndex = nextState.filterColorIndex {
            if filterColorIndex == sender.tag {
                colorChips[filterColorIndex].deselectChip()
                nextState.filterColorIndex = nil
            } else {
                colorChips[filterColorIndex].deselectChip()
                colorChips[sender.tag].selectChip()
                nextState.filterColorIndex = sender.tag
            }
        } else {
            colorChips[sender.tag].selectChip()
            nextState.filterColorIndex = sender.tag
        }
    }
    
    @objc
    private func orderButtonTapped(_ sender: UIButton) {
        view.endEditing(true)
        nextState.order.toggle()
        orderButton.configuration?.title = nextState.order.buttonTitle
    }
    
    @objc
    private func emptyStateLabelTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}

//MARK: SearchBar
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else {
            print("SearchBar Text Nil")
            return
        }
        nextState.searchText = text
        if nextState.searchText != prevState.searchText
            || nextState.filterColorIndex != prevState.filterColorIndex
            || nextState.order != prevState.order {
            fetchSearchData(query: text)
        }
    }
    
    private func fetchSearchData(query: String) {
        Task {
            prevState = nextState
            let newList = try await fetchData()
            prevState.list = newList.results
            prevState.totalPages = newList.totalPages
            print("totalPages: ", prevState.totalPages)
            nextState.currentPage = 1
            nextState.totalPages = 1
            nextState.list = []
            collectionView.reloadData()
            if prevState.list.isEmpty {
                emptyStateLabel.text = "검색 결과가 없어요."
                emptyStateLabel.isHidden = false
            } else {
                emptyStateLabel.isHidden = true
                collectionView.scrollToItem(
                    at: IndexPath(
                        item: 0,
                        section: 0
                    ),
                    at: .top,
                    animated: false
                )
            }
        }
    }
}

//MARK: CollectionView
extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return prevState.list.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SearchCollectionViewCell.identifier,
            for: indexPath
        ) as? SearchCollectionViewCell else {
            print(#function, "SearchCollectionViewCell Wrong")
            return UICollectionViewCell()
        }
        let row = prevState.list[indexPath.row]
        cell.cancel()
        cell.configure(
            image: row.image.value,
            like: row.likes
        )
        
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let detailViewController = PhotoDetailViewController(photoDetail: prevState.list[indexPath.row])
        navigationController?.pushViewController(
            detailViewController,
            animated: true
        )
    }
}

//MARK: Prefetch
extension SearchViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(
        _ collectionView: UICollectionView,
        prefetchItemsAt indexPaths: [IndexPath]
    ) {
        if indexPaths.contains([0, prevState.list.count - 1]) {
            if prevState.currentPage < prevState.totalPages {
                print("pagination current page: ", prevState.currentPage+1)
                Task {
                    prevState.currentPage += 1
                    let result = try await fetchData()
                    prevState.list.append(contentsOf: result.results)
                    collectionView.reloadData()
                }
            }
        }
    }
    
    //TODO: Cancel 오류 수정
    func collectionView(
        _ collectionView: UICollectionView,
        cancelPrefetchingForItemsAt indexPaths: [IndexPath]
    ) {
        for indexPath in indexPaths {
            guard let cell = collectionView.cellForItem(at: indexPath) as? SearchCollectionViewCell else {
                return
            }
            cell.cancel()
        }
    }
}
