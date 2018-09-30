//
//  GymClassInstance.swift
//  Fitness
//
//  Created by Keivan Shahida on 4/22/18.
//  Copyright © 2018 Keivan Shahida. All rights reserved.
//
import Foundation

struct GymClassInstance {
    let gymClassInstanceId: Int
    let classDescription: AllClassesInstancesQuery.Data.Class.Detail
    let instructor: String
    let startTime: String
    let gymId: String
    let endTime: String
    
    init?(classData: AllClassesInstancesQuery.Data.Class) {
        guard let description = classData.details, let instructor = classData.instructor, let startTime = classData.startTime,
        let gymId = classData.gymId, let endTime = classData.endTime else { return nil }
        self.classDescription = description
        self.instructor = instructor
        self.startTime = startTime
        self.gymId = gymId
        self.endTime = endTime
    }
}

struct GymClassInstancesRootData: Decodable {
    var data: [GymClassInstance]
    var success: Bool
}

struct GymClassInstanceRootData: Decodable {
    var data: GymClassInstance
    var success: Bool
}

extension GymClassInstance: Decodable {

    enum Key: String, CodingKey {
        case classDescription = "class_desc"
        case duration
        case id
        case gymId = "gym_id"
        case instructor
        case startTime = "start_time"
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

        classDescription = GymClassDescription(id: classDescriptionId, description: classDescriptionDescription, name: classDescriptionName,
                                               tags: classDescriptionTags, gymClasses: classDescriptionGymClasses, imageURL: classDescriptionImageURL)

        duration = try container.decodeIfPresent(String.self, forKey: .duration) ?? ""

        gymClassInstanceId = try container.decode(Int.self, forKey: .id)

        let instructorContainer = try container.nestedContainer(keyedBy: InstructorKey.self, forKey: .instructor)
        let instructorGymClasses = try instructorContainer.decodeIfPresent([Int].self, forKey: .gymClasses) ?? []
        let instructorId = try instructorContainer.decode(Int.self, forKey: .id)
        let instructorName = try instructorContainer.decodeIfPresent(String.self, forKey: .name) ?? ""
        instructor = Instructor(id: instructorId, name: instructorName, gymClassDescriptions: [], gymClasses: instructorGymClasses)

        gymId = try container.decodeIfPresent(Int.self, forKey: .gymId) ?? -1

        startTime = try container.decodeIfPresent(String.self, forKey: .startTime) ?? ""
    }
}
