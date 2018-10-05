//
//  TabBarController.swift
//  Fitness
//
//  Created by Keivan Shahida on 2/24/18.
//  Copyright © 2018 Keivan Shahida. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    // MARK: - INITIALIZATION
    override func viewDidLoad() {
        super.viewDidLoad()

        UITabBar.appearance().barTintColor = .yellow
        tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.white], for: .normal)
        tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.white], for: .selected)

        let homeController = HomeController()
        homeController.tabBarItem = UITabBarItem(title: "browse", image: UIImage(named: "home-tab-selected"), selectedImage: UIImage(named: "home-tab-selected"))

        let classListController = ClassListViewController()
        classListController.tabBarItem = UITabBarItem(title: "classes", image: UIImage(named: "classes-tab"), selectedImage: UIImage(named: "classes-tab"))

        let favoritesController = FavoritesViewController()
        favoritesController.tabBarItem = UITabBarItem(title: "favorites", image: UIImage(named: "favorites-tab"), selectedImage: UIImage(named: "favorites-tab"))

        let viewControllerList = [homeController, classListController, favoritesController]
        viewControllers = viewControllerList
        viewControllers = viewControllerList.map { UINavigationController(rootViewController: $0) }

        (viewControllers![0] as! UINavigationController).isNavigationBarHidden = true

    }
}
