//
//  GymClassInstance.swift
//  Fitness
//
//  Created by Keivan Shahida on 4/22/18.
//  Copyright © 2018 Keivan Shahida. All rights reserved.
//
import Foundation

struct GymClassInstance {
    let gymClassInstanceId: Int
    let classDescription: AllClassesInstancesQuery.Data.Class.Detail
    let instructor: String
    let startTime: String
    let gymId: String
    let endTime: String
    
    init?(classData: AllClassesInstancesQuery.Data.Class) {
        guard let description = classData.details, let instructor = classData.instructor, let startTime = classData.startTime,
        let gymId = classData.gymId, let endTime = classData.endTime else { return nil }
        self.classDescription = description
        self.instructor = instructor
        self.startTime = startTime
        self.gymId = gymId
        self.endTime = endTime
    }

}
