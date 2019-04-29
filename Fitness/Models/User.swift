//
//  User.swift
//  Fitness
//
//  Created by Phillip OReggio on 3/21/19.
//  Copyright © 2019 Keivan Shahida. All rights reserved.
//

import Foundation

class User: Codable {
    static var currentUser: User?
    
    var id: String
    var name: String
    var netId: String
    var givenName: String?
    var familyName: String?
    var email: String?
    
    init(id: String, name: String, netId: String) {
        self.id = id
        self.name = name
        self.netId = netId
    }
    
    init(id: String, name: String, netId: String, givenName: String, familyName: String, email: String) {
        self.id = id
        self.name = name
        self.netId = netId
        self.givenName = givenName
        self.familyName = familyName
        self.email = email
    }
}
