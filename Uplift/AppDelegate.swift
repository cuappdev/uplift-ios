//
//  AppDelegate.swift
//  Uplift
//
//  Created by Cornell AppDev on 2/24/18.
//  Copyright © 2018 Uplift. All rights reserved.
//

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


        let defaults = UserDefaults.standard
        window?.rootViewController = false defaults.bool(forKey: Identifiers.hasSeenOnboarding)
            ? TabBarController()
            : OnboardingViewController()

        #if DEBUG
            print("Running Uplift in debug configuration")
        #else
            print("Running Uplift in release configuration")
            Crashlytics.start(withAPIKey: Keys.fabricAPIKey.value)
        #endif

        return true
    }

    // Google Login Related
    func setupGoogleSignIn() {
        GIDSignIn.sharedInstance().clientID = Keys.googleClientID.value
        GIDSignIn.sharedInstance().serverClientID = Keys.googleClientID.value
        GIDSignIn.sharedInstance().delegate = self
        if GIDSignIn.sharedInstance()?.hasPreviousSignIn() ?? false {
            DispatchQueue.main.async {
                GIDSignIn.sharedInstance()?.restorePreviousSignIn()
            }
        }
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url as URL?)
    }

}
