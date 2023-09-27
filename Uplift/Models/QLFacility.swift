//
//  QLFacility.swift
//  Uplift
//
//  Created by alden lamp on 9/2/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import Foundation

enum QLFacilityType: String {
    case undefined
    case fitnessCenter = "FITNESS"
}

struct QLFacility {
    var id: Int
    var gymId: Int
    var name: String
    var type: QLFacilityType
    var hours: [QLOpenHours]
    var capacity: QLCapacity?
    
    init (facilityData: AllGymsQuery.Data.Gym.Facility) {
        id = Int(facilityData.id) ?? -1
        gymId = facilityData.gymId
        name = facilityData.name
        type = QLFacilityType(rawValue: facilityData.facilityType) ?? .undefined
        
        let openHoursData = facilityData.openHours ?? []
        hours = openHoursData.compactMap({
            guard let hoursData = $0 else { return nil }
            return QLOpenHours(openHoursData: hoursData)
        })
        
        if let capacityData = facilityData.capacity {
            capacity = QLCapacity(capacityData: capacityData)
        }
    }
    
}
