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
//        if defaults.bool(forKey: Identifiers.hasSeenOnboarding) {
        if false {
            window?.rootViewController = TabBarController()
        } else {
            displayOnboardingViewController()
        }
//        window?.rootViewController = defaults.bool(forKey: Identifiers.hasSeenOnboarding)
//            ? TabBarController()
//            : setupOnboardingViewController()

        #if DEBUG
            print("Running Uplift in debug configuration")
        #else
            print("Running Uplift in release configuration")
            Crashlytics.start(withAPIKey: Keys.fabricAPIKey.value)
        #endif

        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url as URL?)
    }

    // MARK: - Onboarding
    private func displayOnboardingViewController() {
        var gyms: [String] = []
        var classes: [GymClassInstance] = []

        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        dispatchGroup.enter()

        NetworkManager.shared.getGymNames(
            completion: {
                gyms = $0.map { $0.name }
                // Merge Teagle Up and Down to "Teagle"
                if gyms.contains("Teagle Up"), gyms.contains("Teagle Down") {
                    gyms = gyms.filter { $0 != "Teagle Up" || $0 != "Teagle Down" }
                    gyms.append("Teagle")
                }
                gyms.sort()
                dispatchGroup.leave()
            },
            failure: { dispatchGroup.leave() }
        )

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        // Display 4 classes from different (random) tag categories
        NetworkManager.shared.getGymClassesForDate(date: dateFormatter.string(from: Date()),
            completion: { classInstances in
                // Less than 4 classes -> Use Hard coded defaults
                if classInstances.count < 4 {
                    dispatchGroup.leave()
                    return
                }

                NetworkManager.shared.getTags(
                    completion: { tags in
                        // Sample 4 without replacement
                        var randomIndeces = Set<Int>()
                        while randomIndeces.count < 4 {
                            let index = Int.random(in: 0..<tags.count)
                            randomIndeces.insert(index)
                        }
                        // Tag categories not yet chosen to be displayed
                        var tagSubset = randomIndeces.map { tags[$0] }

                        // Iterate over unique classes that don't share the same name
                        for instance in classInstances {
                            if !classes.contains(where: { $0.className == instance.className }) {
                                // Add class only if it has a tag not yet displayed
                                for tag in tagSubset {
                                    if let index = tagSubset.index(of: tag) {
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

                        classes = classes.sorted(by: {$0.className < $1.className })
                        dispatchGroup.leave()
                    },
                    failure: { dispatchGroup.leave() }
                )
            },
            failure: { dispatchGroup.leave() }
        )

        dispatchGroup.notify(queue: .main, execute: {
            self.window?.rootViewController = gyms.count < 4 || classes.count < 4
                ? OnboardingViewController()
                : OnboardingViewController(gymNames: gyms, classes: classes)
        })

        // No Internet/Networking Failed; initialize with default
        self.window?.rootViewController = UIViewController()
    }
}
