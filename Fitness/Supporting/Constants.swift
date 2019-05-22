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
    static let facilityHoursHeaderView = "facilityHoursHeaderView"
    static let favoritesHeaderView = "favoritesHeaderView"
    static let gymHoursHeaderView = "gymHoursHeaderView"
    static let homeScreenHeaderView = "homeScreenHeaderView"
    static let homeSectionHeaderView = "homeSectionHeaderView"
    static let todaysClassesHeaderView = "todaysClassesHeaderView"

    // CELLS
    static let categoryCell = "categoryCell"
    static let classListCell = "classListCell"
    static let classesCell = "classesCell"
    static let dropdownViewCell = "dropdownViewCell"
    static let facilityHoursCell = "facilityHoursCell"
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

    // FOOTERS
    static let dropdownFooterView = "dropdownFooterView"
    
    // USER DEFAULTS
    static let activeHabits = "ActiveHabits"
    static let favoriteGyms = "FavoriteGyms"
    static let favorites = "Favorites"
    static let googleExpiration = "googleExpiration"
    static let googleRefresh = "googleRefresh"
    static let googleToken = "googleToken"
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

// MARK: - SUGGESTED HABITS
struct HabitConstants {
    static func suggestedHabits(type: HabitTrackingType) -> [String] {
        switch type {
        case .cardio:
            return ["Walking to class", "Walk 10000 steps per day", "Running on a treadmill for 20 minutes", "Jumprope for 5 minutes"]
        case .strength:
            return ["Curls for 20 mins", "30 Pushups", "Plank for 5 mins"]
        case .mindfulness:
            return ["Read favorite book for 10 mins", "Meditate for 5 mins", "Reflect on today"]
        }
    }
    
    static func habitTypeDescription(type: HabitTrackingType) -> String {
        switch type {
        case .cardio:
            return "Daily heart pump so you can jog to your 10AM with ease"
        case .strength:
            return "Mann Library, WSH or Gates. No building’s door can slow you down now"
        case .mindfulness:
            return "Take care of your mind, As much as your grades."
        }
    }
}
