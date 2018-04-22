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
    var classDesc: Int
    var gymClassInstances: [Int]
    var instructor: Int
    var users: [Int]
    
    init(id: Int, classDesc: Int, gymClassInstances: [Int], instructor: Int, users: [Int]){
        self.id = id
        self.classDesc = classDesc
        self.gymClassInstances = gymClassInstances
        self.instructor = instructor
        self.users = users
    }
}

struct GymClassRootData: Decodable {
    var data: [GymClass]
    var success: Bool
}

extension GymClass: Decodable {
    
    enum Key: String, CodingKey {
        case id
        case classDesc = "class_desc"
        case gymClassInstances = "gym_class_instances"
        case instructor
        case users
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        let id = try container.decode(Int.self, forKey: .id)
        let classDesc = try container.decode(Int.self, forKey: .classDesc)
        let gymClassInstances = try container.decode([Int].self, forKey: .gymClassInstances)
        let instructor = try container.decode(Int.self, forKey: .instructor)
        let users = try container.decode([Int].self, forKey: .users)

        self.init(id: id, classDesc: classDesc, gymClassInstances: gymClassInstances, instructor: instructor, users: users)
    }
}
