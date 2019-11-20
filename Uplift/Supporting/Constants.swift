//
//  Constants.swift
//  Uplift
//
//  Created by Joseph Fulgieri on 8/31/18.
//  Copyright © 2018 Uplift. All rights reserved.
//

import UIKit

// MARK: - CONSTRAINTS
struct Constraints {
    static let dividerViewHeight: CGFloat = 1
    static let titleLabelHeight: CGFloat = 18
    static let verticalPadding: CGFloat = 34
}

// MARK: - DAY ABBREVIATIONS
struct DayAbbreviations {
    static let sunday = "Su"
    static let monday = "M"
    static let tuesday = "T"
    static let wednesday = "W"
    static let thursday = "Th"
    static let friday = "F"
    static let saturday = "Sa"
}

// MARK: - GYM IDS
struct GymIds {
    static let appel = "7c53229a64f4794f57a715a9ec0c7f806db23514"
    static let helenNewman = "7045d11329b3645c93556c5aaf44bb21d56934f5"
    static let noyes = "1f114d3b981f832c858f5cfa52f3a1eb6191e1a4"
    static let teagleDown = "043c57f3b63411c7a3500c0986fa4b1c8712798c"
    static let teagleUp = "939c7a2c16d2299cc8558475a8007defc414069c"
}

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
    static let courtCollectionViewCell = "courtCollectionViewCell"
    static let dropdownViewCell = "dropdownViewCell"
    static let facilitiesDropdownCell = "facilitiesDropdownCell"
    static let facilityHoursCell = "facilityHoursCell"
    static let facilitiesMiscellaneousCell = "facilitiesMiscellaneousCell"
    static let gymEquipmentCell = "gymEquipmentCell"
    static let gymFacilityCell = "gymFacilityCell"
    static let gymFilterCell = "gymFilterCell"
    static let gymHoursCell = "gymHoursCell"
    static let gymWeekCell = "gymWeekCell"
    static let gymsCell = "gymsCell"
    static let habitTrackerCheckinCell = "habitTrackerCheckinCell"
    static let habitTrackerOnboardingCell = "habitTrackerOnboardingCell"
    static let lookingForCell = "lookingForCell"
    static let noHabitsCell = "noHabitsCell"

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
    static let hasSeenOnboarding = "hasSeenOnboarding3.0"
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

// MARK: - IMAGE NAMES
struct ImageNames {
    // ARROWS
    static let arrow = "arrow"
    static let darkBackArrow = "darkBackArrow"
    static let downArrow = "down_arrow"
    static let downArrowSolid = "down-arrow-solid"
    static let lightBackArrow = "back-arrow"
    static let rightArrow = "right_arrow"
    static let rightArrowSolid = "right-arrow-solid"
    static let yellowCheckmark = "yellowCheckmark"
    static let yellowNextArrow = "yellowNextArrow"

    // FACILITIES
    static let basketball = "basketball"
    static let bowling = "bowling"
    static let equipment = "equipment"
    static let misc = "misc"
    static let court = "court-single"
    static let pool = "pool"

    // ICONS
    static let calendar = "calendar-icon"
    static let cancel = "cancel"
    static let cardio = "cardio"
    static let checkedCircle = "checked_circle"
    static let clock = "clock-icon"
    static let darkAdd = "darkAdd"
    static let lightAdd = "lightAdd"
    static let locationPointer = "location_pointer"
    static let mindfulness = "mindfulness"
    static let strength = "strength"
    static let widgets0 = "widgets-empty"
    static let widgets1 = "widgets-1"
    static let widgets2 = "widgets-2"
    static let widgets3 = "widgets-3"

    // ONBOARDING
    static let divider = "divider"
    static let onboarding1 = "onboarding_1"
    static let onboarding2 = "onboarding_2"
    static let onboarding3 = "onboarding_3"
    static let onboarding4 = "onboarding_4"
    static let runningMan = "running-man"

    // MISC VIEWS
    static let semicircle = "semicircle"

    // SHARE
    static let darkShare = "share_dark"
    static let lightShare = "share-light"

    // STARS
    static let blackStarOutline = "blackStar"
    static let whiteStarOutline = "white-star"
    static let yellowWhiteStar = "yellow-white-star"

    // TAB ICONS
    static let classes = "classes-tab"
    static let classesSelected = "classes-tab-selected"
    static let favorites = "favorites-tab"
    static let favoritesSelected = "favorites-selected"
    static let home = "home-tab"
    static let homeSelected = "home-tab-selected"
}
