//
//  WeekDay.swift
//  Uplift
//
//  Created by Phillip OReggio on 10/12/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

enum WeekDay: Int, CaseIterable {

    case sunday = 1
    case monday = 2
    case tuesday = 3
    case wednesday = 4
    case thursday = 5
    case friday = 6
    case saturday = 7

    var dayAbbreviation: String {
        switch self {
        case .sunday:       return "Su"
        case .monday:       return "M"
        case .tuesday:      return "T"
        case .wednesday:    return "W"
        case .thursday:     return "Th"
        case .friday:       return "F"
        case .saturday:     return "Sa"
        }
    }
}
