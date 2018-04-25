//
//  NetworkManager.swift
//  Fitness
//
//  Created by Keivan Shahida on 4/24/18.
//  Copyright © 2018 Keivan Shahida. All rights reserved.
//

import Foundation
import Moya

enum APIEnvironment {
    case development
    case production
}

protocol Networkable {
    var provider: MoyaProvider<FitnessAPI> { get }
    func getGyms(completion: @escaping ([Gym]) -> ())
}

struct NetworkManager: Networkable {
    internal let provider = MoyaProvider<FitnessAPI>(plugins: [NetworkLoggerPlugin(verbose: true)])
    static let environment: APIEnvironment = .development
    
    
    //MARK: - GYMS
    func getGyms(completion: @escaping ([Gym])->()) {
        provider.request(.gyms) { result in
            switch result {
            case let .success(response):
                do {
                    let gymData = try JSONDecoder().decode(GymsRootData.self, from: response.data)
                    let gyms = gymData.data
                    completion(gyms)
                } catch let err {
                    print(err)
                }
            case let .failure(error):
                print(error)
            }
        }
    }
    
    func getGym(gymId: Int, completion: @escaping (Gym)->()) {
        provider.request(.gym(gymId: gymId)) { result in
            switch result {
            case let .success(response):
                do {
                    let gymData = try JSONDecoder().decode(GymRootData.self, from: response.data)
                    let gym = gymData.data
                    completion(gym)
                } catch let err {
                    print(err)
                }
            case let .failure(error):
                print(error)
            }
        }
    }
    
    //MARK: - GYM CLASS INSTANCES
    func getGymClassInstances(completion: @escaping ([GymClassInstance])->()){
        provider.request(.gymClassInstances) { result in
            switch result {
            case let .success(response):
                do {
                    let gymClassInstancesData = try JSONDecoder().decode(GymClassInstancesRootData.self, from: response.data)
                    let gymClassInstances = gymClassInstancesData.data
                    completion(gymClassInstances)
                } catch let err {
                    print(err)
                }
            case let .failure(error):
                print(error)
            }
        }
    }
    
    func getGymClassInstance(gymClassInstanceId: Int, completion: @escaping (GymClassInstance)->()) {
        provider.request(.gymClassInstance(gymClassInstanceId: gymClassInstanceId)) { result in
            switch result {
            case let .success(response):
                do {
                    let gymClassInstanceData = try JSONDecoder().decode(GymClassInstanceRootData.self, from: response.data)
                    let gymClassInstance = gymClassInstanceData.data
                    completion(gymClassInstance)
                } catch let err {
                    print(err)
                }
            case let .failure(error):
                print(error)
            }
        }
    }
    
    func getGymClassInstancesPaginated(page: Int, pageSize: Int, completion: @escaping ([GymClassInstance])->()) {
        provider.request(.gymClassInstancesPaginated(page: page, pageSize: pageSize)) { result in
            switch result {
            case let .success(response):
                do {
                    let gymClassInstancesData = try JSONDecoder().decode(GymClassInstancesRootData.self, from: response.data)
                    let gymClassInstances = gymClassInstancesData.data
                    completion(gymClassInstances)
                } catch let err {
                    print(err)
                }
            case let .failure(error):
                print(error)
            }
        }
    }
    
    func getGymClassInstancesByDate(date: String, completion: @escaping ([GymClassInstance])->()) {
        provider.request(.gymClassInstancesByDate(date: date)) { result in
            switch result {
            case let .success(response):
                do {
                    let gymClassInstancesData = try JSONDecoder().decode(GymClassInstancesRootData.self, from: response.data)
                    let gymClassInstances = gymClassInstancesData.data
                    completion(gymClassInstances)
                } catch let err {
                    print(err)
                }
            case let .failure(error):
                print(error)
            }
        }
    }
    
    
    
    
}

