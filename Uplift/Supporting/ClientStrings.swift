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
        static let addedToCalendarTitle = " added to calendar"
        static let addedToCalendarMessage = "Get ready to get sweaty"
        static let dismissAlert = "OK"
        static let cannotAddToCalendarTitle = "Cannot add to calendar"
        static let cannotAddToCalendarMessage = "Uplift does not have permission to acess your calendar"
        static let displaySettingsTitle = "Settings"
    }
    
    struct ClassList {
        static let vcTitleLabel = "Classes"
        static let dayTodayLabel = "Today"
        static let dayMinAbbreviation = " min"
    }
    
    struct Calendar {
        static let todayLabel = "TODAY"
        static let noClassesTodayLabel = "NO CLASSES TODAY"
        static let noClassesTodayDescription = "Sit back and make yourself some tea"
    }
    
    struct Filter {
        static let appliedFilterLabel = "APPLIED FILTER"
        static let applyFilterLabel = "APPLY FILTER"
        static let startTime = "START TIME"
        static let vcTitleLabel = "Refine Search"
        static let doneButton = "Done"
        static let filterButton = "Reset"
        static let selectGymSection = "FITNESS CENTER"
        static let dropdownShowInstructors = Dropdown.expand + "Instructors"
        static let dropdownShowClassTypes = Dropdown.expand + "Class Types"
        static let selectInstructorSection = "INSTRUCTOR"
        static let selectClassTypeSection = "CLASS TYPE"
        static let noResultsLabel = "NO RESULTS"
        static let noResultsDescription = "Try searching again!"
    }
    
    struct Favorites {
        static let vcTitleLabel = "Favorites"
        static let noFavoritesText = "FIND YOUR\nFAVORITE NOW."
        static let browseClasses = "BROWSE CLASSES"
        static let hasFavoritesText = "NOTHING CAN STOP YOU BUT YOURSELF."
        static let comingUpNextLabel = "COMING UP NEXT"
    }
    
    struct Dropdown {
        static let expand = "Show All "
        static let collapse = "Hide"
    }
    
    struct HabitTracking {
        static let vcTitleCardio = "Cardio"
        static let vcTitleStrength = "Strength"
        static let vcTitleMindfulness = "Mindfulness"
        static let saveButton = "SAVE"
        static let createHabitButton = "Create your own"
        static let featuredHabitsSection = "FEATURED"
        static let suggestedHabitsSection = "SUGGESTIONS"
        static let newHabitPlaceholder = "The first step is the hardest."
    }
    
    struct Home {
        static let editButton = "edit"
        static let viewAllButton = "view all"
        static let gymDetailCellClosed = "Closed"
        static let gymDetailCellOpen = "Currently open"
        static let gymDetailCellClosingSoon = "Closing soon"
        static let gymDetailCellOpeningSoon = "Opening soon"
        static let gymDetailCellClosedTomorrow = "Closed Tomorrow"
        static let gymDetailCellOpensAt = "Open at "
        
        static let todaysClassCancelled = "CANCELLED"
        
        static let greetingMorning = "Good morning!"
        static let greetingAfternoon = "Good afternoon!"
        static let greetingEvening = "Good evening!"
    }
    
    struct Onboarding {
        static let selectGyms = "Select the gyms you go to!"
        static let vcTitleLabel = "Welcome to Uplift!\nStart your Journey Today!"
        static let signupLabel = "Sign Up"
        static let endOnboarding = "BEGIN"
    }
    
    struct TabBar {
        static let homeSection = "browse"
        static let classesSection = "classes"
        static let favoritesSection = "favorites"
    }
    
    struct ClassDetail {
        static let durationMin = " MIN"
        static let addToCalendarButton = "ADD TO CALENDAR"
        static let functionLabel = "FUNCTION"
        static let nextSessionsLabel = "NEXT SESSIONS"
    }
    
    struct GymDetail {
        static let closedLabel = "CLOSED"
        static let hoursLabel = "HOURS"
        static let popularHoursSection = "POPULAR TIMES"
        static let facilitiesSection = "FACILITIES"
        static let todaysClassesSection = "TODAYS CLASSES"
        static let noMoreClasses = "We are done for today.\nCheck again tomorrow!\n🌟"
        static let closedOnACertainDay = "Closed"
    }
    
    struct Histogram {
        static let businessLevel1 = "Not too busy"
        static let businessLevel2 = "A little busy"
        static let businessLevel3 = "As busy as it gets"
    }
}
