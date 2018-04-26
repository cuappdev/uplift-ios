//
//  Tag.swift
//  Fitness
//
//  Created by Keivan Shahida on 4/24/18.
//  Copyright © 2018 Keivan Shahida. All rights reserved.
//

import Foundation

struct Tag {
    let id: Int
    let name: String
    let classDescriptions: [Int]
}

struct TagsRootData: Decodable {
    var data: [Tag]
    var success: Bool
}

extension Tag: Decodable {
    
    enum Key: String, CodingKey {
        case id
        case name
        case classDescriptions = "class_descs"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        classDescriptions = try container.decodeIfPresent([Int].self, forKey: .classDescriptions) ?? []
    }
}
