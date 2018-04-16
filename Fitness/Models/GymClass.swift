//
//  GymClass.swift
//  Fitness
//
//  Created by Keivan Shahida on 4/14/18.
//  Copyright © 2018 Keivan Shahida. All rights reserved.
//

import Foundation

struct GymClass {
    var id: Int
    var gymClass: GymClassDetails
    var startTime: String
    var duration: String
    var isCancelled: Bool
    
    init(id: Int, gymClass: GymClassDetails, startTime: String, duration: String, isCancelled: Bool){
        self.id = id
        self.gymClass = gymClass
        self.startTime = startTime
        self.duration = duration
        self.isCancelled = isCancelled
    }
}

struct GymClassDetails {
    var id: Int
    var name: String
    var gym: String
    var description: String
    var instructor: String
}

extension GymClass: Decodable {
    
    enum Key: String, CodingKey {
        case id
        case gymClass = "gym_class"
        case startTime = "start_time"
        case duration
        case isCancelled = "is_cancelled"
    }
    
    enum GymClassDetailsKey: String, CodingKey {
        case id
        case name
        case gym
        case description
        case instructor
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        let id = try container.decode(Int.self, forKey: .id)
        
        let gymClassDetails = try container.nestedContainer(keyedBy: GymClassDetailsKey.self, forKey: .gymClass)
        let gymClassDetailID = try gymClassDetails.decodeIfPresent(Int.self, forKey: .id) ?? -1
        let gymClassDetailName = try gymClassDetails.decodeIfPresent(String.self, forKey: .name) ?? ""
        let gymClassDetailGym = try gymClassDetails.decodeIfPresent(String.self, forKey: .gym) ?? ""
        let gymClassDetailDescription = try gymClassDetails.decodeIfPresent(String.self, forKey: .description) ?? ""
        let gymClassDetailInstructor = try gymClassDetails.decodeIfPresent(String.self, forKey: .instructor) ?? ""
        let gymClass = GymClassDetails(id: gymClassDetailID, name: gymClassDetailName, gym: gymClassDetailGym, description: gymClassDetailDescription, instructor: gymClassDetailInstructor)
        
        let startTime = try container.decodeIfPresent(String.self, forKey: .startTime) ?? ""
        let duration = try container.decodeIfPresent(String.self, forKey: .duration) ?? ""
        let isCancelled = try container.decode(Bool.self, forKey: .isCancelled)
        
        self.init(id: id, gymClass: gymClass, startTime: startTime, duration: duration, isCancelled: isCancelled)
    }
}
