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
    let url: URL?
    
    init(url: URL?, site: PersonalLinkType) {
        self.url = url
        self.site = site
    }
}


