//
//  NetworkManager.swift
//  Fitness
//
//  Created by Keivan Shahida on 4/24/18.
//  Copyright © 2018 Uplift. All rights reserved.
//

import Alamofire
import Apollo
import Foundation
import Kingfisher

enum APIEnvironment {
    case development
    case production
}

struct NetworkManager {
    private let apollo = ApolloClient(url: URL(string: Keys.apiURL.value)!)
    static let environment: APIEnvironment = .development
    static let shared = NetworkManager()

    // MARK: - Google
    func sendGoogleLoginToken(token: String, completion: @escaping (GoogleTokens) -> Void) {
        let tokenURL = "\(Keys.apiURL.value!)/login/"
        let parameters: [String: Any] = [
            "token": token
        ]

        Alamofire.request(tokenURL, method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseData{ (response) in
            switch response.result {
            case .success(let data):
                let decoder = JSONDecoder()
                if let tokenResults = try? decoder.decode(GoogleTokens.self, from: data) {
                    User.currentUser?.tokens = tokenResults
                    completion(tokenResults)
                }
            case .failure(let error):
                print("ERROR~~~:")
                print(error.localizedDescription)
            }
        }
    }

    func refreshGoogleToken(token: String, completion: @escaping (GoogleTokens) -> Void) {
        let tokenURL = "http://uplift-backend.cornellappdev.com/session/"
        let parameters: [String: Any] = [
            "bearer_token": token
        ]

        Alamofire.request(tokenURL, method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseData{ (response) in
            switch response.result {
            case .success(let data):
                let decoder = JSONDecoder()
                if let tokenResults = try? decoder.decode(GoogleTokens.self, from: data) {
                    User.currentUser?.tokens = tokenResults
                    completion(tokenResults)
                }
            case .failure(let error):
                print("ERROR~~~:")
                print(error.localizedDescription)
            }
        }
    }

    // MARK: - GYMS
    func getGyms(completion: @escaping ([Gym]) -> Void) {
        apollo.fetch(query: AllGymsQuery()) { (result, error) in
            guard error == nil,
                let gymsData = result?.data?.gyms else { return }

            let gyms = gymsData.compactMap({ (gymData) -> Gym? in
                guard let gymData = gymData else { return nil }
                let gym = Gym(gymData: gymData)
                if let imageUrl = gym.imageURL {
                    self.cacheImage(imageUrl: imageUrl)
                }
                return gym
            })

            completion(gyms)
        }
    }
    
    func getGym(id: String, completion: @escaping (Gym) -> Void) {
        apollo.fetch(query: GymByIdQuery(gymId: id)) { (result, error) in
            guard error == nil,
                let gymsData = result?.data?.gyms,
                let gymData = gymsData[0] else { return }
            let gym = Gym(gymData: gymData)
            if let imageUrl = gym.imageURL {
                self.cacheImage(imageUrl: imageUrl)
            }

            completion(gym)
        }
    }

    func getGymNames(completion: @escaping ([GymNameId]) -> Void) {
        apollo.fetch(query: AllGymsQuery()) { (result, error) in
            guard error == nil,
                let gymsData = result?.data?.gyms else { return }
            let gyms = gymsData.map({ GymNameId(name: $0?.name, id: $0?.id) })

            completion(gyms)
        }
    }

    func getGymClassesForDate(date: String, completion: @escaping ([GymClassInstance]) -> Void) {
        apollo.fetch(query: TodaysClassesQuery(date: date)) { result, error in
            guard error == nil,
                let data = result?.data,
                let classes = data.classes else { return }
            let gymClassInstances = classes.compactMap({ self.getGymClassInstance(from: $0) })

            completion(gymClassInstances)
        }
    }

    // MARK: - GYM CLASS INSTANCES
    func getGymClassInstancesByClass(gymClassDetailIds: [String], completion: @escaping ([GymClassInstance]) -> Void) {
        apollo.fetch(query: ClassesByTypeQuery(classNames: gymClassDetailIds)) { (result, error) in
            guard error == nil,
                let data = result?.data,
                let classes = data.classes else { return }
            var gymClassInstances = classes.compactMap({ self.getGymClassInstance(from: $0) })
            let now = Date()
            gymClassInstances = gymClassInstances.filter {$0.startTime > now}
            gymClassInstances.sort {$0.startTime < $1.startTime}

            completion(gymClassInstances)
        }
    }

    func getClassInstancesByGym(gymId: String, date: String, completion: @escaping([GymClassInstance]) -> Void) {
        apollo.fetch(query: TodaysClassesAtGymQuery(gymId: gymId, date: date)) { (result, error) in
            guard error == nil,
                let data = result?.data,
                let classes = data.classes else { return }
            var gymClassInstances = classes.compactMap({ self.getGymClassInstance(from: $0) })
            let now = Date()
            gymClassInstances = gymClassInstances.filter {$0.startTime > now}
            gymClassInstances.sort {$0.startTime < $1.startTime}

            completion(gymClassInstances)
        }
    }

    // MARK: - TAGS
    func getTags(completion: @escaping ([Tag]) -> Void) {
        apollo.fetch(query: GetTagsQuery()) { (results, error) in
            guard error == nil,
                let data = results?.data,
                let classes = data.classes else { return }
            let allClasses = classes.compactMap { $0 }

            var allTags: [Tag] = []
            allClasses.forEach({ (currClass) in
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
            })
            completion(allTags)
        }

    }

    // MARK: - GYM CLASSES
    func getClassNames(completion: @escaping (Set<String>) -> Void) {
        apollo.fetch(query: AllClassNamesQuery()) { (result, error) in
            guard error == nil,
                let gymClasses = result?.data?.classes else { return }

            var classNames: Set<String> = []
            let allGymClasses = gymClasses.compactMap { $0 }
            allGymClasses.forEach({ classNames.insert($0.details.name) })

            completion(classNames)
        }
    }

    // MARK: - INSTRUCTORS
    func getInstructors(completion: @escaping ([String]) -> Void) {
        apollo.fetch(query: GetInstructorsQuery()) { result, error in
            guard error == nil,
                let data = result?.data,
                let classes = data.classes else { return }

            var instructors: Set<String> = Set() // so as to return DISTINCT instructors
            classes.forEach({ (gymClass) in
                if let instructor = gymClass?.instructor {
                    instructors.insert(instructor)
                }
            })
            completion(Array(instructors))
        }
    }

    // MARK: - Private Helpers
    private func getGymClassInstance(from gymClassData: TodaysClassesQuery.Data.Class?) -> GymClassInstance? {
        guard let gymClassData = gymClassData,
            let startTime = gymClassData.startTime,
            let endTime = gymClassData.endTime,
            let gymId = gymClassData.gymId,
            let imageUrl = URL(string: gymClassData.imageUrl) else { return nil }

        let instructor = gymClassData.instructor
        let isCancelled = gymClassData.isCancelled
        let location = gymClassData.location
        let classDescription = gymClassData.details.description
        let classId = gymClassData.details.id
        let className = gymClassData.details.name
        let date = gymClassData.date
        let start = Date.getDatetimeFromStrings(dateString: date, timeString: startTime)
        let end = Date.getDatetimeFromStrings(dateString: date, timeString: endTime)
        let graphTags = gymClassData.details.tags.compactMap { $0 }
        let tags = graphTags.map { Tag(name: $0.label, imageURL: "") }

        return GymClassInstance(classDescription: classDescription, classDetailId: classId, className: className, duration: end.timeIntervalSince(start), endTime: end, gymId: gymId, imageURL: imageUrl, instructor: instructor, isCancelled: isCancelled, location: location, startTime: start, tags: tags)
    }

    private func getGymClassInstance(from gymClassData: ClassesByTypeQuery.Data.Class?) -> GymClassInstance? {
        guard let gymClassData = gymClassData,
            let imageUrl = URL(string: gymClassData.imageUrl),
            let startTime = gymClassData.startTime,
            let endTime = gymClassData.endTime,
            let gymId = gymClassData.gymId else { return nil }

        let instructor = gymClassData.instructor
        let date = gymClassData.date
        let isCancelled = gymClassData.isCancelled
        let location = gymClassData.location
        let classDescription = gymClassData.details.description
        let classDetailId = gymClassData.details.id
        let className = gymClassData.details.name
        let start = Date.getDatetimeFromStrings(dateString: date, timeString: startTime)
        let end = Date.getDatetimeFromStrings(dateString: date, timeString: endTime)
        return GymClassInstance(classDescription: classDescription, classDetailId: classDetailId, className: className, duration: end.timeIntervalSince(start), endTime: end, gymId: gymId, imageURL: imageUrl, instructor: instructor, isCancelled: isCancelled, location: location, startTime: start, tags: [])
    }

    private func getGymClassInstance(from gymClassData: TodaysClassesAtGymQuery.Data.Class?) -> GymClassInstance? {
        guard let gymClassData = gymClassData,
            let imageUrl = URL(string: gymClassData.imageUrl),
            let startTime = gymClassData.startTime,
            let endTime = gymClassData.endTime,
            let gymId = gymClassData.gymId else { return nil }

        let instructor = gymClassData.instructor
        let date = gymClassData.date
        let isCancelled = gymClassData.isCancelled
        let location = gymClassData.location
        let classDescription = gymClassData.details.description
        let classDetailId = gymClassData.details.id
        let className = gymClassData.details.name
        let start = Date.getDatetimeFromStrings(dateString: date, timeString: startTime)
        let end = Date.getDatetimeFromStrings(dateString: date, timeString: endTime)

        return GymClassInstance(classDescription: classDescription, classDetailId: classDetailId, className: className, duration: end.timeIntervalSince(start), endTime: end, gymId: gymId, imageURL: imageUrl, instructor: instructor, isCancelled: isCancelled, location: location, startTime: start, tags: [])
    }

    private func cacheImage(imageUrl: URL) {
        //Kingfisher will download the image and store it in the cache
        KingfisherManager.shared.retrieveImage(with: imageUrl, options: nil, progressBlock: nil, completionHandler: nil)
    }
}
