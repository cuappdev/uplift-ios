//
//  Post.swift
//  Uplift
//
//  Created by Cameron Hamidi on 2/12/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import Foundation

struct Post: Codable {
    static let minPlayers = 2
    static let maxPlayers = 10

    let comment: [Comment]
    let createdAt: Date
    let gameStatus: String
    let id: Int
    let location: String
    let players: Int
    let time: Date
    let title: String
    let type: String
    let userId: Int

    func getPlayersListString() -> String {
//        return players.reduce("", { (result: String, p: User) -> String in
//            return result + p.name + "\n"
//        })
        return "" // TODO: Fix this once backend is integrated properly
    }

}
