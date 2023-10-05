//
//  QLOpenHours.swift
//  Uplift
//
//  Created by alden lamp on 9/2/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import Foundation


struct QLOpenHours {
    var id: Int
    var facilityId: Int
    var day: Int
    var startTime: Date
    var endTime: Date
    
    init (openHoursData: AllGymsQuery.Data.Gym.Facility.OpenHour) {
        id = Int(openHoursData.id) ?? -1
        facilityId = openHoursData.facilityId
        day = openHoursData.day
        startTime = Date.getDateFromHours(day: day, hours: openHoursData.startTime)
        endTime = Date.getDateFromHours(day: day, hours: openHoursData.endTime)
    }
    
    // Testing Init
    init(dayNum: Int, start: Double, end: Double) {
        id = -1
        facilityId = -1
        day = dayNum
        startTime = Date.getDateFromHours(day: dayNum, hours: start)
        endTime = Date.getDateFromHours(day: dayNum, hours: end)
    }
    
    func dayMatchesDate(_ date: Date = Date()) -> Bool {
        self.day == date.getIntegerDayOfWeekToday()
    }
    
    func isDateInRange(_ date: Date = Date()) -> Bool {
        guard dayMatchesDate(date) else { return false }
        return startTime < date && endTime > date
    }
    
    func willChangeSoon(_ date: Date = Date()) -> Bool {
        let changingSoonThreshold = 3600.0
        if isDateInRange(date) {
            return endTime - changingSoonThreshold < date
        } else {
            return startTime > date && startTime - changingSoonThreshold < date
        }
    }
}
