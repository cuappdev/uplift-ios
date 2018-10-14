//
//  NetworkManager.swift
//  Fitness
//
//  Created by Keivan Shahida on 4/24/18.
//  Copyright © 2018 Uplift. All rights reserved.
//

import Foundation
import Apollo
import Kingfisher

enum APIEnvironment {
    case development
    case production
}

struct NetworkManager {
    internal let apollo = ApolloClient(url: URL(string: "http://uplift-backend.cornellappdev.com")!)
    static let environment: APIEnvironment = .development
    static let shared = NetworkManager()

    // MARK: - GYMS
    func getGyms(completion: @escaping ([Gym]) -> Void) {
        apollo.fetch(query: AllGymsQuery()) { (result, error) in
            var gyms: [Gym] = []

            for gymData in result?.data?.gyms ?? [] {
                if let gymData = gymData {
                    let gym = Gym(gymData: gymData)
                    gyms.append(gym)
                    if let imageUrl = gym.imageURL {
                        self.cacheImage(imageUrl: imageUrl)
                    }
                }
            }
            completion(gyms)
        }
    }

    func getGymNames(completion: @escaping ([GymNameId]) -> Void) {
        apollo.fetch(query: AllGymsQuery()) { (result, error) in
            // implement
            var gyms: [GymNameId] = []

            for gym in result?.data?.gyms ?? [] {
                guard let gym = gym else {
                    continue
                }

                gyms.append(GymNameId(name: gym.name, id: gym.id))
            }

            completion(gyms)
        }
    }

    func getGym(gymId: String, completion: @escaping (Gym) -> Void) {
    }

    func getGymClassesForDate(date: String, completion: @escaping ([GymClassInstance]) -> Void) {
        apollo.fetch(query: TodaysClassesQuery(date: date)) { result, error in
            guard let data = result?.data, let classes = data.classes else { return }
            var gymClassInstances: [GymClassInstance] = []
            for gymClassData in classes {
                guard let gymClassData = gymClassData, let imageUrl = URL(string: gymClassData.imageUrl) else { continue }
                self.cacheImage(imageUrl: imageUrl)
                let instructor = gymClassData.instructor
                let startTime = gymClassData.startTime ?? "12:00:00"
                let endTime = gymClassData.endTime ?? "12:00:00"
                let isCancelled = gymClassData.isCancelled
                let gymId = gymClassData.gymId ?? ""
                let location = gymClassData.location
                let classDescription = gymClassData.details.description
                let classId = gymClassData.details.id
                let className = gymClassData.details.name
                let start = Date.convertTimeStringToDate(time: startTime)
                let end = Date.convertTimeStringToDate(time: endTime)
                let graphTags = gymClassData.details.tags.compactMap { $0 }
                let tags = graphTags.map { Tag(name: $0.label, imageURL: "") }

                let gymClass = GymClassInstance(classDescription: classDescription, classDetailId: classId, className: className, instructor: instructor, startTime: start, endTime: end, gymId: gymId, duration: end.timeIntervalSince(start), location: location, imageURL: imageUrl, isCancelled: isCancelled, tags: tags)

                gymClassInstances.append(gymClass)
            }
            completion(gymClassInstances)
        }
    }

    // MARK: - GYM CLASS INSTANCES
    func getGymClassInstances(completion: @escaping ([GymClassInstance]) -> Void) {
        apollo.fetch(query: AllClassesInstancesQuery()) { result, error in
            guard let data = result?.data, let classes = data.classes else { return }
            var gymClassInstances: [GymClassInstance] = []
            for gymClassData in classes {
                guard let gymClassData = gymClassData, let imageUrl = URL(string: gymClassData.imageUrl) else { continue }
                let instructor = gymClassData.instructor
                let startTime = gymClassData.startTime ?? ""
                let endTime = gymClassData.endTime ?? ""
                let isCancelled = gymClassData.isCancelled
                let gymId = gymClassData.gymId ?? ""
                let location = gymClassData.gym?.name ?? ""
                let classDescription = gymClassData.details.description
                let classDetailId = gymClassData.details.id
                let className = gymClassData.details.name
                let start = Date.getDatetimeFromString(datetime: startTime)
                let end = Date.getDatetimeFromString(datetime: endTime)
                let graphTags = gymClassData.details.tags.compactMap { $0 }
                let tags = graphTags.map { Tag(name: $0.label, imageURL: "") }

                let gymClass = GymClassInstance(classDescription: classDescription, classDetailId: classDetailId, className: className, instructor: instructor, startTime: start, endTime: end, gymId: gymId, duration: end.timeIntervalSince(start), location: location, imageURL: imageUrl, isCancelled: isCancelled, tags: tags)

                gymClassInstances.append(gymClass)
            }
            completion(gymClassInstances)
        }

    }

