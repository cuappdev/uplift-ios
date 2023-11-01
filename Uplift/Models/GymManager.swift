//
//  DataManager.swift
//  Uplift
//
//  Created by alden lamp on 9/2/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import Foundation

class GymManager {

    static var shared = GymManager()

    private var fitnessCenters: [FitnessCenter] = []
    private var gyms: [Int: Gym] = [:]

    var numFitnessCenters: Int {
        return fitnessCenters.count
    }

    func getFitnessCenter () -> [FitnessCenter] {
        return fitnessCenters
    }

    func getGymWith(id: Int) -> Gym? {
        gyms[id]
    }

    func fetch () {
        NetworkManager.shared.getAllGyms { success in
            if let gyms = success {
                var fitnessCenters: [FitnessCenter] = []
                for gym in gyms {
                    let gymObj = Gym(gym: gym)
                    self.gyms[gym.id] = gymObj
                    fitnessCenters.append(contentsOf: gymObj.getFitnessCenters())
                }
                self.fitnessCenters = fitnessCenters
                NotificationCenter.default.post(name: Notification.Name.upliftFitnessCentersLoadedNotification, object: nil)
            }
            // TODO: - Handle failed networking call
        }
    }

}
