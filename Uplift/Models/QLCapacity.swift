//
//  QLCapacity.swift
//  Uplift
//
//  Created by alden lamp on 9/4/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import Foundation

struct QLCapacity {

    var id: Int
    var facilityId: Int
    var count: Int
    var percent: Double
    var updated: String

    init (capacityData: AllGymsQuery.Data.Gym.Facility.Capacity) {
        id = Int(capacityData.id) ?? -1
        facilityId = capacityData.facilityId
        count = capacityData.count
        percent = capacityData.percent
        updated = capacityData.updated
    }

}
