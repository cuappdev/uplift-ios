//
//  File.swift
//  Fitness
//
//  Created by Cameron Hamidi on 3/21/19.
//  Copyright © 2019 Keivan Shahida. All rights reserved.
//

import Foundation

struct PersonalLinkObject {
    let url: URL
    let site: PersonalLink
    
    init(url: String, site: PersonalLink) {
        self.url = URL(string: url)!
        self.site = site
    }
}

enum PersonalLink {
    case facebook
    case linkedin
    case instagram
    case twitter
    case other
}
