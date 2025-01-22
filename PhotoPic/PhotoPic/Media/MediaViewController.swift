//
//  MediaViewController.swift
//  PhotoPic
//
//  Created by 조성민 on 1/17/25.
//

import UIKit

final class MediaViewController: BaseViewController {
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: createCollectionViewLayout()
    )
    private let pageBadgeView = PageBadgeView()
    private var list: [PhotoDetail] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
    }
    
    override func configureHierarchy() {
        [
            collectionView,
            pageBadgeView
        ].forEach(view.addSubview)
    }
    
    override func configureLayout() {
        collectionView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        pageBadgeView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.width.equalTo(60)
            make.height.equalTo(30)
        }
    }
    
    override func configureViews() {
        let backButton = UIBarButtonItem(
            title: "",
            style: .plain,
            target: self,
            action: nil
        )
        backButton.tintColor = .black
        navigationItem.backBarButtonItem = backButton
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.contentInsetAdjustmentBehavior = .never
        
        collectionView.register(
            RandomPhotoCollectionViewCell.self,
            forCellWithReuseIdentifier: RandomPhotoCollectionViewCell.identifier
        )
        pageBadgeView.setPage(current: 1, max: max(list.count, 1))
    }
    
    private func createCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let size = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: size)
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: size,
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func fetchData() {
        Task {
            list = try await APIService.shared.fetchRandomPhotos()
            collectionView.reloadData()
        }
    }
}

extension MediaViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return list.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: RandomPhotoCollectionViewCell.identifier,
            for: indexPath
        ) as? RandomPhotoCollectionViewCell else {
            print(#function, "RandomPhotoCollectionViewCell Wrong")
            return UICollectionViewCell()
        }
        cell.configure(list[indexPath.row])
        
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let photoDetailViewController = PhotoDetailViewController(photoDetail: list[indexPath.row])
        navigationController?.pushViewController(
            photoDetailViewController,
            animated: true
        )
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        pageBadgeView.setPage(current: indexPath.row + 1, max: max(list.count, 1))
    }
}
