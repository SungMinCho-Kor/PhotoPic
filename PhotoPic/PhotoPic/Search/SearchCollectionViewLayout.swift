//
//  SearchCollectionViewLayout.swift
//  PhotoPic
//
//  Created by 조성민 on 1/19/25.
//

import UIKit

final class SearchCollectionViewLayout: UICollectionViewFlowLayout {
    override init() {
        super.init()
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
              let window = sceneDelegate.window else {
            print("SceneDelegate Wrong")
            return
        }
        let spacing: CGFloat = 1
        let width = window.bounds.width / 2 - spacing
        itemSize = CGSize(
            width: width,
            height: width * 1.2
        )
        minimumLineSpacing = spacing
        minimumInteritemSpacing = spacing
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
