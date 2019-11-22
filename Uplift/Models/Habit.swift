//
//  Habit.swift
//  Uplift
//
//  Created by Joseph Fulgieri on 3/20/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import Foundation

// Habits are stored by category as a dictionary mapping habit titles to an array of
// dates on which that habit was checked in [dates are strings of form "MMDDYYYY"].
// The active habits are stored as strings in an array of form: [ cardio habit, strength habit, mindfulness habit]
struct Habit {
    let title: String
    var dates: [Date]
    let type: HabitTrackingType

    /// Number of consective days going back from today that this habit has been logged;
    /// includes today if the habit has been logged today
    var streak: Int {
        if dates.isEmpty {
            return 0
        }

        var sortedDates = dates.sorted()
        sortedDates.reverse()

        if !(sortedDates[0].isToday() || sortedDates[0].isYesterday()) {
            return 0
        }

        var streak = 1

        for i in 0..<(sortedDates.count - 1) {
            if sortedDates[i] - Date.secondsPerDay == sortedDates[i + 1] {
                streak += 1
            } else {
                break
            }
        }

        return streak
    }

    /// Returns the title of the active habit fir the given type
    static func getActiveHabitTitle(type: HabitTrackingType) -> String? {
        let defaults = UserDefaults.standard

        guard let activeHabits = defaults.stringArray(forKey: Identifiers.activeHabits) else { return nil }

        if activeHabits.count < 3 || activeHabits[type.rawValue] == "" {
            return nil
        }

        return activeHabits[type.rawValue]
    }

    /// Returns the habit with the given title and type, if it exists
    static func getHabit(habit: String, type: HabitTrackingType) -> Habit? {
        let defaults = UserDefaults.standard

        var habits: [String: [String]] = defaults.dictionary(forKey: Identifiers.habitIdentifier(for: type)) as? [String: [String]] ?? [:]

        let dateStrings = (habits[habit] ?? []).compactMap({ $0 })
        let dates = dateStrings.map { Date.getDateFromString(date: $0) }

        return Habit(title: habit, dates: dates, type: type)
    }

    /// Returns active habits in the form [ cardio habit, strength habit, mindfulness habit],
    /// or an empty array if there is not an active habit for each type
    static func getActiveHabits() -> [Habit] {
        let defaults = UserDefaults.standard

        guard let activeHabits = defaults.stringArray(forKey: Identifiers.activeHabits) else { return [] }
        if activeHabits.count < 3 || activeHabits.contains("") { return [] }
        let habitTypes: [HabitTrackingType] = [.cardio, .strength, .mindfulness]

        var habitArray: [Habit] = []

        // 3 loops to get each active habit [cardio, strength, mindulfness]
        (0..<3).forEach { i in
            if let habit = getHabit(habit: activeHabits[i], type: habitTypes[i]) {
                habitArray.append(habit)
            }
        }

        // only return the habit array if we have a habit for each of the 3 type
        return habitArray.count == 3 ? habitArray : []
    }

    /// Creates a new habit if the habit doesn't already exist and sets it as the active habit for that category
    static func setActiveHabit(title: String, type: HabitTrackingType) {
        let defaults = UserDefaults.standard

        var habits: [String: [String]] = defaults.dictionary(forKey: Identifiers.habitIdentifier(for: type)) as? [String: [String]] ?? [:]
        var activeHabits = defaults.stringArray(forKey: Identifiers.activeHabits) ?? ["", "", ""]

        activeHabits[type.rawValue] = title

        if !habits.keys.contains(title) {
            habits[title] = []
            defaults.set(habits, forKey: Identifiers.habitIdentifier(for: type))
        }

        defaults.set(activeHabits, forKey: Identifiers.activeHabits)
    }

    static func logDate(habit: Habit, date: Date) {
        let defaults = UserDefaults.standard

        var habits: [String: [String]] = defaults.dictionary(forKey: Identifiers.habitIdentifier(for: habit.type)) as? [String: [String]] ?? [:]

        let newDate = date.getStringOfDatetime(format: "MMddyyyy")

        if !(habits[habit.title]?.contains(newDate) ?? true) {
            habits[habit.title]?.append(newDate)
        }

        defaults.set(habits, forKey: Identifiers.habitIdentifier(for: habit.type))

        // TODO - post check-in to backend once routes are available
    }

    /// Undoes the effects of `logDate`
    static func removeDate(habit: Habit, date: Date) {
        let defaults = UserDefaults.standard

        var habits: [String: [String]] = defaults.dictionary(forKey: Identifiers.habitIdentifier(for: habit.type)) as? [String: [String]] ?? [:]

        let newDate = date.getStringOfDatetime(format: "MMddyyyy")

        if let index = habits[habit.title]?.index(of: newDate) {
            habits[habit.title]?.remove(at: index)
        }

        defaults.set(habits, forKey: Identifiers.habitIdentifier(for: habit.type))

        // TODO - post check-in to backend once routes are available
    }
}

extension Habit: Equatable {
    static func == (lhs: Habit, rhs: Habit) -> Bool {
        return lhs.title == rhs.title && lhs.streak == rhs.streak
    }
}
