//
//  TabBarController.swift
//  PhotoPic
//
//  Created by 조성민 on 1/18/25.
//

import UIKit

class TabBarController: UITabBarController {
    
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
        let topicViewController = TopicViewController()
        let mediaViewController = MediaViewController()
        let searchViewController = SearchViewController()
        let likeViewController = LikeViewController()
        setViewControllers(
            [
                createNavigationController(
                    viewController: topicViewController,
                    tabImage: UIImage(systemName: "chart.line.uptrend.xyaxis")
                ),
                createNavigationController(
                    viewController: mediaViewController,
                    tabImage: UIImage(systemName: "tv.and.mediabox")
                ),
                createNavigationController(
                    viewController: searchViewController,
                    tabImage: UIImage(systemName: "magnifyingglass")
                ),
                createNavigationController(
                    viewController: likeViewController,
                    tabImage: UIImage(systemName: "heart")
                )
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
        navigationController.navigationBar.scrollEdgeAppearance = appearance
        
        return navigationController
    }
    
}
