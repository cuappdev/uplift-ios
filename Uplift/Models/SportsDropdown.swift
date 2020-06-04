//
//  SportsDropdown.swift
//  Uplift
//
//  Created by Artesia Ko on 4/11/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import Foundation
import UIKit

enum Dropped {
    case up, half, down
}

class DropdownData {
    var completed: Bool!
    var dropStatus: DropdownStatus!
    var titles: [String]!

    init(completed: Bool, dropStatus: DropdownStatus, titles: [String]) {
        self.completed = completed
        self.dropStatus = dropStatus
        self.titles = titles
    }

}

struct GymNameId {
    var name: String!
    var id: String!
}
