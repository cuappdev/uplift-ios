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
    
    init(id: Int, name: String, equipment: String, location: String, gymHours: [GymHours]){
        self.id = id
        self.name = name
        self.equipment = equipment
        self.location = location
        self.gymHours = gymHours
    }
}

struct GymHours: Codable {
    var dayOfWeek: Int
    var openTime: String
    var closeTime: String
}

extension Gym: Decodable {
    
    enum Key: String, CodingKey {
        case id
        case name
        case equipment
        case location
        case gymHours = "gym_hours"
    }
    
    enum GymHoursKey: String, CodingKey {
        case dayOfWeek = "day_of_week"
        case openTime = "open_time"
        case closeTime = "close_time"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        let id = try container.decode(Int.self, forKey: .id)
        let name = try container.decodeIfPresent(String.self, forKey: .name) ?? "Empty"
        let equipment = try container.decodeIfPresent(String.self, forKey: .equipment) ?? "Empty"
        let location = try container.decodeIfPresent(String.self, forKey: .location) ?? "Empty"
        
        var gymHours = [GymHours]()
        let gymHoursContainer = try container.nestedContainer(keyedBy: GymHoursKey.self, forKey: .gymHours)
        
        for key in gymHoursContainer.allKeys {
            let nested = try gymHoursContainer.nestedContainer(keyedBy: GymHoursKey.self, forKey: key)
            
            let dayOfWeek = try nested.decodeIfPresent(Int.self, forKey: .dayOfWeek) ?? -1
            let openTime = try nested.decodeIfPresent(String.self, forKey: .openTime) ?? ""
            let closeTime = try nested.decodeIfPresent(String.self, forKey: .closeTime) ?? ""
            
            gymHours.append(GymHours(dayOfWeek: dayOfWeek, openTime: openTime, closeTime: closeTime))
        }
        
        self.init(id: id, name: name, equipment: equipment, location: location, gymHours: gymHours)
    }
}
