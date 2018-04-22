//
//  Networking.swift
//  Fitness
//
//  Created by Keivan Shahida on 4/15/18.
//  Copyright © 2018 Keivan Shahida. All rights reserved.
//

import Foundation
import KeychainSwift

private let baseURL = "http://localhost:5000/api/v0"

enum Route {
    
    case gyms(id: Int, name: String, equipment: String, location: Int, gymHours: [GymHours], classInstances: [String], isGym: Bool, popularTimesList: PopularTimes, imageURL: String)
    case gymClasses(id: Int, classDesc: Int, gymClassInstances: [Int], instructor: Int, users: [Int])
    case instructors(id: Int, name: String, classes: [Class])
    
    func path() -> String {
        switch self {
        case .gyms:
            return "\(baseURL)/gyms"
        case .gymClasses:
            return "\(baseURL)/gymclasses"
        case .instructors:
            return "\(baseURL)/instructors"
        }
    }
    
    func postBody() -> Data? {
        let json: [String : Any]
        switch self {
        case let .gyms(id, name, equipment, location, gymHours, classInstances, isGym, popularTimesList, imageURL):
            json = ["id": id,
                    "name": name,
                    "equipment": equipment,
                    "location_gym": location,
                    "gym_hours": gymHours,
                    "class_instances": classInstances,
                    "is_gym": isGym,
                    "popular_times_list": popularTimesList,
                    "image_url": imageURL]
        case let .gymClasses(id, classDesc, gymClassInstances, instructor, users):
            json = ["id": id,
                    "class_desc": classDesc,
                    "gym_class_instances": gymClassInstances,
                    "instructor": instructor,
                    "users": users]
        case let .instructors(id, name, classes):
            json = ["id": id,
                    "name": name,
                    "classes": classes]
        }
        let data: Data? = try? JSONSerialization.data(withJSONObject: json, options: [])
        return data
    }
}

enum HTTPVerb: String {
    case get = "GET"
    case post = "POST"
    case update = "PATCH"
    case delete = "DELETE"
}

class NetworkingLayer {
    
    func networkingService(route: Route, verb: HTTPVerb, completionHandler: @escaping (Decodable?, Int)-> Void) {
        
        let session = URLSession.shared
        guard let urlString = URL(string: route.path()) else { return }
        
        var getRequest = URLRequest(url: urlString)
        getRequest.httpMethod = verb.rawValue
        if verb.rawValue == "POST" {
            getRequest.httpBody = route.postBody()
        }
        
        getRequest.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        session.dataTask(with: getRequest) { (data, response, error) in
            if let data = data {
                let statusCode: Int = (response as! HTTPURLResponse).statusCode
                switch route {
                case .gyms:
                    let gymData = try? JSONDecoder().decode(GymRootData.self, from: data)
                    guard let gyms = gymData?.data else { return }
                    completionHandler(gyms, statusCode)
                case .gymClasses:
                    let gymClassData = try? JSONDecoder().decode(GymClassRootData.self, from: data)
                    guard let gymClasses = gymClassData?.data else { return }
                    completionHandler(gymClasses, statusCode)
                case .instructors:
                    let instructors = try? JSONDecoder().decode([Instructor].self, from: data)
                    let instructor = try? JSONDecoder().decode(Instructor.self, from: data)
                    completionHandler(instructors ?? instructor, statusCode)
                }
            }
        }.resume()
    }
}
