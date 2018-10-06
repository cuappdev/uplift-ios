//
//  NetworkManager.swift
//  Fitness
//
//  Created by Keivan Shahida on 4/24/18.
//  Copyright © 2018 Keivan Shahida. All rights reserved.
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
                    gyms.append(Gym(gymData: gymData))
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
                self.cacheImage(imageUrl: imageUrl, isClassCancelled: gymClassData.isCancelled)
                let instructor = gymClassData.instructor
                let startTime = gymClassData.startTime ?? "12:00:00"
                let endTime = gymClassData.endTime ?? "12:00:00"
                let isCancelled = gymClassData.isCancelled
                let gymId = gymClassData.gymId ?? ""
                let location = gymClassData.location
                let classDescription = gymClassData.details.description
                let className = gymClassData.details.name
                let start = Date.convertTimeStringToDate(time: startTime)
                let end = Date.convertTimeStringToDate(time: endTime)
                let graphTags = gymClassData.details.tags.compactMap { $0 }
                let tags = graphTags.map { Tag(name: $0.label, imageURL: "") }

                let gymClass = GymClassInstance(classDescription: classDescription, className: className, instructor: instructor, startTime: start, endTime: end, gymId: gymId, duration: end.timeIntervalSince(start), location: location, imageURL: imageUrl, isCancelled: isCancelled, tags: tags)

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
                let className = gymClassData.details.name
                let start = Date.getDatetimeFromString(datetime: startTime)
                let end = Date.getDatetimeFromString(datetime: endTime)
                let graphTags = gymClassData.details.tags.compactMap { $0 }
                let tags = graphTags.map { Tag(name: $0.label, imageURL: "") }

                let gymClass = GymClassInstance(classDescription: classDescription, className: className, instructor: instructor, startTime: start, endTime: end, gymId: gymId, duration: end.timeIntervalSince(start), location: location, imageURL: imageUrl, isCancelled: isCancelled, tags: tags)

                gymClassInstances.append(gymClass)
            }
            completion(gymClassInstances)
        }

    }

    func getGymClassInstance(gymClassInstanceId: Int, completion: @escaping (GymClassInstance) -> Void) {

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
    //If class is cancelled, we want to apply saturation 0, else just store it in cache
    private func cacheImage(imageUrl: URL, isClassCancelled: Bool = false) {

        if isClassCancelled {
            //Check if cancelled class image with 0 saturation is in cahce
            if ImageCache.default.imageCachedType(forKey: "\(imageUrl.absoluteString)-cancelled").cached { return }

            //Get the normal image and apply saturation
            KingfisherManager.shared.retrieveImage(with: imageUrl, options: nil, progressBlock: nil) { downloadedImage, _, _, _ in
                guard let downloadedImage = downloadedImage else { return }
                self.applySaturation(to: downloadedImage, with: 0.0) { imageWithNoSaturation in

                    guard let noSaturationImage = imageWithNoSaturation else { return }

                    //Cache
                    ImageCache.default.store(noSaturationImage, forKey: "\(imageUrl.absoluteString)-cancelled")
                }
            }
        }

        //Class is not cancelled, just store it in cache
        KingfisherManager.shared.retrieveImage(with: imageUrl, options: nil, progressBlock: nil, completionHandler: nil)
    }

    private func applySaturation(to image: UIImage, with saturationLevel: CGFloat, completion: @escaping (UIImage?) -> Void) {
        let dispatchQueue = DispatchQueue(label: "SaturationZeroQueue", qos: .background)
        dispatchQueue.async {
            let modifyImage = CIImage(image: image)
            let filter = CIFilter(name: "CIColorControls")
            filter?.setValue(modifyImage, forKey: kCIInputImageKey)
            filter?.setValue(saturationLevel, forKey: kCIInputSaturationKey)
            guard let finalImage = filter?.outputImage else { completion(nil); return }
            completion(UIImage(ciImage: finalImage))
        }
    }
}
