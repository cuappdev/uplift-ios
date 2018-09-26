//
//  Gym.swift
//  Fitness
//
//  Created by Keivan Shahida on 4/14/18.
//  Copyright © 2018 Keivan Shahida. All rights reserved.
//

import Foundation

struct Gym {
    let classInstances: [Int]
    let equipment: String
    let gymHours: GymHours
    let id: Int
    let name: String
    let location: Int
    let isGym: Bool
    let popularTimesList: PopularTimes
    let imageURL: String
    var isOpen: Bool {
        let gymHoursToday = gymHours.getGymHours(isTomorrow: false)
        
        if Date() > Date.getDateFromTime(time: gymHoursToday.openTime) {
            return Date() < Date.getDateFromTime(time: gymHoursToday.closeTime)
        } else {
            return false
        }
    }
    
    init(gymData: AllGymsQuery.Data.Gym ) {
        id = Int(gymData.id ?? "-1")!
        name = gymData.name ?? ""
        // TODOS : image saved on our side?
        // remove: location, isGym, equipment?, classInstances
        // is popularTimes just always [sun..sat]
    }
}

struct GymHours: Codable {
    var zero: DailyGymHours?
    var one: DailyGymHours?
    var two: DailyGymHours?
    var three: DailyGymHours?
    var four: DailyGymHours?
    var five: DailyGymHours?
    var six: DailyGymHours?

    func getGymHours(isTomorrow: Bool) -> DailyGymHours {
        let defaultDailyGymHours = DailyGymHours(id: -1, dayOfWeek: -1, openTime: "00:00AM", closeTime: "00:00AM")
        let date = isTomorrow ? Date().getIntegerDayOfWeekTomorrow() : Date().getIntegerDayOfWeekToday()
        switch(date) {
        case 0:
            return zero ?? defaultDailyGymHours
        case 1:
            return one ?? defaultDailyGymHours
        case 2:
            return two ?? defaultDailyGymHours
        case 3:
            return three ?? defaultDailyGymHours
        case 4:
            return four ?? defaultDailyGymHours
        case 5:
            return five ?? defaultDailyGymHours
        case 6:
            return six ?? defaultDailyGymHours
        default:
            return defaultDailyGymHours
        }
    }
}

struct DailyGymHours: Codable {
    var id: Int
    var dayOfWeek: Int
    var openTime: String
    var closeTime: String
}

struct PopularTimes: Codable {
    var id: Int
    var gym: Int
    var monday: [Int]
    var tuesday: [Int]
    var wednesday: [Int]
    var thursday: [Int]
    var friday: [Int]
    var saturday: [Int]
    var sunday: [Int]

    init(id: Int, gym: Int, monday: [Int], tuesday: [Int], wednesday: [Int], thursday: [Int], friday: [Int], saturday: [Int], sunday: [Int]) {
        self.id = id
        self.gym = gym
        self.monday = monday
        self.tuesday = tuesday
        self.wednesday = wednesday
        self.thursday = thursday
        self.friday = friday
        self.saturday = saturday
        self.sunday = sunday
    }
}

