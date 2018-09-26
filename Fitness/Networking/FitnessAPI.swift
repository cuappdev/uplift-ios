//
//  API.swift
//  Fitness
//
//  Created by Keivan Shahida on 4/24/18.
//  Copyright © 2018 Keivan Shahida. All rights reserved.
//

import Foundation
import Moya

enum FitnessAPI {

    //Gyms
    case gyms
    case gym(gymId: Int)

    //Gym Class Instances
    case gymClassInstances
    case gymClassInstance(gymClassInstanceId: Int)
    case gymClassInstancesPaginated(page: Int, pageSize: Int)
    case gymClassInstancesByDate(date: String)
    case gymClassInstancesSearch(startTime: String, endTime: String, instructorIDs: [Int], gymIDs: [Int], classDescriptionIDs: [Int])

    //Class Descriptions
    case gymClassDescriptions
    case gymClassDescription(gymClassDescriptionId: Int)
    case gymClassDescriptionsByTag(tag: Int)

    //Tags
    case tags

    //Gym Classes
    case gymClasses
    case gymClass(gymClassId: Int)

    //Instructors
    case instructors
    case instructor(instructorId: Int)
}

extension FitnessAPI: TargetType {

    var environmentBaseURL: String {
        switch NetworkManager.environment {
        case .production: return "http://localhost:6000/api/v0/" //temp
        case .development: return "http://localhost:6000/api/v0/"
        }
    }

    var baseURL: URL {
        guard let url = URL(string: environmentBaseURL) else { fatalError("baseURL could not be configured.")}
        return url
    }

    var path: String {
        switch self {
        case .gyms: return "gyms"
        case .gym(let gymId): return "gym/\(gymId)"

        case .gymClassInstances: return "gymclassinstances"
        case .gymClassInstance(let gymClassInstanceId): return "gymclassinstance/\(gymClassInstanceId)"
        case .gymClassInstancesPaginated: return "gymclassinstances/"
        case .gymClassInstancesByDate: return "gymclassinstances/date/"
        case .gymClassInstancesSearch: return "search_gymclass_instances/"

        case .gymClassDescriptions: return "class_descs"
        case .gymClassDescription(let classDescriptionId): return "class_desc/\(classDescriptionId)"
        case .gymClassDescriptionsByTag(let tag): return "class_descs/\(tag)"

        case .tags: return "tags"

        case .gymClasses: return "gymclasses"
        case .gymClass(let gymClassId): return "gymclass/\(gymClassId)"

        case .instructors: return "instructors"
        case .instructor(let instructorId): return "instructor/\(instructorId)"

        }
    }

    var method: Moya.Method {
        return .get
    }

    var parameterEncoding: ParameterEncoding {
        return JSONEncoding.default
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch self {
        case .gymClassInstancesPaginated(let page, let pageSize):
            return .requestParameters(parameters: ["page": page, "page_size": pageSize], encoding: URLEncoding.default)
        case .gymClassInstancesByDate(let date):
            return .requestParameters(parameters: ["date": date], encoding: URLEncoding.default)
        case .gymClassInstancesSearch(let startTime, let endTime, let instructorIDs, let gymIDs, let classDescriptionIDs):
            return .requestParameters(parameters: ["start_time": startTime, "end_time": endTime, "instructor_ids": instructorIDs,
                                                   "gym_ids": gymIDs, "class_desc_ids": classDescriptionIDs], encoding: URLEncoding.default)
        default:
            return .requestPlain
        }
    }

    var headers: [String: String]? {
        return nil
    }
}
