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
    var classDesc: GymClassDescription
    var gymClassInstances: [Int]
    var instructor: Int
    var users: [Int]
    
    init(id: Int, classDesc: GymClassDescription, gymClassInstances: [Int], instructor: Int, users: [Int]){
        self.id = id
        self.classDesc = classDesc
        self.gymClassInstances = gymClassInstances
        self.instructor = instructor
        self.users = users
    }
}

struct GymClassDescription {
    var id: Int
    var name: String
    var classTags: [Int]
    var description: String
    var gymClasses: [Int]
}

extension GymClass: Decodable {
    
    enum Key: String, CodingKey {
        case id
        case classDesc = "class_desc"
        case gymClassInstances = "gym_class_instances"
        case instructor
        case users
    }
    
    enum GymClassDescriptionKey: String, CodingKey {
        case id
        case name
        case classTags = "class_tags"
        case description
        case gymClasses = "gym_classes"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        let id = try container.decode(Int.self, forKey: .id)
        
        
        
        let gymClassDescription = try container.nestedContainer(keyedBy: GymClassDescriptionKey.self, forKey: .gymClass)
        let gymClassDescriptionID = try gymClassDescription.decodeIfPresent(Int.self, forKey: .id) ?? -1
        let gymClassDetailName = try gymClassDescription.decodeIfPresent(String.self, forKey: .name) ?? ""
        let gymClassDetailGym = try gymClassDescription.decodeIfPresent(String.self, forKey: .gym) ?? ""
        let gymClassDetailDescription = try gymClassDescription.decodeIfPresent(String.self, forKey: .description) ?? ""
        let gymClassDescriptionInstructor = try gymClassDetails.decodeIfPresent(String.self, forKey: .instructor) ?? ""
        let gymClass = GymClassDescription(id: gymClassDetailID, name: gymClassDetailName, gym: gymClassDetailGym, description: gymClassDetailDescription, instructor: gymClassDetailInstructor)
        
        let startTime = try container.decodeIfPresent(String.self, forKey: .startTime) ?? ""
        let duration = try container.decodeIfPresent(String.self, forKey: .duration) ?? ""
        let isCancelled = try container.decode(Bool.self, forKey: .isCancelled)
        
        self.init(id: id, gymClass: gymClass, startTime: startTime, duration: duration, isCancelled: isCancelled)
    }
}
