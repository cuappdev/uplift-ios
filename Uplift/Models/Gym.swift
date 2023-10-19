//
//  Gym.swift
//  Uplift
//
//  Created by Cornell AppDev on 4/14/18.
//  Copyright © 2018 Uplift. All rights reserved.
//

import Foundation
import CoreLocation

struct Gym {

    // MARK: - Data variables
    var id: Int
    var name: String
    var description: String
    var location: String
    var coordinates: CLLocationCoordinate2D
    var imageURL: URL?
    var hours: OpenHours

    var facilities: [QLFacility]
    var fitnessCenters: [FitnessCenter]

    // MARK: - View Related State
    var hoursIsDisclosed: Bool = false

    init(gym: QLGym) {
        id = gym.id
        name = gym.name
        description = gym.description
        location = gym.location
        coordinates = gym.coordinates

        // Non Fitness center facilities
        facilities = gym.facilities.compactMap {
            return $0.type == .fitnessCenter ? nil : $0
        }

        fitnessCenters = gym.facilities.compactMap {
            guard $0.type == .fitnessCenter else { return nil }
            return FitnessCenter(gymID: gym.id, imgUrl: gym.imageURL, fitnessCenter: $0)
        }

        imageURL = gym.imageURL

        // TODO: - Fix Hours once backend is updated
        if let hrs = fitnessCenters.last?.hours {
            hours = hrs
        } else {
            hours = OpenHours(openHours: [])
        }
    }

    func getFitnessCenters() -> [FitnessCenter] {
        return fitnessCenters
    }

    // TODO: - Fix
    func isOpen() -> Bool {
        return hours.isOpen()
    }

}
