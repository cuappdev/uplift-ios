//
//  GymClassInstance.swift
//  Uplift
//
//  Created by Cornell AppDev on 4/22/18.
//  Copyright © 2018 Uplift. All rights reserved.
//
import Foundation

struct GymClassInstance {
    let classDescription: String
    let classDetailId: String
    let className: String
    let duration: Double
    let endTime: Date
    let gymId: String
    let imageURL: URL
    let instructor: String
    let isCancelled: Bool
    let location: String
    let startTime: Date
    let tags: [Tag]
}
