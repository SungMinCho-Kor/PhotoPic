//
//  TopicCollectionViewCell.swift
//  PhotoPic
//
//  Created by 조성민 on 1/18/25.
//

import UIKit
import SnapKit
import Kingfisher

final class TopicCollectionViewCell: BaseCollectionViewCell {
    private let imageView = UIImageView()
    private let likeChip = LikeChip()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        likeChip.setCount(0)
    }
    
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
    
    override func configureViews() {
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemGray3
    }
    
    func configure(
        image: String,
        likeCount: Int
    ) {
        imageView.kf.setImage(with: URL(string: image))
        likeChip.setCount(likeCount)
    }
}
