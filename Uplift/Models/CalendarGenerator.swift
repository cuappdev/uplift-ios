//
//  Calendar.swift
//  Uplift
//
//  Created by Artesia Ko on 3/4/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import Foundation

class CalendarGenerator {
    
    private enum Constants {
        static let calendarCellIdentifier = "calendarCellIdentifier"
        static let classListHeaderViewIdentifier = "classListHeaderViewIdentifier"
        static let daysOfWeek = ["Su", "M", "T", "W", "Th", "F", "Sa"]
    }
    
    func createCalendarDates() -> [Date] {
        let cal = Calendar.current
        let currDate = Date()

        guard let startDate = cal.date(byAdding: .day, value: -3, to: currDate) else { return  [] }
        guard let endDate = cal.date(byAdding: .day, value: 6, to: currDate) else { return [] }

        var dateList: [Date] = []
        var date = startDate
        while date <= endDate {
            dateList.append(date)
            date = cal.date(byAdding: .day, value: 1, to: date) ?? Date()
        }

        return dateList
    }
}
