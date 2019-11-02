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
                    viewController.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font: UIFont._14MontserratBold!], for: .normal)
                } else {
                    viewController.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font: UIFont._14MontserratMedium!], for: .normal)
                }
            }
        }
    }

    // MARK: - INITIALIZATION
    override func viewDidLoad() {
        super.viewDidLoad()

        UITabBar.appearance().barTintColor = .primaryYellow
        UITabBar.appearance().tintColor = .primaryBlack

        let homeController = HomeViewController()
        homeController.tabBarItem = UITabBarItem(title: ClientStrings.TabBar.homeSection, image: UIImage(named: ImageNames.home), selectedImage: UIImage(named: ImageNames.homeSelected))
        homeController.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font: UIFont._14MontserratBold!], for: .normal)
        homeController.tabBarItem.imageInsets = UIEdgeInsets(top: 3, left: 0, bottom: -3, right: 0)

        let classListController = ClassListViewController()
        classListController.tabBarItem = UITabBarItem(title: ClientStrings.TabBar.classesSection, image: UIImage(named: ImageNames.classes), selectedImage: UIImage(named: ImageNames.classesSelected))
        classListController.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font: UIFont._14MontserratMedium!], for: .normal)
        classListController.tabBarItem.imageInsets = UIEdgeInsets(top: 3, left: 0, bottom: -3, right: 0)

        let favoritesController = FavoritesViewController()
        favoritesController.tabBarItem = UITabBarItem(title: ClientStrings.TabBar.favoritesSection, image: UIImage(named: ImageNames.favorites), selectedImage: UIImage(named: ImageNames.favoritesSelected))
        favoritesController.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font: UIFont._14MontserratMedium!], for: .normal)
        favoritesController.tabBarItem.imageInsets = UIEdgeInsets(top: 3, left: 0, bottom: -3, right: 0)

        let viewControllerList = [homeController, classListController, favoritesController]
        viewControllers = viewControllerList
        viewControllers = viewControllerList.map { UINavigationController(rootViewController: $0) }

        //swiftlint:disable:next force_cast
        (viewControllers![0] as! UINavigationController).isNavigationBarHidden = true
    }

}

extension TabBarController: UITabBarControllerDelegate {
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if let tabName = item.title, tabName == ClientStrings.TabBar.homeSection {
            Answers.logCustomEvent(withName: "Opened \"browse\" Tab")
        }
    }
}
