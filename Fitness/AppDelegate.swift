//
//  AppDelegate.swift
//  Fitness
//
//  Created by Keivan Shahida on 2/24/18.
//  Copyright © 2018 Uplift. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    static let networkManager = NetworkManager()
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        let defaults = UserDefaults.standard
        if defaults.bool(forKey: Identifiers.hasSeenOnboarding) {
            window?.rootViewController = TabBarController()
            
        } else {
            window?.rootViewController = OnboardingViewController()
        }
        
        #if DEBUG
            print("Running Fitness in debug configuration")
        #else
            print("Running Fitness in release configuration")
            Crashlytics.start(withAPIKey: Keys.fabricAPIKey.value)
        #endif
        
        return true
    }
}
