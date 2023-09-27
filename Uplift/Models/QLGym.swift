//
//  QLGym.swift
//  Uplift
//
//  Created by alden lamp on 9/2/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import Foundation
import CoreLocation

struct QLGym {
    
    var id: Int
    var name: String
    var description: String
    var location: String
    var coordinates: CLLocationCoordinate2D
    var facilities: [QLFacility]
    var imageURL: URL?
    
    init(gymData: AllGymsQuery.Data.Gym) {
        id = Int(gymData.id) ?? -1
        name = gymData.name
        description = gymData.description
        location = gymData.location
        coordinates = CLLocationCoordinate2D(latitude: gymData.latitude, longitude: gymData.longitude)
        
        let facilitiesData = gymData.facilities ?? []
        facilities = facilitiesData.compactMap({
            guard let facilityData = $0 else { return nil }
            return QLFacility(facilityData: facilityData)
        })
        
        if let imgStr = gymData.imageUrl {
            imageURL = URL(string: imgStr)
        }
    }
    
    func getFitnessCenters() -> [FitnessCenter] {
        return facilities.compactMap {
            guard $0.type == .fitnessCenter else { return nil }
            return FitnessCenter(gymID: id, imgUrl: imageURL, fitnessCenter: $0)
        }
    }
}
    /*
     
        init(gymData: AllGymsQuery.Data.Gym) {
            id = gymData.id
            name = gymData.name
            imageURL = URL(string: gymData.imageUrl ?? "")

            var popularTimes = Array.init(repeating: Array.init(repeating: 0, count: 24), count: 7)

            if let popular = gymData.popular {
                popular.enumerated().forEach { (i, dailyPopular) in
                    dailyPopular?.enumerated().forEach({ (j, dailyPopularItem) in
                        popularTimes[i][j] = dailyPopularItem ?? 0
                    })
                }
            }
            popularTimesList = popularTimes

            let allGymHours = gymData.times
            let gymHoursList = allGymHours.map({ DailyGymHours(gymHoursData: $0) })
            gymHours = gymHoursList

            facilities = gymData.facilities.compactMap {
                guard let facility = $0,
                    let facilityType = FacilityType(rawValue: facility.name) else { return nil }
                return Facility(facilityData: facility, facilityType: facilityType)
            }
        }
}
*/
