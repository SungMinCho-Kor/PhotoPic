//
//  InformationRowView.swift
//  PhotoPic
//
//  Created by 조성민 on 1/20/25.
//

import UIKit
import SnapKit

final class InformationRowView: BaseView {
    private let titleLabel = UILabel()
    private let contentLabel = UILabel()
    
    override func configureHierarchy() {
        [
            titleLabel,
            contentLabel
        ].forEach(addSubview)
    }
    
    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.leading.verticalEdges.equalToSuperview()
        }
        
        contentLabel.snp.makeConstraints { make in
            make.trailing.verticalEdges.equalToSuperview()
        }
    }
    
    override func configureViews() {
        titleLabel.textAlignment = .left
        titleLabel.font = .systemFont(
            ofSize: 16,
            weight: .semibold
        )
        
        contentLabel.textAlignment = .right
        contentLabel.numberOfLines = 0
        contentLabel.font = .systemFont(ofSize: 14)
    }
    
    func configure(
        title: String,
        content: String
    ) {
        titleLabel.text = title
        contentLabel.text = content
    }
}
