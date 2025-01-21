//
//  SearchCollectionViewCell.swift
//  PhotoPic
//
//  Created by 조성민 on 1/19/25.
//

import UIKit
import SnapKit
import Kingfisher

final class SearchCollectionViewCell: BaseCollectionViewCell {
    private let imageView = UIImageView()
    private let likeChip = LikeChip()
    
    override func configureHierarchy() {
        [
            imageView,
            likeChip
        ].forEach(contentView.addSubview)
    }
    
    override func configureLayout() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        likeChip.snp.makeConstraints { make in
            make.leading.bottom.equalToSuperview().inset(16)
            make.height.equalTo(20)
        }
    }
    
    func configure(
        image: String,
        like: Int
    ) {
        imageView.setImage(with: image)
        likeChip.setCount(like)
    }
    
    func cancel() {
        imageView.kf.cancelDownloadTask()
    }
}
