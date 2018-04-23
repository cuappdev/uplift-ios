//
//  ClassDescription.swift
//  Fitness
//
//  Created by Keivan Shahida on 4/22/18.
//  Copyright © 2018 Keivan Shahida. All rights reserved.
//

import Foundation

struct GymClassDescription {
    
    var id: Int
    var description: String
    var name: String
    var tags: [Int]
    var gymClasses: [Int]
    var imageURL: String
    
    init(id: Int, description: String, name: String, tags: [Int], gymClasses: [Int], imageURL: String){
        self.id = id
        self.description = description
        self.name = name
        self.tags = tags
        self.gymClasses = gymClasses
        self.imageURL = imageURL
    }
}

struct GymClassDescriptionRootData: Decodable {
    var data: [GymClassDescription]
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
        
        let id = try container.decode(Int.self, forKey: .id)
        let description = try container.decodeIfPresent(String.self, forKey: .description) ?? ""
        let name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        let tags = try container.decodeIfPresent([Int].self, forKey: .tags) ?? []
        let gymClasses = try container.decodeIfPresent([Int].self, forKey: .gymClasses) ?? []
        let imageURL = try container.decodeIfPresent(String.self, forKey: .imageURL) ?? ""
        
        self.init(id: id, description: description, name: name, tags: tags, gymClasses: gymClasses, imageURL: imageURL)
    }
}
