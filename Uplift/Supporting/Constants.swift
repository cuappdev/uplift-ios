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

// MARK: - CLASS IDS
struct ClassIds {
    static let yogaVinyasa = "057794a5c10fb355cc5c31a0989781b3271f03f7"
    static let cuRowShockwave = "13dacafc5638331cc9c4477b918c914db3c1310b"
    static let zumba = "eb318ac64f7eab2046aa38ad52ca487b11c006a8"
    static let musclePump = "73e8b1961738da4ba44efd45a925b61bf59be760"
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
    static let facilitiesMiscellaneousCell = "facilitiesMiscellaneousCell"
    static let facilitiesPriceInformationCell = "facilitiesPriceInformationCell"
    static let facilityEquipmentListCell = "facilityEquipmentListCell"
    static let facilityHoursCell = "facilityHoursCell"
    static let favoritesCell = "favoritesCell"
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
    static let favoriteClasses = "FavoritesClasses"
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
    static let backArrowDark = "back-arrow-dark"
    static let backArrowLight = "back-arrow-light"
    static let downArrow = "down-arrow"
    static let downArrowSolid = "down-arrow-solid"
    static let rightArrow = "right-arrow"
    static let rightArrowSolid = "right-arrow-solid"
    static let yellowCheckmark = "checked-circle-yellow"
    static let yellowNextArrow = "yellow-next-arrow"
    static let greenCheckmark = "checked-circle-green"

    // FACILITIES
    static let basketball = "basketball"
    static let bowling = "bowling"
    static let equipment = "equipment"
    static let misc = "misc"
    static let court = "court-single"
    static let pool = "pool"

    // ICONS
    static let addDark = "add-dark"
    static let addLight = "add-light"
    static let appIcon = "appIcon"
    static let calendar = "calendar-icon"
    static let cancel = "cancel"
    static let cardio = "cardio"
    static let clock = "clock-icon"
    static let locationPointer = "location-pointer"
    static let mindfulness = "mindfulness"
    static let strength = "strength"
    static let widgets0 = "widgets-empty"
    static let widgets1 = "widgets-1"
    static let widgets2 = "widgets-2"
    static let widgets3 = "widgets-3"

    // ONBOARDING
    static let divider = "divider"
    static let onboarding1 = "onboarding-1"
    static let onboarding2 = "onboarding-2"
    static let onboarding3 = "onboarding-3"
    static let onboarding4 = "onboarding-4"
    static let runningMan = "running-man"

    // MISC VIEWS
    static let semicircle = "semicircle"

    // SHARE
    static let shareDark = "share-dark"
    static let shareLight = "share-light"

    // STARS
    static let starFilledInDark = "star-filled-in-dark"
    static let starFilledInLight = "star-filled-in-light"
    static let starOutlineDark = "star-outline-dark"
    static let starOutlineLight = "star-outline-light"

    // TAB ICONS
    static let classes = "classes-tab"
    static let classesSelected = "classes-tab-selected"
    static let favorites = "favorites-tab"
    static let favoritesSelected = "favorites-tab-selected"
    static let home = "home-tab"
    static let homeSelected = "home-tab-selected"
}
