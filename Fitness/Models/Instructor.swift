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
    var classes: [Class]
    
    init(id: Int, name: String, classes: [Class]){
        self.id = id
        self.name = name
        self.classes = classes
    }
}

struct Class: Codable {
    var id: Int
    var name: String
    var gym: String
    var description: String
    var instructor: String
}

extension Instructor: Decodable {
    
    enum Key: String, CodingKey {
        case id
        case name
        case classes
    }
    
    enum ClassKey: String, CodingKey {
        case id
        case name
        case gym
        case description
        case instructor
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        let id = try container.decode(Int.self, forKey: .id)
        let name = try container.decodeIfPresent(String.self, forKey: .name) ?? "Empty"
        
        var classes = [Class]()
        let classesContainer = try container.nestedContainer(keyedBy: ClassKey.self, forKey: .classes)
        
        for key in classesContainer.allKeys {
            let nested = try classesContainer.nestedContainer(keyedBy: ClassKey.self, forKey: key)
            
            let id = try nested.decode(Int.self, forKey: .id)
            let name = try nested.decodeIfPresent(String.self, forKey: .name) ?? ""
            let gym = try nested.decodeIfPresent(String.self, forKey: .gym) ?? ""
            let description = try nested.decodeIfPresent(String.self, forKey: .description) ?? ""
            let instructor = try nested.decodeIfPresent(String.self, forKey: .instructor) ?? ""

            classes.append(Class(id: id, name: name, gym: gym, description: description, instructor: instructor))
        }
        self.init(id: id, name: name, classes: classes)
    }
}
