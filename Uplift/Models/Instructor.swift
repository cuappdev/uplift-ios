//
//  Instructor.swift
//  Fitness
//
//  Created by Keivan Shahida on 4/14/18.
//  Copyright © 2018 Keivan Shahida. All rights reserved.
//

import Foundation

struct Instructor {

    let id: Int
    let gymClasses: [Int]
    let name: String
    var gymClassDescriptions: [GymClassDescription]?
}

struct InstructorsRootData: Decodable {
    var data: [Instructor]
    var success: Bool
}

struct InstructorRootData: Decodable {
    var data: Instructor
    var success: Bool
}

extension Instructor: Decodable {

    enum Key: String, CodingKey {
        case id
        case classes
        case gymClasses = "gym_classes"
        case name
    }

    enum GymClassDescriptionsKey: String, CodingKey {
        case id
        case description
        case gymClasses = "gym_classes"
        case name
        case tags = "class_tags"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)

        id = try container.decode(Int.self, forKey: .id)
        name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""

        gymClassDescriptions = [GymClassDescription]()
        var gymClassDescriptionsUnkeyedContainer = try  container.nestedUnkeyedContainer(forKey: .classes)
        while !gymClassDescriptionsUnkeyedContainer.isAtEnd {
            let gymClassDescriptionKeyedContainer = try gymClassDescriptionsUnkeyedContainer.nestedContainer(keyedBy: GymClassDescriptionsKey.self)
            let id = try gymClassDescriptionKeyedContainer.decodeIfPresent(Int.self, forKey: .id) ?? -1
            let name = try gymClassDescriptionKeyedContainer.decodeIfPresent(String.self, forKey: .name) ?? ""
            let description = try gymClassDescriptionKeyedContainer.decodeIfPresent(String.self, forKey: .description) ?? ""
            let tags = try gymClassDescriptionKeyedContainer.decodeIfPresent([Int].self, forKey: .tags) ?? []
            let gymClasses = try gymClassDescriptionKeyedContainer.decodeIfPresent([Int].self, forKey: .gymClasses) ?? []

            gymClassDescriptions?.append(GymClassDescription(id: id, description: description, name: name, tags: tags, gymClasses: gymClasses, imageURL: ""))

        }

        gymClasses = try container.decode([Int].self, forKey: .gymClasses)
    }
}
