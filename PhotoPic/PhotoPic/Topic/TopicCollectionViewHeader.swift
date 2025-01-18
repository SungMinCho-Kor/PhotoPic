//
//  TopicCollectionViewHeader.swift
//  PhotoPic
//
//  Created by 조성민 on 1/18/25.
//

import UIKit
import SnapKit

final class TopicCollectionViewHeader: UICollectionReusableView, ViewConfiguration, ReusableIdentifier {
    private let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureHierarchy()
        configureLayout()
        configureViews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHierarchy() {
        addSubview(titleLabel)
    }
    
    func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview().inset(8)
        }
    }
    
    func configureViews() {
        titleLabel.font = .systemFont(
            ofSize: 18,
            weight: .bold
        )
    }
    
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
}
