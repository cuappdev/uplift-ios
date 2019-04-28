//
//  RoutineType.swift
//  Fitness
//
//  Created by Cameron Hamidi on 3/2/19.
//  Copyright © 2019 Keivan Shahida. All rights reserved.
//

import Foundation

struct ProRoutine {
    let title: String
    let routineType: ProRoutineType
    let text: String
    
    init(title: String, routineType: ProRoutineType, text: String) {
        self.title = title
        self.routineType = routineType
        self.text = text
    }
}

enum ProRoutineType {
    case mindfullness
    case cardio
    case strength
    case other
}
