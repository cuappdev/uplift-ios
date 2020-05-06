//
//  Post.swift
//  Uplift
//
//  Created by Cameron Hamidi on 2/12/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import Foundation

struct Post: Codable {
    let comment: [Comment]
    let createdAt: Date
    let gameStatus: String
    let id: Int
    let location: String
    let players: Int
    let time: String
    let title: String
    let type: String
    let userId: Int
}
