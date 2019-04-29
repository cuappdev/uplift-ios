//
//  RoutineType.swift
//  Fitness
//
//  Created by Cameron Hamidi on 3/2/19.
//  Copyright © 2019 Keivan Shahida. All rights reserved.
//

import Foundation

struct ProRoutine {
    enum ProRoutineType {
        case cardio
        case mindfullness
        case other
        case strength
    }
    
    let routineType: ProRoutineType
    let text: String
    let title: String
    
    init(title: String, routineType: ProRoutineType, text: String) {
        self.title = title
        self.routineType = routineType
        self.text = text
    }
}
