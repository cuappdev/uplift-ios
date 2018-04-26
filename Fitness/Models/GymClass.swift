//
//  GymClass.swift
//  Fitness
//
//  Created by Keivan Shahida on 4/14/18.
//  Copyright © 2018 Keivan Shahida. All rights reserved.
//

import Foundation

struct GymClass {
    let id: Int
    let classDesc: Int
    let gymClassInstances: [Int]
    let instructor: Int
    let users: [Int]
}

struct GymClassesRootData: Decodable {
    var data: [GymClass]
    var success: Bool
}

struct GymClassRootData: Decodable {
    var data: GymClass
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
        id = try container.decode(Int.self, forKey: .id)
        classDesc = try container.decodeIfPresent(Int.self, forKey: .classDesc) ?? -1
        gymClassInstances = try container.decodeIfPresent([Int].self, forKey: .gymClassInstances) ?? []
        instructor = try container.decodeIfPresent(Int.self, forKey: .instructor) ?? -1
        users = try container.decodeIfPresent([Int].self, forKey: .users) ?? []
    }
}
