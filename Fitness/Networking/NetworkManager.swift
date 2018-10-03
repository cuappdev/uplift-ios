//
//  NetworkManager.swift
//  Fitness
//
//  Created by Keivan Shahida on 4/24/18.
//  Copyright © 2018 Keivan Shahida. All rights reserved.
//

import Foundation
import Apollo

enum APIEnvironment {
    case development
    case production
}

struct NetworkManager {
    internal let apollo = ApolloClient(url: URL(string: "http://uplift-backend.cornellappdev.com")!)
    static let environment: APIEnvironment = .development

    // MARK: - GYMS
    func getGyms(completion: @escaping ([Gym]) -> Void) {
        apollo.fetch(query: AllGymsQuery()){ (result, error) in
            var gyms: [Gym] = []
        
            for gymData in result?.data?.gyms ?? [] {
                if let gymData = gymData {
                    gyms.append(Gym(gymData: gymData))
                }
            }
            completion(gyms)
        }
    }
    
    func getGymNames(completion: @escaping ([GymNameId]) -> Void) {
        apollo.fetch(query: AllGymsQuery()){ (result, error) in
            // implement
            var gyms: [GymNameId] = []
            
            for gym in result?.data?.gyms ?? [] {
                guard let gym = gym else {
                    continue
                }
                
                gyms.append(GymNameId(name: gym.name ?? "", id: gym.id ?? "") )
            }
            
            completion(gyms)
        }
    }

    func getGym(gymId: String, completion: @escaping (Gym) -> Void) {
//        provider.request(.gym(gymId: gymId)) { result in
//            switch result {
//            case let .success(response):
//                do {
//                    let gymData = try JSONDecoder().decode(GymRootData.self, from: response.data)
//                    let gym = gymData.data
//                    completion(gym)
//                } catch let err {
//                    print(err)
//                }
//            case let .failure(error):
//                print(error)
//            }
//        }
    }


    // MARK: - GYM CLASS INSTANCES
    func getGymClassInstances(completion: @escaping ([GymClassInstance]) -> Void) {
        apollo.fetch(query: AllClassesInstancesQuery()) { result, error in
            guard let data = result?.data, let classes = data.classes else { return }
            var gymClassInstances: [GymClassInstance] = []
            for gymClassData in classes {
                guard let gymClassData = gymClassData else { continue }
                if let gymClassInstance = GymClassInstance(gymClassData: gymClassData) {
                    gymClassInstances.append(gymClassInstance)
                }
            }
            completion(gymClassInstances)
        }

    }

    func getGymClassInstance(gymClassInstanceId: Int, completion: @escaping (GymClassInstance) -> Void) {
//        provider.request(.gymClassInstance(gymClassInstanceId: gymClassInstanceId)) { result in
//            switch result {
//            case let .success(response):
//                do {
//                    let gymClassInstanceData = try JSONDecoder().decode(GymClassInstanceRootData.self, from: response.data)
//                    let gymClassInstance = gymClassInstanceData.data
//                    completion(gymClassInstance)
//                } catch let err {
//                    print(err)
//                }
//            case let .failure(error):
//                print(error)
//            }
//        }
    }

    func getGymClassInstancesByDate(date: String, completion: @escaping ([GymClassInstance]) -> Void) {
//        provider.request(.gymClassInstancesByDate(date: date)) { result in
//            switch result {
//            case let .success(response):
//                do {
//                    let gymClassInstancesData = try JSONDecoder().decode(GymClassInstancesRootData.self, from: response.data)
//                    let gymClassInstances = gymClassInstancesData.data
//                    completion(gymClassInstances)
//                } catch let err {
//                    print(err)
//                }
//            case let .failure(error):
//                print(error)
//            }
//        }
        apollo.fetch(query: TodaysClassesQuery(dateTime: date)) { result, error in
            print(error)
            guard let data = result?.data else { return }
            var gymClassInstances: [GymClassInstance] = []
            for gymClass in data.classes ?? [] {
                if let gymClassInstance = GymClassInstance(gymClassData: gymClass as! AllClassesInstancesQuery.Data.Class) {
                    gymClassInstances.append(gymClassInstance)
                }
            }
            completion(gymClassInstances)
        }
    }

    func getGymClassInstancesSearch(startTime: String, endTime: String, instructorIDs: [String], gymIDs: [String], classNames: [String], completion: @escaping ([GymClassInstance]) -> Void) {
//        provider.request(.gymClassInstancesSearch(startTime: startTime, endTime: endTime, instructorIDs: instructorIDs, gymIDs: gymIDs, classDescriptionIDs: classDescriptionIDs)) { result in
//            switch result {
//            case let .success(response):
//                do {
//                    let gymClassInstancesData = try JSONDecoder().decode(GymClassInstancesRootData.self, from: response.data)
//                    let gymClassInstances = gymClassInstancesData.data
//
//                    completion(gymClassInstances)
//
//                } catch let err {
//                    print(err)
//                }
//            case let .failure(error):
//                print(error)
//            }
//        }
    }

