//
//  File.swift
//  Fitness
//
//  Created by Cameron Hamidi on 3/21/19.
//  Copyright © 2019 Keivan Shahida. All rights reserved.
//

import Foundation

struct PersonalLink {
    enum SiteType {
        case facebook
        case instagram
        case linkedin
        case other
        case twitter
    }

    let site: SiteType
    let url: URL?

    init(url: URL?, site: SiteType) {
        self.url = url
        self.site = site
    }
}
