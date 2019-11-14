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
        static let businessLevel1 = "Not too busy"
        static let businessLevel2 = "A little busy"
        static let businessLevel3 = "As busy as it gets"
    }

    struct Home {
        static let editButton = "edit"
        static let todaysClassCancelled = "CANCELLED"
        static let viewAllButton = "view all"

        static let greetingAfternoon = "Good afternoon!"
        static let greetingEvening = "Good evening!"
        static let greetingMorning = "Good morning!"

        static let gymDetailCellClosed = "Closed"
        static let gymDetailCellOpen = "Open"
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
        static let todaysClassesSection = "TODAYS CLASSES"
    }

    struct Onboarding {
        static let endOnboarding = "BEGIN"
        static let selectGyms = "Select the gyms you go to!"
        static let signupLabel = "Sign Up"
        static let vcTitleLabel = "Welcome to Uplift!\nStart your Journey Today!"
    }

    struct TabBar {
        static let classesSection = "classes"
        static let favoritesSection = "favorites"
        static let homeSection = "browse"
    }
}
