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

    func getGym(gymId: Int, completion: @escaping (Gym) -> Void) {
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
//        provider.request(.gymClassInstances) { result in
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
    }

    func getGymClassInstancesSearch(startTime: String, endTime: String, instructorIDs: [Int], gymIDs: [Int], classDescriptionIDs: [Int], completion: @escaping ([GymClassInstance]) -> Void) {
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
    func getInstructors(completion: @escaping ([Instructor]) -> Void) {
//        provider.request(.instructors) { result in
//            switch result {
//            case let .success(response):
//                do {
//                    let instructorsData = try JSONDecoder().decode(InstructorsRootData.self, from: response.data)
//                    let instructors = instructorsData.data
//                    completion(instructors)
//                } catch let err {
//                    print(err)
//                }
//            case let .failure(error):
//                print(error)
//            }
//        }
    }

    func getInstructor(instructorId: Int, completion: @escaping (Instructor) -> Void) {
//        provider.request(.instructor(instructorId: instructorId)) { result in
//            switch result {
//            case let .success(response):
//                do {
//                    let instructorData = try JSONDecoder().decode(InstructorRootData.self, from: response.data)
//                    let instructor = instructorData.data
//                    completion(instructor)
//                } catch let err {
//                    print(err)
//                }
//            case let .failure(error):
//                print(error)
//            }
//        }
    }
}
