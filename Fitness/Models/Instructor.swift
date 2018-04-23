//
//  Instructor.swift
//  Fitness
//
//  Created by Keivan Shahida on 4/14/18.
//  Copyright © 2018 Keivan Shahida. All rights reserved.
//

import Foundation

struct Instructor {
    
    var id: Int
    var name: String
    var gymClassDescriptions: [GymClassDescription]
    var gymClasses: [Int]
    
    init(id: Int, name: String, gymClassDescriptions: [GymClassDescription], gymClasses: [Int]){
        self.id = id
        self.name = name
        self.gymClassDescriptions = gymClassDescriptions
        self.gymClasses = gymClasses
    }
    
    init(id: Int, name: String, gymClasses: [Int]){
        self.id = id
        self.name = name
        self.gymClasses = gymClasses
        self.gymClassDescriptions = []
    }
}

struct InstructorRootData: Decodable {
    var data: [Instructor]
    var success: Bool
}

extension Instructor: Decodable {
    
    enum Key: String, CodingKey {
        case id
        case name
        case classes
        case gymClasses = "gym_classes"
    }
    
    enum ClassesKey: String, CodingKey {
        case id
        case tags = "class_tags"
        case gymClasses = "gym_classes"
        case name
        case description
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)

        let id = try container.decode(Int.self, forKey: .id)
        let name = try container.decodeIfPresent(String.self, forKey: .name)
        
        
//        self.init(id: id, name: name, classes: classes)
    }
}
