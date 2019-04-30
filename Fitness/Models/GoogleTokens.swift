//
//  GoogleTokens.swift
//  Fitness
//
//  Created by Phillip OReggio on 4/14/19.
//  Copyright © 2019 Keivan Shahida. All rights reserved.
//

import Foundation

/// Stores tokens throughout use of app
class UserGoogleTokens {
    static var backendToken: String = ""
    static var expiration: String = ""
    static var refreshToken: String = ""
}

/// Stores result from Network request
struct GoogleTokens: Codable {
    let backendToken: String
    let expiration: String
    let refreshToken: String
}


