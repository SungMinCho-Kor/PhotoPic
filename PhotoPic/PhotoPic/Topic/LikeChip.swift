//
//  LikeChip.swift
//  PhotoPic
//
//  Created by 조성민 on 1/18/25.
//

import UIKit
import SnapKit

final class LikeChip: BaseView {
    private let starImageView = UIImageView()
    let starCountLabel = UILabel()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
//        layer.masksToBounds = true
    }
    
    override func configureHierarchy() {
        [
            starImageView,
            starCountLabel
        ].forEach(addSubview)
    }
    
    override func configureLayout() {
        starImageView.snp.makeConstraints { make in
            make.size.equalTo(12)
            make.leading.equalToSuperview().inset(8)
            make.centerY.equalToSuperview()
        }
        starCountLabel.snp.makeConstraints { make in
            make.leading.equalTo(starImageView.snp.trailing).offset(4)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(8)
        }
    }
    
    override func configureViews() {
        backgroundColor = .darkGray
        starImageView.image = UIImage(systemName: "star.fill")
        starImageView.tintColor = .systemYellow
        
        starCountLabel.textColor = .white
        starCountLabel.font = .systemFont(ofSize: 12)
    }
    
    func setCount(_ count: Int) {
        starCountLabel.text = count.formatted()
    }
}
