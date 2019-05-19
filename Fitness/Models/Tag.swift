//
//  Tag.swift
//  Fitness
//
//  Created by Cornell AppDev on 4/24/18.
//  Copyright © 2018 Uplift. All rights reserved.
//

import UIKit

struct Tag: Equatable {

    static func == (lhs: Tag, rhs: Tag) -> Bool {
        return lhs.name == rhs.name
    }

    let name: String
    let imageURL: String
}
