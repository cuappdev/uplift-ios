//
//  OpenHours.swift
//  Uplift
//
//  Created by alden lamp on 9/19/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import Foundation

struct OpenHours {
    
    var rawHours: [Int: [QLOpenHours]]
    
    var todaysHours: [QLOpenHours]? {
        rawHours[Date().getIntegerDayOfWeekToday()]
    }
    
    var tomorrowsHours: [QLOpenHours]? {
        rawHours[Date().getIntegerDayOfWeekTomorrow()]
    }
    
    init(openHours: [QLOpenHours]) {
        rawHours = [:]
        for openHour in openHours {
            if rawHours.keys.contains(openHour.day) {
                rawHours[openHour.day]?.append(openHour)
            } else {
                rawHours[openHour.day] = [openHour]
            }
        }
    }
    
    
    func isStatusChangingSoon() -> Bool {
        return todaysHours?.first{ $0.willChangeSoon() } != nil
    }
    
    func isOpen() -> Bool {
        guard todaysHours != nil else {return false}
        return todaysHours?.filter{ $0.isDateInRange() }.count != 0
    }
    
    func getHoursString() -> String {
        let strFormat: String
        let now = Date()
        
        // Gym is open
        if isOpen(), let nowHourRange = todaysHours?.filter({  $0.isDateInRange() }).first {
            strFormat = nowHourRange.endTime.getHourFormat()
            let closeTime = nowHourRange.endTime.getStringOfDatetime(format: strFormat)
            return ClientStrings.Home.gymDetailCellClosesAt + closeTime

        // Gym will open today
        } else {
            if let nextOpenToday = todaysHours?.filter({ $0.startTime < now }).sorted(by: { $0.startTime < $1.startTime }).first {
                
                strFormat = nextOpenToday.startTime.getHourFormat()
                return ClientStrings.Home.gymDetailCellOpensAt + (nextOpenToday.startTime.getStringOfDatetime(format: strFormat))
                
            } else if let nextOpenTomorrow = tomorrowsHours?.sorted(by: { $0.startTime < $1.startTime }).first  {
                
                strFormat = nextOpenTomorrow.startTime.getHourFormat()
                return ClientStrings.Home.gymDetailCellOpensAt + nextOpenTomorrow.startTime.getStringOfDatetime(format: strFormat)
            } else {
                return ClientStrings.CommonStrings.closed
            }
            
        }
        
        return ""
    }
    
}
