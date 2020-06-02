//
//  SportsDropdown.swift
//  Uplift
//
//  Created by Artesia Ko on 4/11/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import Foundation

enum Dropped {
    case up, half, down
}

struct DropdownData {
    var completed: Bool!
    var dropStatus: Dropped!
    var titles: [String]!
}

struct GymNameId {
    var name: String!
    var id: String!
}
