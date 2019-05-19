//
//  RoutineType.swift
//  Fitness
//
//  Created by Cameron Hamidi on 3/2/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import Foundation

struct ProRoutine {

    let routineType: HabitTrackingType
    let text: String
    let title: String

    init(title: String, routineType: HabitTrackingType, text: String) {
        self.title = title
        self.routineType = routineType
        self.text = text
    }
}
