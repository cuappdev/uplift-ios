//
//  Gym.swift
//  Uplift
//
//  Created by Cornell AppDev on 4/14/18.
//  Copyright © 2018 Uplift. All rights reserved.
//

import Foundation

struct Gym {

    let id: String
    let equipment: String
    let gymHours: [DailyGymHours]
    let name: String
    let facilities: [Facility]

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

    init(gymData: AllGymsQuery.Data.Gym ) {
        id = gymData.id
        name = gymData.name
        // TODO : fetch equipment once it's available from backend
        equipment = ""
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
        var gymHoursList: [DailyGymHours] = []

        let allGymHours = gymData.times
        for i in 0..<allGymHours.count {
            gymHoursList.append(DailyGymHours(gymHoursData: allGymHours[i]))
        }

        gymHours = gymHoursList

        var facilitiesList: [Facility] = []
        let facilitiesData = gymData.facilities
        facilitiesData.forEach({ (facility) in
            if let facility = facility {
                facilitiesList.append(Facility(gymData: facility))
            }
        })
        facilities = facilitiesList
    }

    init(gymData: GymByIdQuery.Data.Gym ) {
        id = gymData.id
        name = gymData.name
        // TODO : fetch equipment once it's available from backend
        equipment = ""
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
        gymHours = gymData.times.compactMap({ (gymHoursDataId) -> DailyGymHours? in
            guard let gymHoursDataId = gymHoursDataId else { return nil}
            return DailyGymHours(gymHoursDataId: gymHoursDataId)
        })

        facilities = []
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
    var dayOfWeek: Int
    var openTime: Date
    var closeTime: Date

    init(gymHoursData: AllGymsQuery.Data.Gym.Time?) {
        if let gymHoursData = gymHoursData {
            dayOfWeek = gymHoursData.day
            openTime = Date.getTimeFromString(datetime: gymHoursData.startTime)
            closeTime = Date.getTimeFromString(datetime: gymHoursData.endTime)
        } else {
            openTime = Date()
            closeTime = openTime
            dayOfWeek = 0
        }
    }

    init(gymHoursDataId: GymByIdQuery.Data.Gym.Time?) {
        if let gymHoursData = gymHoursDataId {
            dayOfWeek = gymHoursData.day
            openTime = Date.getTimeFromString(datetime: gymHoursData.startTime)
            closeTime = Date.getTimeFromString(datetime: gymHoursData.endTime)
        } else {
            openTime = Date()
            closeTime = openTime
            dayOfWeek = 0
        }
    }

    init(gymHoursDataId: AllGymsQuery.Data.Gym.Facility.Time?) {
        if let gymHoursData = gymHoursDataId {
            dayOfWeek = gymHoursData.day
            openTime = Date.getTimeFromString(datetime: gymHoursData.startTime)
            closeTime = Date.getTimeFromString(datetime: gymHoursData.endTime)
        } else {
            openTime = Date()
            closeTime = openTime
            dayOfWeek = 0
        }
    }
}

struct Facility {
    var equipment: [Equipment]
    var miscInformation: [String]
    var name: String
    var times: [DailyGymHours]

    init(gymData: AllGymsQuery.Data.Gym.Facility) {
        if let equipmentGymData = gymData.equipment {
            equipment = equipmentGymData.compactMap({ (equipmentData) -> Equipment? in
                guard let equipmentData = equipmentData else { return nil }
                return Equipment(equipmentData: equipmentData)
            })
        } else {
            equipment = []
        }

        var miscInformationList: [String] = []
        if let informationData = gymData.miscInformation {
            informationData.forEach({ (info) in
                if let info = info {
                    miscInformationList.append(info)
                }
            })
        }
        miscInformation = miscInformationList

        name = gymData.name

        times = gymData.times.compactMap({ (gymHoursDataId) -> DailyGymHours? in
            guard let gymHoursDataId = gymHoursDataId else { return nil }
            return DailyGymHours(gymHoursDataId: gymHoursDataId)
        })
    }
}

struct Equipment {
    var equipmentType: String
    var name: String
    var quantity: String
    var workoutType: String

    init(equipmentData: AllGymsQuery.Data.Gym.Facility.Equipment?) {
        if let equipmentData = equipmentData {
            equipmentType = equipmentData.equipmentType ?? ""
            name = equipmentData.name
            quantity = equipmentData.quantity ?? "0"
            workoutType = equipmentData.workoutType ?? ""
        } else {
            equipmentType = ""
            name = ""
            quantity = ""
            workoutType = ""
        }
    }
}
