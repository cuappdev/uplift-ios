//
//  GymDetail.swift
//  Uplift
//
//  Created by Kevin Chan on 9/26/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import Foundation

struct GymDetail {

    let gym: Gym
    var hoursDataIsDropped: Bool

    init(gym: Gym) {
        self.gym = gym
        self.hoursDataIsDropped = false
    }

}
