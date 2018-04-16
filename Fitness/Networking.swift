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
    
    case gyms(id: Int, name: String, equipment: String, location: String, gymHours: [GymHours])
    case gymClasses(id: Int, gymClass: GymClassDetails, startTime: String, duration: String, isCancelled: Bool)
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
        case let .gyms(id, name, equipment, location, gymHours):
            json = ["id": id,
                    "name": name,
                    "equipment": equipment,
                    "location": location,
                    "gym_hours": gymHours]
        case let .gymClasses(id, gymClass, startTime, duration, isCancelled):
            json = ["id": id,
                    "gym_class": gymClass,
                    "start_time": startTime,
                    "duration": duration,
                    "is_cancelled": isCancelled]
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
                    let gymData = try? JSONDecoder().decode(RootData.self, from: data)
                    guard let gyms = gymData?.data else { return }
                    completionHandler(gyms, statusCode)
                case .gymClasses:
                    let gymClasses = try? JSONDecoder().decode([GymClass].self, from: data)
                    let gymClass = try? JSONDecoder().decode(GymClass.self, from: data)
                    completionHandler(gymClasses ?? gymClass, statusCode)
                case .instructors:
                    let instructors = try? JSONDecoder().decode([Instructor].self, from: data)
                    let instructor = try? JSONDecoder().decode(Instructor.self, from: data)
                    completionHandler(instructors ?? instructor, statusCode)
                }
            }
        }.resume()
    }
}
