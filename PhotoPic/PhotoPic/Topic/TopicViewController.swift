//
//  TopicViewController.swift
//  PhotoPic
//
//  Created by 조성민 on 1/17/25.
//

import UIKit
import SnapKit
import Alamofire

final class TopicViewController: BaseViewController {
    private var topicList: [TopicContent] = []
    private var isRefreshEnabled: Bool = true
    
    private let titleLabel = UILabel()
    private lazy var topicCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: createCollectionView()
    )
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
    }
    
    override func configureHierarchy() {
        [
            titleLabel,
            topicCollectionView
        ].forEach(view.addSubview)
    }
    
    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        topicCollectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureViews() {
        titleLabel.text = "OUR TOPIC"
        titleLabel.font = .systemFont(
            ofSize: 32,
            weight: .bold
        )
        
        topicCollectionView.delegate = self
        topicCollectionView.dataSource = self
        
        topicCollectionView.refreshControl = refreshControl
        refreshControl.addTarget(
            self,
            action: #selector(collectionViewRefresh),
            for: .valueChanged
        )
        
        topicCollectionView.register(
            TopicCollectionViewCell.self,
            forCellWithReuseIdentifier: TopicCollectionViewCell.identifier
        )
        topicCollectionView.register(
            TopicCollectionViewHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: TopicCollectionViewHeader.identifier
        )
    }
    
    private func createCollectionView() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex, _) -> NSCollectionLayoutSection? in
            //TODO: Section마다 레이아웃 달라지면 sectionIndex로 구분하여 설정
            let size = NSCollectionLayoutSize(
                widthDimension: .absolute(180),
                heightDimension: .absolute(240)
            )
            let item = NSCollectionLayoutItem(layoutSize: size)
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: size,
                subitems: [item]
            )
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 8
            section.contentInsets = NSDirectionalEdgeInsets(
                top: 0,
                leading: 16,
                bottom: 16,
                trailing: 16
            )
            section.orthogonalScrollingBehavior = .continuous
            section.boundarySupplementaryItems = [
                NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .absolute(40)
                    ),
                    elementKind: UICollectionView.elementKindSectionHeader,
                    alignment: .top
                )
            ]
            
            return section
        }
    }
    
    private func fetchData() {
        if !isRefreshEnabled {
            Task {
                try await Task.sleep(for: .milliseconds(600))
                refreshControl.endRefreshing()
            }
            return
        }
        Task {
            let randomTopics = Topic.allCases.shuffled().prefix(3)
            var newList: [TopicContent] = []
            do {
                try await withThrowingTaskGroup(of: TopicContent.self) { group in
                    randomTopics.forEach { topic in
                        group.addTask {
                            return try await APIService.shared.fetchTopic(topic: topic)
                        }
                    }
                    for try await result in group {
                        newList.append(result)
                    }
                }
                try await Task.sleep(for: .milliseconds(600))
                refreshControl.endRefreshing()
                topicList = newList
                topicCollectionView.reloadData()
                isRefreshEnabled = false
                enableRefreshAfterTime()
                scrollToLeft()
            } catch {
                // TODO: Error 처리
                dump(error)
            }
        }
    }
}

//MARK: Refresh
extension TopicViewController {
    private func enableRefreshAfterTime() {
        Task {
            try? await Task.sleep(for: .seconds(60))
            isRefreshEnabled = true
        }
    }
    
    private func scrollToLeft() {
        for idx in 0..<topicList.count {
            if !topicList[idx].list.isEmpty {
                topicCollectionView.scrollToItem(
                    at: IndexPath(
                        row: 0,
                        section: idx
                    ),
                    at: .left,
                    animated: false
                )
            }
        }
    }
    
    @objc
    private func collectionViewRefresh(_ sender: UIRefreshControl) {
        fetchData()
    }
}

//MARK: CollectionView
extension TopicViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return topicList.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return topicList[section].list.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TopicCollectionViewCell.identifier,
            for: indexPath
        ) as? TopicCollectionViewCell else {
            print(#function, "TopicCollectionViewCell wrong")
            return UICollectionViewCell()
        }
        if indexPath.section < topicList.count,
           indexPath.row < topicList[indexPath.section].list.count {
            let row = topicList[indexPath.section].list[indexPath.row]
            cell.configure(
                image: row.image.value,
                likeCount: row.likes
            )
        }
        
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: TopicCollectionViewHeader.identifier,
            for: indexPath
        ) as? TopicCollectionViewHeader else {
            print(#function, "TopicCollectionViewHeader wrong")
            return UICollectionReusableView()
        }
        header.setTitle(topicList[indexPath.section].topic.rawValue)
        
        return header
    }
}
