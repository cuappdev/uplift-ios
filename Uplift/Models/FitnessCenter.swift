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

//    var capacityCount: Int?
//    var capacityPercent: Double?
    var capacity: Capacity?

    var hours: OpenHours

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

//    func getCapacityStatus() -> CapacityStatus? {
//        guard let percent = self.capacityPercent else { return nil }
//        return CapacityStatus(percent: percent)
//    }
//
//    func getCapacityPercent() -> String? {
//        guard let percent = self.capacityPercent else { return nil }
//        return String.getFromPercent(value: percent)
//    }

}
