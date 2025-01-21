//
//  PhotoDetailProfileView.swift
//  PhotoPic
//
//  Created by 조성민 on 1/19/25.
//

import UIKit
import SnapKit
import Kingfisher

final class PhotoDetailProfileView: BaseView {
    private let profileImageView = UIImageView()
    private let labelStackView = UIStackView()
    private let nameLabel = UILabel()
    private let createdAtLabel = UILabel()
    
    override func configureHierarchy() {
        [
            profileImageView,
            labelStackView
        ].forEach(addSubview)
        [
            nameLabel,
            createdAtLabel
        ].forEach(labelStackView.addArrangedSubview)
    }
    
    override func configureLayout() {
        profileImageView.snp.makeConstraints { make in
            make.size.equalTo(44)
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
        
        labelStackView.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(8)
            make.centerY.equalToSuperview()
            make.trailing.greaterThanOrEqualToSuperview().inset(16)
        }
    }
    
    override func configureViews() {
        profileImageView.layer.cornerRadius = 22
        profileImageView.clipsToBounds = true
        
        nameLabel.font = .systemFont(ofSize: 16)
        
        createdAtLabel.font = .systemFont(
            ofSize: 12,
            weight: .bold
        )
        
        labelStackView.axis = .vertical
        labelStackView.alignment = .leading
        labelStackView.spacing = 4
    }
    
    func configure(
        image: String,
        name: String,
        createdAt: String,
        isWhite: Bool = false
    ) {
        profileImageView.setImage(with: image)
        nameLabel.text = name
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        guard let date = dateFormatter.date(from: createdAt) else {
            createdAtLabel.text = createdAt
            return
        }
        dateFormatter.dateFormat = "yyyy년 M월 d일 게시됨"
        createdAtLabel.text = dateFormatter.string(from: date)
        
        if isWhite {
            nameLabel.textColor = .white
            createdAtLabel.textColor = .white
        }
    }
}
