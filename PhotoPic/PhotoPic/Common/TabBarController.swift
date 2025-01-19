//
//  TabBarController.swift
//  PhotoPic
//
//  Created by 조성민 on 1/18/25.
//

import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAppearance()
        configureTabs()
    }
    
    private func configureAppearance() {
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = .systemBackground
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        tabBar.isTranslucent = false
    }
    
    private func configureTabs() {
        let topicNavigationController = createNavigationController(
            viewController: TopicViewController(),
            tabImage: UIImage(systemName: "chart.line.uptrend.xyaxis")
        )
        let mediaNavigationController = createNavigationController(
            viewController: MediaViewController(),
            tabImage: UIImage(systemName: "tv.and.mediabox")
        )
        let searchNavigationController = createNavigationController(
            viewController: SearchViewController(),
            tabImage: UIImage(systemName: "magnifyingglass")
        )
        let likeNavigationController = createNavigationController(
            viewController: LikeViewController(),
            tabImage: UIImage(systemName: "heart")
        )
        
        setViewControllers(
            [
                topicNavigationController,
                mediaNavigationController,
                searchNavigationController,
                likeNavigationController
            ],
            animated: false
        )
        tabBar.tintColor = .black
    }

    private func createNavigationController(
        viewController: UIViewController,
        tabImage: UIImage?
    ) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.tabBarItem.image = tabImage
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .systemBackground
        navigationController.navigationBar.standardAppearance = appearance
        
        return navigationController
    }
}
