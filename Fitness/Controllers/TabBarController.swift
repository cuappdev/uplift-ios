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
        
        UITabBar.appearance().barTintColor = .fitnessYellow
        
        let homeController = HomeController()
        homeController.tabBarItem = UITabBarItem(tabBarSystemItem: .mostViewed, tag: 0)
        
        let classListController = ClassListViewController()
        classListController.tabBarItem = UITabBarItem(tabBarSystemItem: .mostViewed, tag: 1)
        
        let viewControllerList = [homeController, classListController]
        viewControllers = viewControllerList
        viewControllers = viewControllerList.map { UINavigationController(rootViewController: $0) }
    }
}
