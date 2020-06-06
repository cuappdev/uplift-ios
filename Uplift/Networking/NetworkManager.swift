//
//  NetworkManager.swift
//  Uplift
//
//  Created by Cornell AppDev on 4/24/18.
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

        AF.request(tokenURL, method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseData { response in
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

        AF.request(tokenURL, method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseData { response in
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

    // MARK: - Onboarding
    /// Retreives 4 Gym Names (combining both Teagles) and 4 Gym Classes from 4 different Tag categories
    /// to present during the Onboarding.
    func getOnboardingInfo(completion: @escaping ([String], [GymClassInstance]) -> Void) {
        var gyms: [String] = []
        var classes: [GymClassInstance] = []

        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        dispatchGroup.enter()

        NetworkManager.shared.getGymNames(
            completion: { gymInstances in
                var gymNames = Set<String>()
                gymInstances.forEach { instance in
                    if let name = instance.name {
                        if name == "Teagle Up" || name == "Teagle Down" {
                            gymNames.insert("Teagle")
                        } else {
                            gymNames.insert(name)
                        }
                    }
                }
                gyms = Array(gymNames).sorted()

                dispatchGroup.leave()
            },
            failure: { dispatchGroup.leave() }
        )

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        // Display 4 classes from different (random) tag categories
        NetworkManager.shared.getGymClassesForDate(date: dateFormatter.string(from: Date()),
            completion: { classInstances in
                // Less than 4 classes -> Use Hard coded defaults
                if classInstances.count < 4 {
                    dispatchGroup.leave()
                    return
                }

                NetworkManager.shared.getTags(
                    completion: { tags in
                        // Sample 4 tags without replacement
                        var randomIndices = Set<Int>()
                        while randomIndices.count < 4 {
                            let index = Int.random(in: 0..<tags.count)
                            randomIndices.insert(index)
                        }
                        // Tag categories to chose from
                        // Each time it picks a class, remove a tag from list
                        var tagSubset = randomIndices.map { tags[$0] }
                        // Iterate over unique classes that don't share the same name, Adding classes if it has a tag not yet displayed
                        for instance in classInstances {
                            if !classes.contains(where: { $0.className == instance.className }) {
                                for tag in instance.tags {
                                    if let index = tagSubset.index(of: tag) {
                                        tagSubset.remove(at: index)
                                        classes.append(instance)
                                        break
                                    }
                                }
                                // Chose 4 classes, can stop
                                if classes.count >= 4 { break }
                            }
                        }

                        classes = classes.sorted(by: { $0.className < $1.className })
                        dispatchGroup.leave()
                    },
                    failure: { dispatchGroup.leave() }
                )
            },
            failure: { dispatchGroup.leave() }
        )

        dispatchGroup.notify(queue: .main, execute: {
            completion(gyms, classes)
        })
    }

    // MARK: - GYMS
    func getGyms(completion: @escaping ([Gym]) -> Void) {
        apollo.fetch(query: AllGymsQuery()) { result, error in
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
        apollo.fetch(query: GymByIdQuery(gymId: id)) { result, error in
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

    func getGymNames(completion: @escaping ([GymNameId]) -> Void, failure: (() -> Void)? = nil) {
        apollo.fetch(query: AllGymNamesQuery()) { result, error in
            guard error == nil,
                let gymNamesData = result?.data?.gyms else {
                    failure?()
                    return
            }

            let gyms = gymNamesData.map({ GymNameId(name: $0?.name, id: $0?.id) })

            completion(gyms)
        }
    }

    func getGymClassesForDate(date: String, completion: @escaping ([GymClassInstance]) -> Void, failure: (() -> Void)? = nil) {
        apollo.fetch(query: TodaysClassesQuery(date: date)) { result, error in
            guard error == nil,
                let data = result?.data,
                let classes = data.classes else {
                    failure?()
                    return
            }
            let gymClassInstances = classes.compactMap({ self.getGymClassInstance(from: $0) })

            completion(gymClassInstances)
        }
    }

    // MARK: - GYM CLASS INSTANCES
    func getGymClassInstancesByClass(gymClassDetailIds: [String], completion: @escaping ([GymClassInstance]) -> Void) {
        apollo.fetch(query: ClassesByTypeQuery(classNames: gymClassDetailIds)) { result, error in
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
        apollo.fetch(query: TodaysClassesAtGymQuery(gymId: gymId, date: date)) { result, error in
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
    func getTags(completion: @escaping ([Tag]) -> Void, failure: (() -> Void)? = nil) {
        apollo.fetch(query: GetTagsQuery()) { results, error in
            guard error == nil,
                let data = results?.data,
                let classes = data.classes else {
                    failure?()
                    return
            }
            let allClasses = classes.compactMap { $0 }

            var allTags: [Tag] = []
            allClasses.forEach({ currClass in
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
        apollo.fetch(query: AllClassNamesQuery()) { result, error in
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
        let graphTags = gymClassData.details.tags.compactMap { $0 }
        let tags = graphTags.map { Tag(name: $0.label, imageURL: "") }

        return GymClassInstance(classDescription: classDescription, classDetailId: classDetailId, className: className, duration: end.timeIntervalSince(start), endTime: end, gymId: gymId, imageURL: imageUrl, instructor: instructor, isCancelled: isCancelled, location: location, startTime: start, tags: tags)
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
        let graphTags = gymClassData.details.tags.compactMap { $0 }
        let tags = graphTags.map { Tag(name: $0.label, imageURL: "") }

        return GymClassInstance(classDescription: classDescription, classDetailId: classDetailId, className: className, duration: end.timeIntervalSince(start), endTime: end, gymId: gymId, imageURL: imageUrl, instructor: instructor, isCancelled: isCancelled, location: location, startTime: start, tags: tags)
    }

    private func cacheImage(imageUrl: URL) {
        //Kingfisher will download the image and store it in the cache
        KingfisherManager.shared.retrieveImage(with: imageUrl, options: nil, progressBlock: nil, completionHandler: nil)
    }
}
