//
//  Networking.swift
//  Fitness
//
//  Created by Keivan Shahida on 4/15/18.
//  Copyright © 2018 Keivan Shahida. All rights reserved.
//

import Foundation
import KeychainSwift

private let baseURL = ""

enum Route {
    
    case gyms(id: Int, name: String, equipment: String, location: String, gymHours: [GymHours])
    
    func path() -> String {
        switch self {
        case .gyms:
            return "\(baseURL)/gyms"
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
                    "gymHours": gymHours]
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
                    let gyms = try? JSONDecoder().decode([Gym].self, from: data)
                    let gym = try? JSONDecoder().decode(Gym.self, from: data)
                    completionHandler(gyms ?? gym, statusCode)
                }
            }
        }.resume()
    }
}
