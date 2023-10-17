//
//  AppDelegate.swift
//  Uplift
//
//  Created by Cornell AppDev on 2/24/18.
//  Copyright © 2018 Uplift. All rights reserved.
//

import AppDevAnnouncements
import Crashlytics
import Fabric
import Firebase
import GoogleSignIn
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()

#if DEBUG
        // Run ad hock unit test
        AdHockTest.runAllTests()
#endif

        FitnessCenterManager.shared.fetch()

        // TODO: - Add back onboarding
//        let defaults = UserDefaults.standard
//        if defaults.bool(forKey: Identifiers.hasSeenOnboarding) {
        let vc = HomeViewController()
        window?.rootViewController = UINavigationController(rootViewController: vc)
//        } else {
//            displayOnboardingViewController()
//        }

        AnnouncementNetworking.setupConfig(
            scheme: Keys.announcementsScheme.value,
            host: Keys.announcementsHost.value,
            commonPath: Keys.announcementsCommonPath.value,
            announcementPath: Keys.announcementsPath.value
        )

        #if DEBUG
            print("Running Uplift in debug configuration")
        #else
            print("Running Uplift in release configuration")
            Crashlytics.start(withAPIKey: Keys.fabricAPIKey.value)
        #endif

        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }

    // MARK: - Onboarding
    // TODO: - Add Back onboarding
//    private func displayOnboardingViewController() {
//       NetworkManager.shared.getOnboardingInfo { gyms, cl10sses in
//            self.window?.rootViewController = gyms.count < 4 || classes.count < 4
//                ? OnboardingViewController()
//                : OnboardingViewController(gymNames: gyms, classes: classes)
//       }

        // No Internet/Networking Failed/Networking in progress
//        self.window?.rootViewController = OnboardingLoadingViewController()
//    }
}
