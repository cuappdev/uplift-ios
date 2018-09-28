//
//  Gym.swift
//  Fitness
//
//  Created by Keivan Shahida on 4/14/18.
//  Copyright © 2018 Keivan Shahida. All rights reserved.
//

import Foundation

struct Gym {
    let id: Int
    let name: String
    let equipment: String
    let gymHours: [DailyGymHours]
    
    /// Arry of 7 arrays of count 24, representing the busyness in each hour, Sun..Sat
    let popularTimesList: [[Int]]
    let imageURL: String
    var isOpen: Bool {
        if Date() > gymHoursToday.openTime {
            return Date() < gymHoursToday.closeTime
        } else {
            return false
        }
    }
    
    var gymHoursToday: DailyGymHours {
        return gymHours[Date().getIntegerDayOfWeekToday()]
    }
    
    init(gymData: AllGymsQuery.Data.Gym ) {
        id = Int(gymData.id ?? "-1")!
        name = gymData.name ?? ""
        equipment = "" // TODO : fetch equipment once it's availble from backend
        imageURL = "https://raw.githubusercontent.com/cuappdev/assets/master/fitness/gyms/\(name).jpg" // TODO : replace spaces with underscores
        
        var popularTimes = Array.init(repeating: Array.init(repeating: 0, count: 24), count: 7)
        // unwrap the popular times, 0 busyness if null
        if let popular = gymData.popular {
            for i in 0...popular.count {
                if let dailyPopular = popular[i] {
                    for j in 0...dailyPopular.count {
                        popularTimes[i][j] = dailyPopular[j] ?? 0
                    }
                }
            }
        }
        popularTimesList = popularTimes
        
        // unwrap gym hours
        var gymHoursList: [DailyGymHours] = []
        
        if let allGymHours = gymData.times {
            for dailyGymHours in allGymHours {
                gymHoursList.append(DailyGymHours(gymHoursData: dailyGymHours))
            }
        }
        
        gymHours = gymHoursList
    }
}

struct DailyGymHours{
    var dayOfWeek: Int
    var openTime: Date
    var closeTime: Date
    
    init(gymHoursData: AllGymsQuery.Data.Gym.Time?) {
        if let gymHoursData = gymHoursData {
            openTime = Date.getDatetimeFromString(datetime: gymHoursData.startTime)
            closeTime = Date.getDatetimeFromString(datetime: gymHoursData.endTime)
            dayOfWeek = gymHoursData.day ?? 0
        } else {
            openTime = Date()
            closeTime = openTime
            dayOfWeek = 0
        }
    }
}