    // MARK: - GYM CLASS DESCRIPTIONS
    func getGymClassDescriptions(completion: @escaping ([GymClassDescription])->Void) {
//        provider.request(.gymClassDescriptions) { result in
//            switch result {
//            case let .success(response):
//                do {
//                    let gymClassDescriptionsData = try JSONDecoder().decode(GymClassDescriptionsRootData.self, from: response.data)
//                    let gymClassDescriptions = gymClassDescriptionsData.data
//                    completion(gymClassDescriptions)
//                } catch let err {
//                    print(err)
//                }
//            case let .failure(error):
//                print(error)
//            }
//        }
    }

    func getGymClassDescription(gymClassDescriptionId: Int, completion: @escaping (GymClassDescription) -> Void) {
//        provider.request(.gymClassDescription(gymClassDescriptionId: gymClassDescriptionId)) { result in
//            switch result {
//            case let .success(response):
//                do {
//                    let gymClassDescriptionData = try JSONDecoder().decode(GymClassDescriptionRootData.self, from: response.data)
//                    let gymClassDescription = gymClassDescriptionData.data
//                    completion(gymClassDescription)
//                } catch let err {
//                    print(err)
//                }
//            case let .failure(error):
//                print(error)
//            }
//        }
    }

    func getGymClassDescriptionsByTag(tag: Int, completion: @escaping ([GymClassDescription]) -> Void) {
//        provider.request(.gymClassDescriptionsByTag(tag: tag)) { result in
//            switch result {
//            case let .success(response):
//                do {
//                    let gymClassDescriptionsData = try JSONDecoder().decode(GymClassDescriptionsRootData.self, from: response.data)
//                    let gymClassDescriptions = gymClassDescriptionsData.data
//                    completion(gymClassDescriptions)
//                } catch let err {
//                    print(err)
//                }
//            case let .failure(error):
//                print(error)
//            }
//        }
    }

    // MARK: - TAGS
    func getTags(completion: @escaping ([Tag]) -> Void) {
//        provider.request(.tags) { result in
//            switch result {
//            case let .success(response):
//                do {
//                    let tagsData = try JSONDecoder().decode(TagsRootData.self, from: response.data)
//                    let tags = tagsData.data
//                    completion(tags)
//                } catch let err {
//                    print(err)
//                }
//            case let .failure(error):
//                print(error)
//            }
//        }
    }

    // MARK: - GYM CLASSES
    func getGymClasses(completion: @escaping ([GymClass]) -> Void) {
//        provider.request(.gymClasses) { result in
//            switch result {
//            case let .success(response):
//                do {
//                    let gymClassesData = try JSONDecoder().decode(GymClassesRootData.self, from: response.data)
//                    let gymClasses = gymClassesData.data
//                    completion(gymClasses)
//                } catch let err {
//                    print(err)
//                }
//            case let .failure(error):
//                print(error)
//            }
//        }
    }
    
    func getClassNames(completion: @escaping (Set<String>) -> Void) {
        apollo.fetch(query: AllClassNamesQuery()) { (result, error) in
            var classNames: Set<String> = []
            
            for gymClass in result?.data?.classes ?? [] {
                classNames.insert(gymClass?.details?.name ?? "")
            }
            
            completion(classNames)
        }
    }

    func getGymClass(gymClassId: Int, completion: @escaping (GymClass) -> Void) {
//        provider.request(.gymClass(gymClassId: gymClassId)) { result in
//            switch result {
//            case let .success(response):
//                do {
//                    let gymClassData = try JSONDecoder().decode(GymClassRootData.self, from: response.data)
//                    let gymClass = gymClassData.data
//                    completion(gymClass)
//                } catch let err {
//                    print(err)
//                }
//            case let .failure(error):
//                print(error)
//            }
//        }
    }
    
    // MARK: - INSTRUCTORS
    func getInstructors(completion: @escaping ([String]) -> Void) {
        apollo.fetch(query: GetInstructorsQuery()) { result, error in
            guard let data = result?.data else { return }
            
            var instructors: Set<String> = Set() // so as to return DISTINCT instructors
            for gymClass in data.classes ?? [] {
                if let instructor = gymClass?.instructor {
                    instructors.insert(instructor)
                }
            }
            completion(Array(instructors))
        }
    }
}
