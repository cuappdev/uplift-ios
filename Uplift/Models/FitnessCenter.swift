//
//  FitnessCenter.swift
//  Uplift
//
//  Created by alden lamp on 9/2/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import Foundation

class FitnessCenter {

    var id: Int
    var gymId: Int
    var name: String
    var imageUrl: URL?

    var capacity: Capacity?
    var hours: OpenHours
    var isHoursDisclosed: Bool = false

    init (gymID: Int, imgUrl: URL?, fitnessCenter: QLFacility) {
        gymId = gymID
        imageUrl = imgUrl
        id = fitnessCenter.id
        name = fitnessCenter.name
        hours = OpenHours(openHours: fitnessCenter.hours)
        if let capacityData = fitnessCenter.capacity {
            capacity = Capacity(capacityData: capacityData)
        }
    }

    func isOpen() -> Bool {
        return hours.isOpen()
    }

    func isStatusChangingSoon() -> Bool {
        return hours.isStatusChangingSoon()
    }

    func getHoursString() -> String {
        return hours.getHoursString()
    }

}
