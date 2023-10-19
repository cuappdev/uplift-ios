//
//  Constants.swift
//  Uplift
//
//  Created by Joseph Fulgieri on 8/31/18.
//  Copyright © 2018 Uplift. All rights reserved.
//

import UIKit

// MARK: - CONSTRAINTS
struct GymDetailConstraints {
    static let dividerViewHeight: CGFloat = 1
    static let titleLabelHeight: CGFloat = 18
    static let verticalPadding: CGFloat = 24
    static let cellPadding: CGFloat = dividerViewHeight + titleLabelHeight + verticalPadding
}

// MARK: - NOTIFICATION NAMES
public extension Notification.Name {
    static let upliftFitnessCentersLoadedNotification = Notification.Name("fitnessCentersLoadedNotification")
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
    static let gamesListHeaderView = "gamesListHeaderView"
    static let gymHoursHeaderView = "gymHoursHeaderView"
    static let homeScreenHeaderView = "homeScreenHeaderView"
    static let homeSectionHeaderView = "homeSectionHeaderView"
    static let loadingHeaderView = "loadingHeaderView"
    static let activitiesDetailHeaderView = "activitiesDetailHeaderView"
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
    static let facilityGymnasiumCell = "facilityGymnasiumCell"
    static let favoritesCell = "favoritesCell"
    static let gymEquipmentCell = "gymEquipmentCell"
    static let gymFacilityCell = "gymFacilityCell"
    static let gymFilterCell = "gymFilterCell"
    static let gymHoursCell = "gymHoursCell"
    static let gymWeekCell = "gymWeekCell"
    static let gymsCell = "gymsCell"
    static let habitTrackerCheckinCell = "habitTrackerCheckinCell"
    static let habitTrackerOnboardingCell = "habitTrackerOnboardingCell"
    static let loadingCollectionViewCell = "loadingCollectionViewCell"
    static let lookingForCell = "lookingForCell"
    static let noHabitsCell = "noHabitsCell"
    static let activitiesCell = "activitiesCell"
    static let sportsFilterGymCell = "sportsFilterGymCell"
    static let sportsFilterStartTimeCell = "sportsFilterStartTimeCell"
    static let sportsFilterNumPlayersCell = "sportsFilterNumPlayersCell"
    static let sportsFilterSportsDropdownCell = "sportsFilterSportsDropdownCell"
    static let pickupGameCell = "pickupGameCell"
    static let sportsDetailCommentCell = "sportsDetailCommentCell"
    static let sportsDetailDiscussionCell = "sportsDetailDiscussionCell"
    static let sportsDetailInfoCell = "sportsDetailInfoCell"
    static let sportsDetailInputCell = "sportsDetailInputCell"
    static let sportsDetailPlayersCell = "sportsDetailPlayersCell"
    static let sportsFormNameCell = "sportsFormNameCell"
    static let sportsFormTimeCell = "sportsFormTimeCell"
    static let sportsFormSportCell = "sportsFormSportCell"
    static let sportsFormLocationCell = "sportsFormLocationCell"
    static let sportsFormPlayersCell = "sportsFormPlayersCell"
    static let sportsFormBubbleListItemCell = "sportsFormBubbleListItemCell"
    static let sportsFormBubbleListInputCell = "sportsFormBubbleListInputCell"

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
    static let calendar = "calendar-icon"
    static let cancel = "cancel"
    static let cardio = "cardio"
    static let clock = "clock-icon"
    static let locationPointer = "location-pointer"
    static let mindfulness = "mindfulness"
    static let noWifi = "no-wifi"
    static let splashImage = "splash-image"
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
    static let personIcon = "person-icon"

    // SHARE
    static let shareDark = "share-dark"
    static let shareLight = "share-light"

    // SPORTS
    static let addSports = "add-sports"
    static let profilePicDemo = "demo-profile-pic"

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
    static let sportsFeed = "sports-tab"
    static let sportsFeedSelected = "sports-tab-selected"
}

// MARK: - SPORTS IMAGES
struct ActivitiesImages {
    // ACTIVITIES IMAGES
    static let lifting = UIImage(named: "lifting")!
    static let basketball = UIImage(named: "basketball1")!
    static let bowling = UIImage(named: "bowling1")!
    static let swimming = UIImage(named: "swimming")!
}
