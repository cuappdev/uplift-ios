//
//  File.swift
//  Fitness
//
//  Created by Joseph Fulgieri on 8/31/18.
//  Copyright © 2018 Uplift. All rights reserved.
//

import Foundation

// MARK: - IDENTIFIERS
struct Identifiers {
    // HEADERS
    static let homeScreenHeaderView = "homeScreenHeaderView"
    static let gymHoursHeaderView = "gymHoursHeaderView"
    static let favoritesHeaderView = "favoritesHeaderView"
    static let homeSectionHeaderView = "homeSectionHeaderView"
    static let todaysClassesHeaderView = "todaysClassesHeaderView"
    
    // CELLS
    static let allGymsCell = "allGymsCell"
    static let todaysClassesCell = "todaysClassesCell"
    static let lookingForCell = "lookingForCell"
    static let gymHoursCell = "gymHoursCell"
    static let dropdownViewCell = "dropdownViewCell"
    static let gymFilterCell = "gymFilterCell"
    static let categoryCell = "categoryCell"
    static let classesCell = "classesCell"
    static let gymsCell = "gymsCell"
    static let classListCell = "classListCell"
    static let calendarCell = "calendarCell"
    static let habitTrackerOnboardingCell = "habitTrackerOnboardingCell"
    
    // FOOTERS
    static let dropdownFooterView = "dropdownFooterView"
    
    // USER DEFAULTS
    static let hasSeenOnboarding = "hasSeenOnboarding"
    static let favorites = "Favorites"
    static let activeHabits = "ActiveHabits"
    static func habitIdentifier(forType: HabitTrackingType) -> String {
        switch forType {
        case .cardio:
            return "Cardio"
        case .strength:
            return "Strength"
        case .mindfulness:
            return "Mindfulness"
        }
    }
}
