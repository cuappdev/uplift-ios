//
//  Habit.swift
//  Fitness
//
//  Created by Joseph Fulgieri on 3/20/19.
//  Copyright © 2019 Keivan Shahida. All rights reserved.
//

import Foundation


// Habits are stored by category as a dictionary mapping habit titles to an array of
// dates on which that habit was checked in [dates are strings of form "MMDDYYYY"].
// The active habits are stored in an array of form: [ cardio habit, strength habit, mindfulness habit]
struct Habit {
    let title: String
    let dates: [Date]
    
    static func getActiveHabit(type: HabitTrackingType) -> String? {
        let defaults = UserDefaults.standard
        
        guard let activeHabits = defaults.stringArray(forKey: Identifiers.activeHabits) else { return nil }
        
        if activeHabits[type.rawValue] == "" {
            return nil
        }
        
        return activeHabits[type.rawValue]
    }
    
    // Creates a new habit if the habit doesn't already exist and sets it as the active habit for that category
    static func setActiveHabit(title: String, type: HabitTrackingType) {
        let defaults = UserDefaults.standard
        
        var habits: [String:[String]] = defaults.dictionary(forKey: Identifiers.habitIdentifier(forType: type)) as? [String: [String]] ?? [:]
        var activeHabits = defaults.stringArray(forKey: Identifiers.activeHabits) ?? ["", "", ""]
        
        activeHabits[type.rawValue] = title
        
        if !habits.keys.contains(title) {
            habits[title] = []
        }
        
        defaults.set(habits, forKey: Identifiers.habitIdentifier(forType: type))
        defaults.set(activeHabits, forKey: Identifiers.activeHabits)
    }
    
    static func logDate(habit: Habit, date: Date) {
        // TODO - implement
    }
}
