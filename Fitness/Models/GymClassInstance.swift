//
//  GymClassInstance.swift
//  Fitness
//
//  Created by Keivan Shahida on 4/22/18.
//  Copyright © 2018 Uplift. All rights reserved.
//
import Foundation

struct GymClassInstance {
    let classDescription: String
    let classDetailId: String
    let className: String
    let instructor: String
    let startTime: Date
    let endTime: Date
    let gymId: String
    let duration: Double
    let location: String
    let imageURL: URL
    let isCancelled: Bool
    let tags: [Tag]
}
