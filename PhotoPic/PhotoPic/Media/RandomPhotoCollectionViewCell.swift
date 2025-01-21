//
//  RandomPhotoCollectionViewCell.swift
//  PhotoPic
//
//  Created by 조성민 on 1/21/25.
//

import UIKit

final class RandomPhotoCollectionViewCell: BaseCollectionViewCell {
    private let imageView = UIImageView()
    private let profileView = PhotoDetailProfileView()
    
    override func configureHierarchy() {
        [
            imageView,
            profileView
        ].forEach(contentView.addSubview)
    }
    
    override func configureLayout() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        profileView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalToSuperview()
            make.height.equalTo(60)
        }
    }
    
    func configure(_ content: PhotoDetail) {
        imageView.setImage(with: content.image.value)
        profileView.configure(
            image: content.user.profileImage.value,
            name: content.user.name,
            createdAt: content.createdAt,
            isWhite: true
        )
    }
}
