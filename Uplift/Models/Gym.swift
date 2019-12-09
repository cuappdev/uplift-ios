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

        // Unwrap gym hours
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

}