extension Gym: Decodable {


    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)

        id = try container.decode(Int.self, forKey: .id)
        name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        equipment = try container.decodeIfPresent(String.self, forKey: .equipment) ?? ""
        location = try container.decodeIfPresent(Int.self, forKey: .location) ??  -1

        let gymHoursContainer = try container.nestedContainer(keyedBy: GymHoursKey.self, forKey: .gymHours)

        var containers: [KeyedDecodingContainer<Gym.DailyGymHoursKey>?] = [nil, nil, nil, nil, nil, nil, nil]

        for key in gymHoursContainer.allKeys {
            switch key {
            case .zero:
                let zeroContainer = try gymHoursContainer.nestedContainer(keyedBy: DailyGymHoursKey.self, forKey: .zero)
                containers.insert(zeroContainer, at: 0)
                containers.remove(at: 1)
            case .one:
                let oneContainer = try gymHoursContainer.nestedContainer(keyedBy: DailyGymHoursKey.self, forKey: .one)
                containers.insert(oneContainer, at: 1)
                containers.remove(at: 2)
            case .two:
                let twoContainer = try gymHoursContainer.nestedContainer(keyedBy: DailyGymHoursKey.self, forKey: .two)
                containers.insert(twoContainer, at: 2)
                containers.remove(at: 3)
            case .three:
                let theeContainer = try gymHoursContainer.nestedContainer(keyedBy: DailyGymHoursKey.self, forKey: .three)
                containers.insert(theeContainer, at: 3)
                containers.remove(at: 4)
            case .four:
                let fourContainer = try gymHoursContainer.nestedContainer(keyedBy: DailyGymHoursKey.self, forKey: .four)
                containers.insert(fourContainer, at: 4)
                containers.remove(at: 5)
            case .five:
                let fiveContainer = try gymHoursContainer.nestedContainer(keyedBy: DailyGymHoursKey.self, forKey: .five)
                containers.insert(fiveContainer, at: 5)
                containers.remove(at: 6)
            case .six:
                let sixContainer = try gymHoursContainer.nestedContainer(keyedBy: DailyGymHoursKey.self, forKey: .six)
                containers.insert(sixContainer, at: 6)
                containers.remove(at: 7)
            }
        }
        var dailyGymHours: [DailyGymHours?] = []

        for container in containers {
            if container == nil {
                dailyGymHours.append(nil)
            } else {
                let id = try container!.decodeIfPresent(Int.self, forKey: .id) ?? -1
                let dayOfWeek = try container!.decodeIfPresent(Int.self, forKey: .dayOfWeek) ?? -1
                let openTime = try container!.decodeIfPresent(String.self, forKey: .openTime) ?? ""
                let closeTime = try container!.decodeIfPresent(String.self, forKey: .closeTime) ?? ""
                dailyGymHours.append(DailyGymHours(id: id, dayOfWeek: dayOfWeek, openTime: openTime, closeTime: closeTime))
            }
        }

        gymHours = GymHours(zero: dailyGymHours[0], one: dailyGymHours[1], two: dailyGymHours[2], three: dailyGymHours[3], four: dailyGymHours[4], five: dailyGymHours[5], six: dailyGymHours[6])

        classInstances = try container.decodeIfPresent([Int].self, forKey: .classInstances) ?? []

        isGym = try container.decodeIfPresent(Bool.self, forKey: .isGym) ?? true

        let popularTimesContainer = try container.nestedContainer(keyedBy: PopularTimesKey.self, forKey: .popularTimesList)

        let popularTimesId = try popularTimesContainer.decodeIfPresent(Int.self, forKey: .id) ?? -1
        let popularTimesGym = try popularTimesContainer.decodeIfPresent(Int.self, forKey: .gym) ?? -1

        let monday = try popularTimesContainer.decodeIfPresent([Int].self, forKey: .monday) ?? []
        let tuesday = try popularTimesContainer.decodeIfPresent([Int].self, forKey: .tuesday) ?? []
        let wednesday = try popularTimesContainer.decodeIfPresent([Int].self, forKey: .wednesday) ?? []
        let thursday = try popularTimesContainer.decodeIfPresent([Int].self, forKey: .thursday) ?? []
        let friday = try popularTimesContainer.decodeIfPresent([Int].self, forKey: .friday) ?? []
        let saturday = try popularTimesContainer.decodeIfPresent([Int].self, forKey: .saturday) ?? []
        let sunday = try popularTimesContainer.decodeIfPresent([Int].self, forKey: .sunday) ?? []

        popularTimesList = PopularTimes(id: popularTimesId, gym: popularTimesGym, monday: monday, tuesday: tuesday, wednesday: wednesday,
                                        thursday: thursday, friday: friday, saturday: saturday, sunday: sunday)

        imageURL = try container.decodeIfPresent(String.self, forKey: .imageURL) ?? ""
    }
}
