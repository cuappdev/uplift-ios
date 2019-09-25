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
        
        setupGoogleSignIn()
        
        let defaults = UserDefaults.standard
        if defaults.bool(forKey: Identifiers.hasSeenOnboarding) { // Seen onboarding and...
            window?.rootViewController = TabBarController()
        } else { // Never seen onboarding
            window?.rootViewController = OnboardingViewController()
        }
        
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

// MARK: Implement Google Sign in Methods
extension AppDelegate: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error == nil {
            let idToken = user.authentication.idToken ?? ""
            let userId = user.userID ?? "ID" // For client-side use only!
            let fullName = user.profile.name ?? "First Last"
            let givenName = user.profile.givenName ?? "First"
            let familyName = user.profile.familyName ?? "Last"
            let email = user.profile.email ?? "uplift@defaultvalue.com"
            let netId = String(email.split(separator: "@")[0])
            User.currentUser = User(id: userId, name: fullName, netId: netId, givenName: givenName, familyName: familyName, email: email)
            
            // So other view controllers will know when it signs in
            NotificationCenter.default.post(
                name: Notification.Name("SuccessfulSignInNotification"), object: nil, userInfo: nil)
            
            NetworkManager.shared.sendGoogleLoginToken(token: idToken) { (tokens) in
                // Store in User Defualts
                let defaults = UserDefaults.standard
                defaults.set(tokens.backendToken, forKey: Identifiers.googleToken)
                defaults.set(tokens.expiration, forKey: Identifiers.googleExpiration)
                defaults.set(tokens.refreshToken, forKey: Identifiers.googleRefresh)
            }
        }
    }
    
    func logout() {
        GIDSignIn.sharedInstance().signOut()
    }
    
    func isGoogleLoggedIn() -> Bool {
        return GIDSignIn.sharedInstance()?.hasPreviousSignIn() ?? false
    }
}
