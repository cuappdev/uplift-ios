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
        
        let homeController = HomeController()
        homeController.tabBarItem = UITabBarItem(tabBarSystemItem: .mostViewed, tag: 0)
        tabBar.barTintColor = .yellow
        
        let viewControllerList = [ homeController ]
        viewControllers = viewControllerList
        viewControllers = viewControllerList.map { UINavigationController(rootViewController: $0) }
        
        (viewControllers![0] as! UINavigationController).isNavigationBarHidden = true
        
    }
}
