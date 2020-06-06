//
//  User.swift
//  Uplift
//
//  Created by Phillip OReggio on 3/21/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import Foundation

/// Stores result from Network request
struct GoogleTokens: Codable {
    let backendToken: String
    let expiration: String
    let refreshToken: String
}

class User: Codable {
    static var currentUser: User?

    let id: Int
    let name: String
    let netId: String
    var givenName: String?
    var familyName: String?
    var email: String?
    var tokens: GoogleTokens?

    init(id: Int, name: String, netId: String) {
        self.id = id
        self.name = name
        self.netId = netId
    }

    init(id: Int, name: String, netId: String, givenName: String, familyName: String, email: String) {
        self.id = id
        self.name = name
        self.netId = netId
        self.givenName = givenName
        self.familyName = familyName
        self.email = email
    }
}
