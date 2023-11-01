//
//  Capacity.swift
//  Uplift
//
//  Created by alden lamp on 10/22/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import Foundation
import UIKit

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

    var color: UIColor {
        switch self {
        case .Full:     return .accentRed
        case .Cramped:   return .accentOrange
        case .Light:     return .accentGreen
        }
    }

}

class Capacity {

    var id: Int
    var facilityID: Int
    var count: Int
    var percent: Double
    var updated: Date
    var status: CapacityStatus {
        return CapacityStatus(percent: percent)
    }

    init(capacityData: QLCapacity) {
        id = capacityData.id
        facilityID = capacityData.facilityId
        count = capacityData.count
        percent = capacityData.percent
        updated = Date.getDatetimeFromString(datetime: capacityData.updated)
    }

    func getCapacityPercentString() -> String {
        return String.getFromPercent(value: percent)
    }

}
