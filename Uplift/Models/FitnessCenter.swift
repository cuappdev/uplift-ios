//
//  FitnessCenter.swift
//  Uplift
//
//  Created by alden lamp on 9/2/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import Foundation

struct FitnessCenter {
    var id: Int
    var gymId: Int
    var name: String
    var imageUrl: URL?
    
    var capacityCount: Int?
    var capacityPercent: Double?
    
    var hours: OpenHours

    func isOpen() -> Bool {
        return hours.isOpen()
    }

    func isStatusChangingSoon() -> Bool {
        return hours.isStatusChangingSoon()
    }

    
    init (gymID: Int, imgUrl: URL?, fitnessCenter: QLFacility) {
        gymId = gymID
        imageUrl = imgUrl
        id = fitnessCenter.id
        name = fitnessCenter.name
        capacityCount = fitnessCenter.capacity?.count
        capacityPercent = fitnessCenter.capacity?.percent
        hours = OpenHours(openHours: fitnessCenter.hours)
    }
    
    func getHoursString() -> String {
        return hours.getHoursString()
    }
    
}


//
//struct OpenHours {
//    var day: Int
//    var openTime: Double
//    var closeTime: Double
//}
//

//var dayOfWeek: Int = 0
//var openTime: Date = Date()
//var closeTime: Date

/*
 init(gymHoursData: AllGymsQuery.Data.Gym.Time?) {
 if let gymHoursData = gymHoursData {
 dayOfWeek = gymHoursData.day
 openTime = Date.getTimeFromString(datetime: gymHoursData.startTime)
 closeTime = Date.getTimeFromString(datetime: gymHoursData.endTime)
 } else {
 closeTime = openTime
 }
 }
 */
