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
    static let favoritesHeaderView = "favoritesHeaderView"
    static let gymHoursHeaderView = "gymHoursHeaderView"
    static let homeScreenHeaderView = "homeScreenHeaderView"
    static let homeSectionHeaderView = "homeSectionHeaderView"
    
    // CELLS
    static let allGymsCell = "allGymsCell"
    static let calendarCell = "calendarCell"
    static let categoryCell = "categoryCell"
    static let classListCell = "classListCell"
    static let classesCell = "classesCell"
    static let discoverProsCell = "discoverProsCell"
    static let dropdownViewCell = "dropdownViewCell"
    static let gymFilterCell = "gymFilterCell"
    static let gymHoursCell = "gymHoursCell"
    static let gymsCell = "gymsCell"
    static let habitTrackerCheckinCell = "habitTrackerCheckinCell"
    static let habitTrackerOnboardingCell = "habitTrackerOnboardingCell"
    static let lookingForCell = "lookingForCell"
    static let noHabitsCell = "noHabitsCell"
    static let personalSiteCell = "personalSiteCell"
    static let proCell = "proCell"
    static let proRoutineCell = "proRoutineCell"
    static let todaysClassesCell = "todaysClassesCell"
    
    // FOOTERS
    static let dropdownFooterView = "dropdownFooterView"
    
    // USER DEFAULTS
    static let favorites = "Favorites"
    static let favoriteGyms = "FavoriteGyms"
    static let googleToken = "googleToken"
    static let googleExpiration = "googleExpiration"
    static let googleRefresh = "googleRefresh"
    static let activeHabits = "ActiveHabits"
    static func habitIdentifier(for type: HabitTrackingType) -> String {
        switch type {
        case .cardio:
            return "Cardio"
        case .strength:
            return "Strength"
        case .mindfulness:
            return "Mindfulness"
        }
    }
    static let hasSeenOnboarding = "hasSeenOnboarding2.0"
}
