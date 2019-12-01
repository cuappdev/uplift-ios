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
        window?.rootViewController = false /*defaults.bool(forKey: Identifiers.hasSeenOnboarding)*/
            ? TabBarController()
            : setupOnboardingViewController()

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

    // MARK: - Onboarding
    private func setupOnboardingViewController() -> OnboardingViewController {
        var gyms: [String] = []
        var classes: [GymClassInstance] = []

        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        dispatchGroup.enter()

        NetworkManager.shared.getGymNames {
            gyms = $0.map { $0.name }
            // Merge Teagle Up and Down
            if let teagleUp = gyms.firstIndex(of: "Teagle Up"), let teagleDown = gyms.firstIndex(of: "Teagle Down") {
                gyms.remove(at: teagleUp)
                gyms.remove(at: teagleDown)
                gyms.append("Teagle")
            }
            dispatchGroup.leave()
        }

        let dateFormatter = DateFormatter()
        // Display 4 classes from different (random) tag categories
        NetworkManager.shared.getGymClassesForDate(date: dateFormatter.string(from: Date())) { classInstaces in
            // Less than 4 classes -> Use Hard coded defaults
            if classInstaces.count < 4 {
                dispatchGroup.leave()
                return
            }

            NetworkManager.shared.getTags { tags in
                // Sample 4 without replacement
                var randomIndeces = Set<Int>()
                while randomIndeces.count < 4 {
                    let index = Int.random(in: 0..<tags.count)
                    randomIndeces.insert(index)
                }
                // Tag categories not yet chosen to be displayed
                var tagSubset = randomIndeces.map { tags[$0] }

                // Iterate over ique classes that don't share the same name
                for instance in classInstaces {
                    if !classes.contains(where: { $0.className == instance.className }) {
                        // Add class only if it has a tag not yet displayed
                        for tag in tagSubset {
                            if let index = tagSubset.index(of: $0) {
                                // Remove chosen class's tag from subset, add to tags to be displayed
                                tagSubset.remove(at: index)
                                classes.append(instance)
                                break
                            }
                        }
                        // Chose 4 classes, can stop
                        if classes.count >= 4 { break }
                    }
                }

                dispatchGroup.leave()
            }
        }

        DispatchGroup.notify(queue: .main, execute: {
            self.window?.rootViewController = classes.count < 4
                ? OnboardingViewController()
                : OnboardingViewController(gymNames: gyms, classes: classes)
        })

       return OnboardingViewController(gymNames: gyms, classes: classes)
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
