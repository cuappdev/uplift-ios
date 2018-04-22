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
    var location: Int
    var gymHours: [GymHours]
    var classInstances: [String] //temp
    var isGym: Bool
    var popularTimesList: PopularTimes
    
    var imageURL: String
    
    init(id: Int, name: String, equipment: String, location: Int, gymHours: [GymHours], classInstances: [String], isGym: Bool, popularTimesList: PopularTimes, imageURL: String){
        self.id = id
        self.name = name
        self.equipment = equipment
        self.location = location
        self.gymHours = gymHours
        self.classInstances = classInstances
        self.isGym = isGym
        self.popularTimesList = popularTimesList
        self.imageURL = imageURL
    }
}

struct GymRootData: Decodable {
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
        
        let id = try container.decode(Int.self, forKey: .id)
        let name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        let equipment = try container.decodeIfPresent(String.self, forKey: .equipment) ?? ""
        let location = try container.decodeIfPresent(Int.self, forKey: .location) ??  -1
        
        var gymHours = [GymHours]()
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
        
        let classInstances = [String]() //temp
        let isGym = try container.decodeIfPresent(Bool.self, forKey: .isGym) ?? true
        
        let popularTimesContainer = try container.nestedContainer(keyedBy: PopularTimesKey.self, forKey: .popularTimesList)
        
        let popularTimesId = try popularTimesContainer.decodeIfPresent(Int.self, forKey: .id) ?? -1
        let popularTimesGym = try popularTimesContainer.decodeIfPresent(Int.self, forKey: .gym) ?? -1
        
        var mondayString = try popularTimesContainer.decodeIfPresent(String.self, forKey: .monday) ?? "[-1]"
        mondayString.removeFirst()
        mondayString.removeLast()
        let monday = mondayString.components(separatedBy: ",").map{ Int($0)!}
        
        var tuesdayString = try popularTimesContainer.decodeIfPresent(String.self, forKey: .tuesday) ?? "[-1]"
        tuesdayString.removeFirst()
        tuesdayString.removeLast()
        let tuesday = tuesdayString.components(separatedBy: ",").map { Int($0)!}
        
        var wednesdayString = try popularTimesContainer.decodeIfPresent(String.self, forKey: .wednesday) ?? "[-1]"
        wednesdayString.removeFirst()
        wednesdayString.removeLast()
        let wednesday = wednesdayString.components(separatedBy: ",").map { Int($0)!}
        
        var thursdayString = try popularTimesContainer.decodeIfPresent(String.self, forKey: .thursday) ?? "[-1]"
        thursdayString.removeFirst()
        thursdayString.removeLast()
        let thursday = thursdayString.components(separatedBy: ",").map { Int($0)!}
        
        var fridayString = try popularTimesContainer.decodeIfPresent(String.self, forKey: .friday) ?? "[-1]"
        fridayString.removeFirst()
        fridayString.removeLast()
        let friday = fridayString.components(separatedBy: ",").map { Int($0)!}
        
        var saturdayString = try popularTimesContainer.decodeIfPresent(String.self, forKey: .saturday) ?? "[-1]"
        saturdayString.removeFirst()
        saturdayString.removeLast()
        let saturday = saturdayString.components(separatedBy: ",").map { Int($0)!}
        
        var sundayString = try popularTimesContainer.decodeIfPresent(String.self, forKey: .sunday) ?? "[-1]"
        sundayString.removeFirst()
        sundayString.removeLast()
        let sunday = sundayString.components(separatedBy: ",").map { Int($0)!}
        
        let popularTimesList = PopularTimes(id: popularTimesId, gym: popularTimesGym, monday: monday, tuesday: tuesday, wednesday: wednesday, thursday: thursday, friday: friday, saturday: saturday, sunday: sunday)
        
        let imageURL = try container.decode(String.self, forKey: .imageURL)
        
        self.init(id: id, name: name, equipment: equipment, location: location, gymHours: gymHours, classInstances: classInstances, isGym: isGym, popularTimesList: popularTimesList, imageURL: imageURL)
    }
}
