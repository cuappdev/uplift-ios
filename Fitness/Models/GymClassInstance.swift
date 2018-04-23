//
//  GymClassInstance.swift
//  Fitness
//
//  Created by Keivan Shahida on 4/22/18.
//  Copyright © 2018 Keivan Shahida. All rights reserved.
//

import Foundation

struct GymClassInstance {

    var gymClassInstanceId: Int
    var classDescription: GymClassDescription
    var instructor: Instructor
    
    init(gymClassInstanceId: Int, classDescription: GymClassDescription, instructor: Instructor) {
        self.gymClassInstanceId = gymClassInstanceId
        self.classDescription = classDescription
        self.instructor = instructor
    }
}

struct GymClassInstanceRootData: Decodable {
    var data: [GymClassInstance]
    var success: Bool
}

extension GymClassInstance: Decodable {
    
    enum Key: String, CodingKey {
        case classDescription = "class_desc"
        case id
        case instructor
    }
    
    enum ClassDescriptionKey: String, CodingKey {
        case id
        case description
        case name
        case tags = "class_tags"
        case gymClasses = "gym_classes"
        case imageURL = "image_url"
    }
    
    enum InstructorKey: String, CodingKey {
        case id
        case name
        case gymClasses = "gym_classes"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        
        let classDescriptionContainer = try container.nestedContainer(keyedBy: ClassDescriptionKey.self, forKey: .classDescription)
        let classDescriptionId = try classDescriptionContainer.decode(Int.self, forKey: .id)
        let classDescriptionDescription = try classDescriptionContainer.decodeIfPresent(String.self, forKey: .description) ?? ""
        let classDescriptionName = try classDescriptionContainer.decodeIfPresent(String.self, forKey: .name) ?? ""
        let classDescriptionTags = try classDescriptionContainer.decodeIfPresent([Int].self, forKey: .tags) ?? []
        let classDescriptionGymClasses = try classDescriptionContainer.decodeIfPresent([Int].self, forKey: .gymClasses) ?? []
        let classDescriptionImageURL = try classDescriptionContainer.decodeIfPresent(String.self, forKey: .imageURL) ?? ""
        
        let classDescription = GymClassDescription(id: classDescriptionId, description: classDescriptionDescription, name: classDescriptionName, tags: classDescriptionTags, gymClasses: classDescriptionGymClasses, imageURL: classDescriptionImageURL)
        
        let id = try container.decode(Int.self, forKey: .id)
        
        let instructorContainer = try container.nestedContainer(keyedBy: InstructorKey.self, forKey: .instructor)
        let instructorGymClasses = try instructorContainer.decodeIfPresent([Int].self, forKey: .gymClasses) ?? []
        let instructorId = try instructorContainer.decode(Int.self, forKey: .id)
        let instructorName = try instructorContainer.decodeIfPresent(String.self, forKey: .name) ?? ""
        let instructor = Instructor(id: instructorId, name: instructorName, gymClasses: instructorGymClasses)
        
        self.init(gymClassInstanceId: id, classDescription: classDescription, instructor: instructor)
    }
}

