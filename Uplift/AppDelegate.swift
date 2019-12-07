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
        if defaults.bool(forKey: Identifiers.hasSeenOnboarding) {
            window?.rootViewController = TabBarController()
        } else {
            displayOnboardingViewController()
        }

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
            completion: { gymInstances in
                var gymNames = Set<String>()
                gymInstances.forEach { instance in
                    if let name = instance.name {
                        if name == "Teagle Up" || name == "Teagle Down" {
                            gymNames.insert("Teagle")
                        } else {
                            gymNames.insert(name)
                        }
                    }
                }
                gyms = Array(gymNames).sorted()

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
                        // Sample 4 tags without replacement
                        var randomIndices = Set<Int>()
                        while randomIndices.count < 4 {
                            let index = Int.random(in: 0..<tags.count)
                            randomIndices.insert(index)
                        }
                        // Tag categories to chose from
                        // Each time it picks a class, remove a tag from list
                        var tagSubset = randomIndices.map { tags[$0] }
                        // Iterate over unique classes that don't share the same name, Adding classes if it has a tag not yet displayed
                        for instance in classInstances {
                            if !classes.contains(where: { $0.className == instance.className }) {
                                for tag in instance.tags {
                                    if let index = tagSubset.index(of: tag) {
                                        tagSubset.remove(at: index)
                                        classes.append(instance)
                                        break
                                    }
                                }
                                // Chose 4 classes, can stop
                                if classes.count >= 4 { break }
                            }
                        }

                        classes = classes.sorted(by: { $0.className < $1.className })
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

        // No Internet/Networking Failed/Networking in progress; initialize with blank VC
        let loadingVC = UIViewController()
        loadingVC.view.backgroundColor = .primaryWhite
        let logo = UIImageView(image: UIImage(named: ImageNames.appIcon))
        loadingVC.view.addSubview(logo)
        logo.snp.makeConstraints { $0.center.equalToSuperview() }
        self.window?.rootViewController = loadingVC
    }
}
