//
//  ClassDescription.swift
//  Fitness
//
//  Created by Keivan Shahida on 4/22/18.
//  Copyright © 2018 Uplift. All rights reserved.
//

import Foundation

struct GymClassDescription {

    let id: Int
    let description: String
    let name: String
    let tags: [Int]
    let gymClasses: [Int]
    let imageURL: String?
}

struct GymClassDescriptionsRootData: Decodable {
    var data: [GymClassDescription]
    var success: Bool
}

struct GymClassDescriptionRootData: Decodable {
    var data: GymClassDescription
    var success: Bool
}

extension GymClassDescription: Decodable {

    enum Key: String, CodingKey {
        case id
        case description
        case name
        case tags = "class_tags"
        case gymClasses = "gym_classes"
        case imageURL = "image_url"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)

        id = try container.decode(Int.self, forKey: .id)
        description = try container.decodeIfPresent(String.self, forKey: .description) ?? ""
        name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        tags = try container.decodeIfPresent([Int].self, forKey: .tags) ?? []
        gymClasses = try container.decodeIfPresent([Int].self, forKey: .gymClasses) ?? []
        imageURL = try container.decodeIfPresent(String.self, forKey: .imageURL) ?? ""
    }
}
