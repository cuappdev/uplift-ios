//
//  GymClassInstance.swift
//  Fitness
//
//  Created by Keivan Shahida on 4/22/18.
//  Copyright © 2018 Keivan Shahida. All rights reserved.
//
import Foundation

struct GymClassInstance {
    // let gymClassInstanceId: Int
    let classDescription: AllClassesInstancesQuery.Data.Class.Detail?
    let instructor: String
    let startTime: String
    let gymId: String
    let duration: String
    let location: String
    let imageURL: String
    let isCancelled: Bool
    
    init?(gymClassData: AllClassesInstancesQuery.Data.Class) {
        guard let classDescription = gymClassData.details, let instructor = gymClassData.instructor, let gymId = gymClassData.gymId,
            let location = gymClassData.gym?.name, let endTime = gymClassData.endTime, let isCancelled = gymClassData.isCancelled,
            let startTime = gymClassData.startTime else { return nil }
        self.classDescription = classDescription
        self.instructor = instructor
        self.startTime = startTime
        self.gymId = gymId
        self.location = location
        self.isCancelled = isCancelled
        
        if let className  = classDescription.name {
            imageURL = "https://raw.githubusercontent.com/cuappdev/assets/master/fitness/gyms/\(String(describing: className.replacingOccurrences(of: " ", with: "_"))).jpg"
        } else {
            imageURL = ""
        }
        
        let start = Date.getDatetimeFromString(datetime: startTime)
        let end = Date.getDatetimeFromString(datetime: endTime)
        duration = String(end.timeIntervalSince(start))
    }
}
