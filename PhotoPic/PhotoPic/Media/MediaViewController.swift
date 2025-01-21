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
    private var list: [PhotoDetail] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(
            true,
            animated: false
        )
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(
            false,
            animated: false
        )
    }
    
    override func configureHierarchy() {
        view.addSubview(collectionView)
    }
    
    override func configureLayout() {
        collectionView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
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
        
        collectionView.register(
            RandomPhotoCollectionViewCell.self,
            forCellWithReuseIdentifier: RandomPhotoCollectionViewCell.identifier
        )
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
}
