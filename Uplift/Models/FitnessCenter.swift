//
//  FitnessCenter.swift
//  Uplift
//
//  Created by alden lamp on 9/2/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import Foundation

enum CapacityStatus: String {
    case Full
    case Cramped
    case Light

    init (percent: Double) {
        if percent <= 0.50 {
            self = .Light
        } else if percent > 0.80 {
            self = .Full
        } else {
            self = .Cramped
        }
    }
}

struct FitnessCenter {

    var id: Int
    var gymId: Int
    var name: String
    var imageUrl: URL?

    var capacityCount: Int?
    var capacityPercent: Double?

    var hours: OpenHours

    init (gymID: Int, imgUrl: URL?, fitnessCenter: QLFacility) {
        gymId = gymID
        imageUrl = imgUrl
        id = fitnessCenter.id
        name = fitnessCenter.name
        capacityCount = fitnessCenter.capacity?.count
        capacityPercent = fitnessCenter.capacity?.percent
        hours = OpenHours(openHours: fitnessCenter.hours)
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

    func getCapacityStatus() -> CapacityStatus? {
        guard let percent = self.capacityPercent else { return nil }
        return CapacityStatus(percent: percent)
    }

    func getCapacityPercent() -> String? {
        guard let percent = self.capacityPercent else { return nil }
        return String.getFromPercent(value: percent)
    }

}
