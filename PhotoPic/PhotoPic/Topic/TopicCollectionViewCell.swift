//
//  TopicCollectionViewCell.swift
//  PhotoPic
//
//  Created by 조성민 on 1/18/25.
//

import UIKit
import Kingfisher

final class TopicCollectionViewCell: BaseCollectionViewCell {
    private let imageView = UIImageView()
    private let likeChip = LikeChip()
    
    override func layoutSubviews() {
        super.layoutSubviews()
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
        imageView.backgroundColor = .systemGreen // TODO: 삭제
    }
    
    func configure(image: String, likeCount: Int) {
        imageView.kf.setImage(with: URL(string: image))
        likeChip.setCount(likeCount)
    }
}
