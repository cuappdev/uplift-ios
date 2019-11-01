//
//  Gym.swift
//  Uplift
//
//  Created by Cornell AppDev on 4/14/18.
//  Copyright © 2018 Uplift. All rights reserved.
//

import Foundation

struct Gym {

    let equipment: String
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

        facilities = gymData.facilities.compactMap({ facility in
          if let facility = facility {
            return Facility(facilityData: facility)
          }
          return nil
        })
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

        facilities = gymData.facilities.compactMap {
            guard let facility = $0 else { return nil }
            return Facility(facilityData: facility)
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

    init(facilityHoursData: AllGymsQuery.Data.Gym.Facility.Time?) {
        if let facilityHours = facilityHoursData {
            dayOfWeek = facilityHours.day
            openTime = Date.getTimeFromString(datetime: facilityHours.startTime)
            closeTime = Date.getTimeFromString(datetime: facilityHours.endTime)
        } else {
            openTime = Date()
            closeTime = openTime
            dayOfWeek = 0
        }
    }

    init(facilityHoursData: GymByIdQuery.Data.Gym.Facility.Time?) {
        if let facilityHours = facilityHoursData {
            dayOfWeek = facilityHours.day
            openTime = Date.getTimeFromString(datetime: facilityHours.startTime)
            closeTime = Date.getTimeFromString(datetime: facilityHours.endTime)
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

    init(facilityData: AllGymsQuery.Data.Gym.Facility) {
        if let equipmentGymData = facilityData.equipment {
            equipment = equipmentGymData.compactMap({ equipmentData -> Equipment? in
                guard let equipmentData = equipmentData else { return nil }
                return Equipment(equipmentData: equipmentData)
            })
        } else {
            equipment = []
        }

        if let informationData = facilityData.miscInformation {
            miscInformation = informationData.compactMap({ information in
              if let information = information {
                return information
              }
              return nil
            })
        } else {
            miscInformation = []
        }

        name = facilityData.name

        times = facilityData.times.compactMap({ (facilityHoursData) -> DailyGymHours? in
            guard let facilityHours = facilityHoursData else { return nil }
            return DailyGymHours(facilityHoursData: facilityHours)
        })
    }

    init(facilityData: GymByIdQuery.Data.Gym.Facility) {
        if let equipmentGymData = facilityData.equipment {
           equipment = equipmentGymData.compactMap({ equipmentData -> Equipment? in
               guard let data = equipmentData else { return nil }
               return Equipment(equipmentData: data)
           })
       } else {
           equipment = []
       }

       if let informationData = facilityData.miscInformation {
            miscInformation = informationData.compactMap({
                guard let information = $0 else { return nil }
                return information
            })
       } else {
           miscInformation = []
       }

       name = facilityData.name

       times = facilityData.times.compactMap({ (facilityHoursData) -> DailyGymHours? in
            guard let facilityHours = facilityHoursData else { return nil }
            return DailyGymHours(facilityHoursData: facilityHours)
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

    init(equipmentData: GymByIdQuery.Data.Gym.Facility.Equipment?) {
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
