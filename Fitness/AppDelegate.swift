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
import FBSDKCoreKit
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    static let networkManager = NetworkManager()
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        print("Starts where it usually does")
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        // Initialize Google sign-in
        GIDSignIn.sharedInstance().clientID = "915111778405-k1s68sljovgngrttogdtrifnf7h1hifb.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
        // Facebook sign-in token
        let facebookUserToken: FBSDKAccessToken?
        
        let defaults = UserDefaults.standard
        
        window?.rootViewController = OnboardingLoginViewController()
        /*
        if defaults.bool(forKey: Identifiers.hasSeenOnboarding) {
            window?.rootViewController = TabBarController()
        } else {
            window?.rootViewController = OnboardingViewController()
        }
         */
        
        #if DEBUG
            print("Running Fitness in debug configuration")
        #else
            print("Running Fitness in release configuration")
            Crashlytics.start(withAPIKey: Keys.fabricAPIKey.value)
        #endif
        
        return true
    }
    
    // MARK: Facebook + Google Login
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if let urlScheme = url.scheme {
            if (urlScheme.hasPrefix("fb\(String(describing: FBSDKSettings.appID()))") && url.host == "authorize") { // Facebook
                return FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
            } else if (urlScheme.hasPrefix(Bundle.main.bundleIdentifier!) || urlScheme.hasPrefix("com.googleusercontent.apps.")) { // Google
                return GIDSignIn.sharedInstance().handle(url as URL?,
                                                         sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                                                         annotation: options[UIApplication.OpenURLOptionsKey.annotation])
            }
        }
        return false
    }
}

// MARK: Implement Google Sign in Methods
extension AppDelegate: GIDSignInDelegate {
    
    // Sign in
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
            // Perform any operations on signed in user here.
            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            // ...
        }
    }
    
    // Sign out
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
}
