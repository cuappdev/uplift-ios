//
//  Post.swift
//  Uplift
//
//  Created by Cameron Hamidi on 2/12/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import Foundation

struct Post: Codable {
    static let maxPlayers = 10

    let comment: [Comment]
    let createdAt: Date
    let id: Int
    let userId: Int

    let title: String
    let time: Date
    let type: String
    let location: String
    let players: [User]
    let gameStatus: String
    
    func getTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm a"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        return formatter.string(from: time)
    }
    
    func getDay() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd"
        return formatter.string(from: time)
    }
    
    func getPlayersListString() -> String {
        return players.reduce("", { (result: String, p: User) -> String in
            return result + p.name + "\n"
        })
    }

}
