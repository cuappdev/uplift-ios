//
//  FacilityDropdown.swift
//  Uplift
//
//  Created by Kevin Chan on 12/4/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import Foundation

class FacilityDropdown {

    var facility: Facility
    var dropdownStatus: DropdownStatus

    init(facility: Facility, dropdownStatus: DropdownStatus) {
        self.facility = facility
        self.dropdownStatus = dropdownStatus
    }

}
