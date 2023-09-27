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
//    private let constFitnessCenters = [
//        FitnessCenter(id: "0", gymId: "0", name: "Test1", imageUrl: URL(string: "https://raw.githubusercontent.com/cuappdev/assets/master/uplift/gyms/helen-newman.jpg")),
//        FitnessCenter(id: "0", gymId: "0", name: "Test2", imageUrl: URL(string: "https://raw.githubusercontent.com/cuappdev/assets/master/uplift/gyms/helen-newman.jpg")),
//        FitnessCenter(id: "0", gymId: "0", name: "Test3")
//    ]
    
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
