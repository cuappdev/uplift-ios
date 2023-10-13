//
//  DataManager.swift
//  Uplift
//
//  Created by alden lamp on 9/2/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import Foundation

class FitnessCenterManager {
    static var shared = FitnessCenterManager()

    private var fitnessCenters: [FitnessCenter] = []

    var numFitnessCenters: Int {
        return fitnessCenters.count
    }

    func getFitnessCenter () -> [FitnessCenter] {
        return fitnessCenters
    }

    func fetch () {
        NetworkManager.shared.getFitnessCenters { success in
            if let gyms = success {
                var fitnessCenters: [FitnessCenter] = []
                for gym in gyms {
                    fitnessCenters.append(contentsOf: gym.getFitnessCenters())
                }
                self.fitnessCenters = fitnessCenters
                NotificationCenter.default.post(name: Notification.Name.upliftFitnessCentersLoadedNotification, object: nil)
            }
            // TODO: - Handle failed networking call
        }
    }

}
