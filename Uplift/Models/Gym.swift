//
//  Gym.swift
//  Uplift
//
//  Created by Cornell AppDev on 4/14/18.
//  Copyright © 2018 Uplift. All rights reserved.
//

import Foundation

struct Gym {

    let facilities: [Facility]
    let gymHours: [DailyGymHours]
    let id: String
    let name: String

    /// Array of 7 arrays of count 24, representing the busyness in each hour, Sun..Sat
    let popularTimesList: [[Int]]
    let imageURL: URL?
    var isOpen: Bool {
        return Date() > gymHoursToday.openTime ? Date() < gymHoursToday.closeTime : false
    }

    var closedTomorrow: Bool {
        let now = Date()
        let gymHoursTomorrow = gymHours[now.getIntegerDayOfWeekTomorrow()]
        return gymHoursTomorrow.openTime == gymHoursTomorrow.closeTime
    }

    var gymHoursToday: DailyGymHours {
        return gymHours[Date().getIntegerDayOfWeekToday()]
    }
    
    init(facilities: [Facility], gymHours: [DailyGymHours], id: String, name: String, popularTimesList: [[Int]], imageURL: URL?) {
        self.facilities = facilities
        self.gymHours = gymHours
        self.id = id
        self.name = name
        self.popularTimesList = popularTimesList
        self.imageURL = imageURL
    }
    
    
/*
    init(gymData: AllGymsQuery.Data.Gym) {
        id = gymData.id
        name = gymData.name
        imageURL = URL(string: gymData.imageUrl ?? "")

        var popularTimes = Array.init(repeating: Array.init(repeating: 0, count: 24), count: 7)

        if let popular = gymData.popular {
            popular.enumerated().forEach { (i, dailyPopular) in
                dailyPopular?.enumerated().forEach({ (j, dailyPopularItem) in
                    popularTimes[i][j] = dailyPopularItem ?? 0
                })
            }
        }
        popularTimesList = popularTimes

        let allGymHours = gymData.times
        let gymHoursList = allGymHours.map({ DailyGymHours(gymHoursData: $0) })
        gymHours = gymHoursList

        facilities = gymData.facilities.compactMap {
            guard let facility = $0,
                let facilityType = FacilityType(rawValue: facility.name) else { return nil }
            return Facility(facilityData: facility, facilityType: facilityType)
        }
    }

    init(gymData: GymByIdQuery.Data.Gym ) {
        id = gymData.id
        name = gymData.name
        imageURL = URL(string: gymData.imageUrl ?? "")

        var popularTimes = Array.init(repeating: Array.init(repeating: 0, count: 24), count: 7)
        if let popular = gymData.popular {
            popular.enumerated().forEach { (i, dailyPopular) in
                dailyPopular?.enumerated().forEach({ (j, dailyPopularItem) in
                    popularTimes[i][j] = dailyPopularItem ?? 0
                })
            }
        }
        popularTimesList = popularTimes

        // unwrap gym hours
        let gymHoursList = gymData.times.compactMap({ (gymHoursDataId) -> DailyGymHours? in
            guard let gymHoursDataId = gymHoursDataId else { return nil}
            return DailyGymHours(gymHoursDataId: gymHoursDataId)
        })
        gymHours = gymHoursList

        facilities = gymData.facilities.compactMap {
            guard let facility = $0,
                let facilityType = FacilityType(rawValue: facility.name) else { return nil }
            return Facility(facilityData: facility, facilityType: facilityType)
        }
    }
*/
    func isStatusChangingSoon() -> Bool {
        let changingSoonThreshold = 3600.0
        let now = Date()

        if isOpen {
            return (gymHoursToday.closeTime - changingSoonThreshold) < now
        } else {
            let openTime = gymHours[now.getIntegerDayOfWeekTomorrow()].openTime + Date.secondsPerDay
            return (openTime - changingSoonThreshold) < now
        }
    }

}

struct DailyGymHours {
    var dayOfWeek: Int = 0
    var openTime: Date = Date()
    var closeTime: Date
    
    init(dayOfWeek: Int, openTime: Date, closeTime: Date) {
        self.dayOfWeek = dayOfWeek
        self.openTime = openTime
        self.closeTime = closeTime
    }

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

    init(gymHoursDataId: GymByIdQuery.Data.Gym.Time?) {
        if let gymHoursData = gymHoursDataId {
            dayOfWeek = gymHoursData.day
            openTime = Date.getTimeFromString(datetime: gymHoursData.startTime)
            closeTime = Date.getTimeFromString(datetime: gymHoursData.endTime)
        } else {
            closeTime = openTime
        }
    }
*/
}

let weekHours = [
    DailyGymHours(dayOfWeek: 0, openTime: Date(), closeTime: Date()),
    DailyGymHours(dayOfWeek: 1, openTime: Date(), closeTime: Date()),
    DailyGymHours(dayOfWeek: 2, openTime: Date(), closeTime: Date()),
    DailyGymHours(dayOfWeek: 3, openTime: Date(), closeTime: Date()),
    DailyGymHours(dayOfWeek: 4, openTime: Date(), closeTime: Date()),
    DailyGymHours(dayOfWeek: 5, openTime: Date(), closeTime: Date()),
    DailyGymHours(dayOfWeek: 6, openTime: Date(), closeTime: Date())
]

let teagle = Gym(facilities: [], gymHours: weekHours, id: "1", name: "teagle", popularTimesList: [[]], imageURL: URL(string: "https://scl.cornell.edu/recreation/recreation/recreation/recreation/recreation/recreation/recreation/recreation/recreation/recreation/sites/scl.cornell.edu.recreation/files/2023-05/teagle.jpg"))

let noyes = Gym(facilities: [], gymHours: weekHours, id: "2", name: "noyes", popularTimesList: [[]], imageURL: URL(string: "https://scl.cornell.edu/recreation/sites/scl.cornell.edu.recreation/files/2023-05/Noyes%20Exterior.jpg"))

let helen = Gym(facilities: [], gymHours: weekHours, id: "3", name: "helen", popularTimesList: [[]], imageURL: URL(string: "https://scl.cornell.edu/recreation/sites/scl.cornell.edu.recreation/files/2023-05/out%20parking%20lot%20HNH%203.2_0.jpg"))


