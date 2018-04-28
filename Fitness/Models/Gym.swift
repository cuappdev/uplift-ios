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
    let location: Int
    var gymHours: [GymHours]
    let classInstances: [Int]
    let isGym: Bool
    let popularTimesList: PopularTimes
    let imageURL: String
}

struct GymsRootData: Decodable {
    var data: [Gym]
    var success: Bool
}

struct GymRootData: Decodable {
    var data: Gym
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
    
    init(id: Int, gym: Int, monday: [Int], tuesday: [Int], wednesday: [Int], thursday: [Int], friday: [Int], saturday: [Int], sunday: [Int]){
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
    
    enum Key: String, CodingKey {
        case id
        case name
        case equipment
        case location = "location_gym"
        case gymHours = "gym_hours"
        case classInstances = "class_instances"
        case isGym = "is_gym"
        case popularTimesList = "popular_times_list"
        case imageURL = "image_url"
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
        
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        equipment = try container.decodeIfPresent(String.self, forKey: .equipment) ?? ""
        location = try container.decodeIfPresent(Int.self, forKey: .location) ??  -1
        
        gymHours = [GymHours]()
        var gymHoursUnkeyedContainer = try container.nestedUnkeyedContainer(forKey: .gymHours)
        
        while !gymHoursUnkeyedContainer.isAtEnd {
            let gymHoursKeyedContainer = try gymHoursUnkeyedContainer.nestedContainer(keyedBy: GymHoursKey.self)
            
            let id = try gymHoursKeyedContainer.decodeIfPresent(Int.self, forKey: .id) ?? -1
            let gym = try gymHoursKeyedContainer.decodeIfPresent(Int.self, forKey: .gym) ?? -1
            let dayOfWeek = try gymHoursKeyedContainer.decodeIfPresent(Int.self, forKey: .dayOfWeek) ?? -1
            let openTime = try gymHoursKeyedContainer.decodeIfPresent(String.self, forKey: .openTime) ?? ""
            let closeTime = try gymHoursKeyedContainer.decodeIfPresent(String.self, forKey: .closeTime) ?? ""
            
            gymHours.append(GymHours(id: id, gym: gym, dayOfWeek: dayOfWeek, openTime: openTime, closeTime: closeTime))
        }
        
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

        popularTimesList = PopularTimes(id: popularTimesId, gym: popularTimesGym, monday: monday, tuesday: tuesday, wednesday: wednesday, thursday: thursday, friday: friday, saturday: saturday, sunday: sunday)
        
        imageURL = try container.decode(String.self, forKey: .imageURL)
    }
}
