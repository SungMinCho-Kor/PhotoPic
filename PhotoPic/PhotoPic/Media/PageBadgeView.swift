//
//  PageBadgeView.swift
//  PhotoPic
//
//  Created by 조성민 on 1/22/25.
//

import UIKit

final class PageBadgeView: BaseView {
    private let pageLabel = UILabel()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        pageLabel.layer.cornerRadius = 15
    }
    
    override func configureHierarchy() {
        addSubview(pageLabel)
    }
    
    override func configureLayout() {
        pageLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configureViews() {
        pageLabel.backgroundColor = .darkGray
        pageLabel.textColor = .white
        pageLabel.textAlignment = .center
        pageLabel.clipsToBounds = true
    }
    
    func setPage(current: Int, max: Int) {
        pageLabel.text = "\(current)/\(max)"
    }
}
