//
//  TabBarController.swift
//  Uplift
//
//  Created by Cornell AppDev on 2/24/18.
//  Copyright © 2018 Uplift. All rights reserved.
//

import Crashlytics
import UIKit

class TabBarController: UITabBarController {

    override var selectedViewController: UIViewController? {
        didSet {
            guard let viewControllers = viewControllers else {
                return
            }

            for viewController in viewControllers {
                if viewController == selectedViewController {
                    viewController.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font: UIFont._14MontserratBold as Any], for: .normal)
                } else {
                    viewController.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font: UIFont._14MontserratMedium as Any, NSAttributedString.Key.foregroundColor: UIColor.primaryBlack], for: .normal)
                }
            }
        }
    }

    // MARK: - INITIALIZATION
    override func viewDidLoad() {
        super.viewDidLoad()

        UITabBar.appearance().backgroundColor = .primaryYellow
        UITabBar.appearance().tintColor = .primaryBlack
        UITabBar.appearance().isTranslucent = false

        let homeController = HomeViewController()
        homeController.tabBarItem = getTabBarItem(title: ClientStrings.TabBar.homeSection, imageName: ImageNames.home, selectedImageName: ImageNames.homeSelected)

        let classListController = ClassListViewController()
        classListController.tabBarItem = getTabBarItem(title: ClientStrings.TabBar.classesSection, imageName: ImageNames.classes, selectedImageName: ImageNames.classesSelected)

        let sportsFeedController = SportsFeedViewController()
        sportsFeedController.tabBarItem = getTabBarItem(title: ClientStrings.TabBar.sportsFeedSection, imageName: ImageNames.sportsFeed, selectedImageName: ImageNames.sportsFeedSelected)

        let favoritesController = FavoritesViewController()
        favoritesController.tabBarItem = getTabBarItem(title: ClientStrings.TabBar.favoritesSection, imageName: ImageNames.favorites, selectedImageName: ImageNames.favoritesSelected)

        let viewControllerList = [homeController, classListController, sportsFeedController, favoritesController]
        let navControllerList = viewControllerList.map { UINavigationController(rootViewController: $0) }
        viewControllers = navControllerList

        if let navVC = viewControllers?.first as? UINavigationController {
            navVC.isNavigationBarHidden = true
        }

        selectedViewController = navControllerList[0]
    }

    // MARK: - Private helpers
    private func getTabBarItem(title: String, imageName: String, selectedImageName: String) -> UITabBarItem {
        let tabBarItem = UITabBarItem(title: title, image: UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: selectedImageName))
        tabBarItem.imageInsets = UIEdgeInsets(top: 2, left: 0, bottom: -2, right: 0)
        return tabBarItem
    }

}

extension TabBarController: UITabBarControllerDelegate {
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if let tabName = item.title, tabName == ClientStrings.TabBar.homeSection {
            Answers.logCustomEvent(withName: "Opened \"Home\" Tab")
        }
    }
}
