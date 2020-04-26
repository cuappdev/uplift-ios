//
//  ClientStrings.swift
//  Uplift
//
//  Created by Cameron Hamidi on 9/25/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import Foundation

struct ClientStrings {
    struct Alerts {
        static let addedToCalendarMessage = "Get ready to get sweaty"
        static let addedToCalendarTitle = " added to calendar"
        static let cannotAddToCalendarMessage = "Uplift does not have permission to acess your calendar"
        static let cannotAddToCalendarTitle = "Cannot add to calendar"
        static let dismissAlert = "OK"
        static let displaySettingsTitle = "Settings"
    }

    struct Calendar {
        static let noClassesTodayDescription = "Sit back and make yourself some tea"
        static let noClassesTodayLabel = "NO CLASSES TODAY"
        static let todayLabel = "TODAY"
    }

    struct ClassDetail {
        static let addToCalendarButton = "ADD TO CALENDAR"
        static let durationMin = " MIN"
        static let functionLabel = "FUNCTION"
        static let nextSessionsLabel = "NEXT SESSIONS"
    }

    struct ClassList {
        static let dayMinAbbreviation = " min"
        static let dayTodayLabel = "Today"
        static let vcTitleLabel = "Classes"
    }

    struct CommonStrings {
        static let closed = "Closed"
        static let open = "Open"
    }

    struct Dropdown {
        static let collapse = "Hide"
        static let expand = "Show All "
    }

    struct Favorites {
        static let browseClasses = "BROWSE CLASSES"
        static let comingUpNextLabel = "COMING UP NEXT"
        static let hasFavoritesText = "NOTHING CAN STOP YOU BUT YOURSELF."
        static let noFavoritesText = "FIND YOUR\nFAVORITE NOW."
        static let vcTitleLabel = "Favorites"
    }

    struct Filter {
        static let appliedFilterLabel = "APPLIED FILTER"
        static let applyFilterLabel = "APPLY FILTER"
        static let doneButton = "Done"
        static let dropdownShowClassTypes = Dropdown.expand + "Class Types"
        static let dropdownShowInstructors = Dropdown.expand + "Instructors"
        static let filterButton = "Reset"
        static let noResultsDescription = "Try searching again!"
        static let noResultsLabel = "NO RESULTS"
        static let resetButton = "Reset"
        static let selectClassTypeSection = "CLASS TYPE"
        static let selectGymSection = "FITNESS CENTER"
        static let selectInstructorSection = "INSTRUCTOR"
        static let startTime = "START TIME"
        static let vcTitleLabel = "Refine Search"
    }

    struct HabitTracking {
        static let createHabitButton = "Create your own"
        static let featuredHabitsSection = "FEATURED"
        static let newHabitPlaceholder = "The first step is the hardest."
        static let saveButton = "SAVE"
        static let suggestedHabitsSection = "SUGGESTIONS"
        static let vcTitleCardio = "Cardio"
        static let vcTitleMindfulness = "Mindfulness"
        static let vcTitleStrength = "Strength"
    }

    struct Histogram {
        static let busynessLevel1 = "Not too busy"
        static let busynessLevel2 = "A little busy"
        static let busynessLevel3 = "As busy as it gets"
    }

    struct Home {
        static let editButton = "edit"
        static let todaysClassCancelled = "CANCELLED"
        static let viewAllButton = "view all"

        static let greetingAfternoon = "Good afternoon!"
        static let greetingEvening = "Good evening!"
        static let greetingMorning = "Good morning!"

        static let gymDetailCellOpensAt = "Opens at "
        static let gymDetailCellClosesAt = "Closes at "
    }

    struct GymDetail {
        static let closedLabel = "CLOSED"
        static let closedOnACertainDay = "Closed"
        static let facilitiesSection = "FACILITIES"
        static let hoursLabel = "HOURS"
        static let noMoreClasses = "We are done for today.\nCheck again tomorrow!\n🌟"
        static let noTimesToday = "NO TIMES TODAY"
        static let popularHoursSection = "POPULAR TIMES"
        static let todaysClassesSection = "TODAY'S CLASSES"
    }

    struct Onboarding {
        static let endButton = "Let's Go!"
        static let gymsSelection = "Select the Gyms you go to!"
        static let noConnectionButton = "RETRY"
        static let noConnectionSubtext = "Try again"
        static let noConnectionTitle = "NO CONNECTION"
        static let onboarding1 = "Uplift is the go-to fitness and wellness app at Cornell."
        static let onboarding2 = "Uplift helps you find times to go to the gym. Choose your favorite gym(s) below!"
        static let onboarding3 = "Classes are included with your gym membership. Choose a few favorites!"
        static let onboarding4 = "See you at the gym!"
        static let skipButton = "SKIP"
    }
    
    struct SportsDetail {
        static let addComment = "Add a comment..."
        static let discussionSection = "DISCUSSION"
    }

    struct TabBar {
        static let classesSection = "Classes"
        static let favoritesSection = "Favorites"
        static let homeSection = "Home"
        static let sportsFeedSection = "Sports"
    }
}
