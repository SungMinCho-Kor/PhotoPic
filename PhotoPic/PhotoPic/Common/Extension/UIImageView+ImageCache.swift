//
//  UIImageView+ImageCache.swift
//  PhotoPic
//
//  Created by 조성민 on 1/21/25.
//

import UIKit
import Kingfisher

extension UIImageView {
    func setImage(with urlString: String) {
        ImageCache.default.retrieveImage(forKey: urlString, options: nil) { result in
            switch result {
            case .success(let value):
                if let image = value.image {
                    DispatchQueue.main.async {
                        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
                              let window = sceneDelegate.window else {
                            print("SceneDelegate Wrong")
                            self.image = image
                            return
                        }
                        self.image = image.resizeKeepRatio(newWidth: window.bounds.width / 2)
                    }
                } else {
                    guard let url = URL(string: urlString) else { return }
                    let resource = KF.ImageResource(downloadURL: url, cacheKey: urlString)
                    DispatchQueue.main.async {
                        self.kf.setImage(with: resource)
                    }
                }
            case .failure(let error):
                dump(error)
            }
        }
    }
}
