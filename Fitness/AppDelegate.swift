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
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    static let networkManager = NetworkManager()
    let googleClientID = "915111778405-k1s68sljovgngrttogdtrifnf7h1hifb.apps.googleusercontent.com"
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        setupGoogleSignIn()
        
        let defaults = UserDefaults.standard
        
        // DEBUG--- sign out
        GIDSignIn.sharedInstance().signOut()
        defaults.set(false, forKey: Identifiers.hasSeenOnboarding)
        
        // END GOAL
        if defaults.bool(forKey: Identifiers.hasSeenOnboarding) { // Seen onboarding and...
            if isGoogleLoggedIn() { // Is logged in
                window?.rootViewController = UINavigationController(rootViewController: HomeController())
            } else { // Needs to relogin
                window?.rootViewController = UINavigationController(rootViewController: OnboardingLoginViewController())
            }
        } else { // Never seen onboarding
            window?.rootViewController = UINavigationController(rootViewController: OnboardingLoginViewController())
        }
        
        #if DEBUG
            print("Running Fitness in debug configuration")
        #else
            print("Running Fitness in release configuration")
            Crashlytics.start(withAPIKey: Keys.fabricAPIKey.value)
        #endif
        
        return true
    }
    
    // Google Login Related
    func setupGoogleSignIn() {
        GIDSignIn.sharedInstance().clientID = googleClientID
        GIDSignIn.sharedInstance().serverClientID = googleClientID
        GIDSignIn.sharedInstance().delegate = self
        if GIDSignIn.sharedInstance().hasAuthInKeychain() {
            DispatchQueue.main.async {
                GIDSignIn.sharedInstance().signInSilently()
            }
        }
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url as URL?,
                                                 sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                                                 annotation: options[UIApplication.OpenURLOptionsKey.annotation])
        return false
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
            
            print("ID Token: \(idToken)")
            print("Client ID: \(googleClientID)")
            
            // So other view controllers will know when it signs in
            NotificationCenter.default.post(
                name: Notification.Name("SuccessfulSignInNotification"), object: nil, userInfo: nil)
            
            NetworkManager.shared.sendGoogleLoginToken(token: idToken) { () in
                print("The Completion Part")
            }
            
        }
    }
    
    
    func logout() {
        GIDSignIn.sharedInstance().signOut()
    }
    
    func isGoogleLoggedIn() -> Bool {
        return GIDSignIn.sharedInstance()?.hasAuthInKeychain() ?? false
    }
}
