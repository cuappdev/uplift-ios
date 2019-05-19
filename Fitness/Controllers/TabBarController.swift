//
//  TabBarController.swift
//  Fitness
//
//  Created by Cornell AppDev on 2/24/18.
//  Copyright © 2018 Uplift. All rights reserved.
//

import Crashlytics
import UIKit

class TabBarController: UITabBarController {
    
    // MARK: - INITIALIZATION
    override func viewDidLoad() {
        super.viewDidLoad()

        UITabBar.appearance().barTintColor = .fitnessYellow
        UITabBar.appearance().tintColor = .fitnessBlack
        tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)

        let homeController = HomeController()
        homeController.tabBarItem = UITabBarItem(title: "browse", image: UIImage(named: "home-tab"), selectedImage: UIImage(named: "home-tab-selected"))

        let classListController = ClassListViewController()
        classListController.tabBarItem = UITabBarItem(title: "classes", image: UIImage(named: "classes-tab"), selectedImage: UIImage(named: "classes-tab-selected"))

        let favoritesController = FavoritesViewController()
        favoritesController.tabBarItem = UITabBarItem(title: "favorites", image: UIImage(named: "favorites-tab"), selectedImage: UIImage(named: "favorites-tab-selected"))

        let viewControllerList = [homeController, classListController, favoritesController]
        viewControllers = viewControllerList
        viewControllers = viewControllerList.map { UINavigationController(rootViewController: $0) }

        (viewControllers![0] as! UINavigationController).isNavigationBarHidden = true

    }
}

extension TabBarController: UITabBarControllerDelegate {
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if let tabName = item.title, tabName == "browse" {
            Answers.logCustomEvent(withName: "Opened \"browse\" Tab")
        }
    }
}
