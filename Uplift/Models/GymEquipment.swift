//
//  GymEquipment.swift
//  Uplift
//
//  Created by Yana Sang on 10/9/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import Foundation

struct GymEquipment {
    let gymId: String
    let equipment: [EquipmentCategory]
}

struct EquipmentCategory {
    let categoryName: String
    let equipment: [Equipment]
}

struct Equipment {
    let name: String
    let count: Int
}