    func getGymClassInstance(gymClassInstanceId: Int, completion: @escaping (GymClassInstance) -> Void) {

    }
    
    func getGymClassInstances(gymClassDetailIds: [String], completion: @escaping ([GymClassInstance]) -> Void) {
        apollo.fetch(query: ClassesByTypeQuery(classNames: gymClassDetailIds)) { (result,error) in
            guard let data = result?.data, let classes = data.classes else { return }
            var gymClassInstances: [GymClassInstance] = []
            
            for gymClassData in classes {
                guard let gymClassData = gymClassData, let imageUrl = URL(string: gymClassData.imageUrl) else { continue }
                let instructor = gymClassData.instructor
                let startTime = gymClassData.startTime ?? ""
                let endTime = gymClassData.endTime ?? ""
                let isCancelled = gymClassData.isCancelled
                let gymId = gymClassData.gymId ?? ""
                let location = gymClassData.location
                let classDescription = gymClassData.details.description
                let classDetailId = gymClassData.details.id
                let className = gymClassData.details.name
                let start = Date.getDatetimeFromString(datetime: startTime)
                let end = Date.getDatetimeFromString(datetime: endTime)
                
                let gymClass = GymClassInstance(classDescription: classDescription, classDetailId: classDetailId, className: className, instructor: instructor, startTime: start, endTime: end, gymId: gymId, duration: end.timeIntervalSince(start), location: location, imageURL: imageUrl, isCancelled: isCancelled, tags: [])
                
                gymClassInstances.append(gymClass)
            }
            completion(gymClassInstances)
        }
    }

    func getGymClassInstancesSearch(startTime: String, endTime: String, instructorIDs: [String], gymIDs: [String], classNames: [String], completion: @escaping ([GymClassInstance]) -> Void) {

    }

    // MARK: - GYM CLASS DESCRIPTIONS
    func getGymClassDescriptions(completion: @escaping ([GymClassDescription]) -> Void) {
    }

    func getGymClassDescription(gymClassDescriptionId: Int, completion: @escaping (GymClassDescription) -> Void) {

    }

    func getGymClassDescriptionsByTag(tag: Int, completion: @escaping ([GymClassDescription]) -> Void) {

    }

    // MARK: - TAGS
    func getTags(completion: @escaping ([Tag]) -> Void) {
        apollo.fetch(query: GetTagsQuery()) { (results, error) in
            guard let data = results?.data, let classes = data.classes else { return }
            let allClasses = classes.compactMap { $0 }

            var allTags: [Tag] = []
            for currClass in allClasses {
                let currTags = currClass.details.tags.compactMap { $0 }

                currTags.forEach { tag in
                    let currTag = Tag(name: tag.label, imageURL: tag.imageUrl)
                    if !allTags.contains(currTag) {
                        allTags.append(currTag)
                    }
                    if let imageURL = URL(string: currTag.imageURL) {
                        self.cacheImage(imageUrl: imageURL)
                    }
                }
            }
            completion(allTags)
        }

    }

    // MARK: - GYM CLASSES
    func getGymClasses(completion: @escaping ([GymClass]) -> Void) {
    }

    func getClassNames(completion: @escaping (Set<String>) -> Void) {
        apollo.fetch(query: AllClassNamesQuery()) { (result, error) in
            var classNames: Set<String> = []
            guard let gymClasses = result?.data?.classes else { return }

            let allGymClasses = gymClasses.compactMap { $0 }

            for gymClass in allGymClasses {
                classNames.insert(gymClass.details.name)
            }

            completion(classNames)
        }
    }

    func getGymClass(gymClassId: Int, completion: @escaping (GymClass) -> Void) {
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

    // MARK: - Image Caching
    private func cacheImage(imageUrl: URL) {
        //Kingfisher will download the image and store it in the cache
        KingfisherManager.shared.retrieveImage(with: imageUrl, options: nil, progressBlock: nil, completionHandler: nil)
    }
}
