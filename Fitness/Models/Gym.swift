//
//  Gym.swift
//  Fitness
//
//  Created by Keivan Shahida on 4/14/18.
//  Copyright © 2018 Keivan Shahida. All rights reserved.
//

import Foundation

struct Gym {

    var id: Int
    var name: String
    var equipment: String
    var location: String
    var gymHours: [GymHours]
    var classInstances: [String] //temp
    var isGym: Bool
    var popularTimesList: [PopularTimes]
    
    init(id: Int, name: String, equipment: String, location: String, gymHours: [GymHours], classInstances: [String], isGym: Bool, popularTimesList: [PopularTimes]){
        self.id = id
        self.name = name
        self.equipment = equipment
        self.location = location
        self.gymHours = gymHours
        self.classInstances = classInstances
        self.isGym = isGym
        self.popularTimesList = popularTimesList
    }
}

struct RootData: Decodable {
    var data: [Gym]
    var success: Bool
}

struct GymHours: Codable {
    var id: Int
    var gym: Int
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
}

extension Gym: Decodable {
    
    enum Key: String, CodingKey {
        case id
        case name
        case equipment
        case location
        case gymHours = "gym_hours"
        case classInstances = "class_instances"
        case isGym = "is_gym"
        case popularTimesList = "popular_times_list"
    }
    
    enum GymHoursKey: String, CodingKey {
        case id
        case gym
        case dayOfWeek = "day_of_week"
        case openTime = "open_time"
        case closeTime = "close_time"
    }
    
    enum PopularTimesKey: String, CodingKey {
        case id
        case gym
        case monday
        case tuesday
        case wednesday
        case thursday
        case friday
        case saturday
        case sunday
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        
        let id = try container.decode(Int.self, forKey: .id)
        let name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        let equipment = try container.decodeIfPresent(String.self, forKey: .equipment) ?? ""
        let location = try container.decodeIfPresent(String.self, forKey: .location) ?? ""
        
        var gymHours = [GymHours]()
        let gymHoursContainer = try container.nestedContainer(keyedBy: GymHoursKey.self, forKey: .gymHours)
        for key in gymHoursContainer.allKeys {
            let nested = try gymHoursContainer.nestedContainer(keyedBy: GymHoursKey.self, forKey: key)
            
            let id = try nested.decodeIfPresent(Int.self, forKey: .id) ?? -1
            let gym = try nested.decodeIfPresent(Int.self, forKey: .gym) ?? -1
            let dayOfWeek = try nested.decodeIfPresent(Int.self, forKey: .dayOfWeek) ?? -1
            let openTime = try nested.decodeIfPresent(String.self, forKey: .openTime) ?? ""
            let closeTime = try nested.decodeIfPresent(String.self, forKey: .closeTime) ?? ""
            
            gymHours.append(GymHours(id: id, gym: gym, dayOfWeek: dayOfWeek, openTime: openTime, closeTime: closeTime))
        }
        
        let classInstances = [String]() //temp
        let isGym = try container.decodeIfPresent(Bool.self, forKey: .isGym) ?? true
        
        var popularTimesList = [PopularTimes]()
        let popularTimesContainer = try container.nestedContainer(keyedBy: PopularTimesKey.self, forKey: .popularTimesList)
        for key in popularTimesContainer.allKeys {
            let nested = try popularTimesContainer.nestedContainer(keyedBy: PopularTimesKey.self, forKey: key)
            
            let id = try nested.decodeIfPresent(Int.self, forKey: .id) ?? -1
            let gym = try nested.decodeIfPresent(Int.self, forKey: .gym) ?? -1
            let monday = try nested.decodeIfPresent([Int].self, forKey: .monday) ?? [-1]
            let tuesday = try nested.decodeIfPresent([Int].self, forKey: .tuesday) ?? [-1]
            let wednesday = try nested.decodeIfPresent([Int].self, forKey: .wednesday) ?? [-1]
            let thursday = try nested.decodeIfPresent([Int].self, forKey: .thursday) ?? [-1]
            let friday = try nested.decodeIfPresent([Int].self, forKey: .friday) ?? [-1]
            let saturday = try nested.decodeIfPresent([Int].self, forKey: .saturday) ?? [-1]
            let sunday = try nested.decodeIfPresent([Int].self, forKey: .sunday) ?? [-1]
            
            popularTimesList.append(PopularTimes(id: id, gym: gym, monday: monday, tuesday: tuesday, wednesday: wednesday, thursday: thursday, friday: friday, saturday: saturday, sunday: sunday))
        }
        
        
        self.init(id: id, name: name, equipment: equipment, location: location, gymHours: gymHours, classInstances: classInstances, isGym: isGym, popularTimesList: popularTimesList)
    }
}
