//
//  File.swift
//  Fitness
//
//  Created by Cameron Hamidi on 3/21/19.
//  Copyright © 2019 Keivan Shahida. All rights reserved.
//

import Foundation

struct PersonalLink {
    enum PersonalLinkType {
        case facebook
        case instagram
        case linkedin
        case other
        case twitter
    }
    
    let site: PersonalLinkType
    let url: URL
    
    init(url: String, site: PersonalLinkType) {
        self.url = URL(string: url)!
        self.site = site
    }
}


