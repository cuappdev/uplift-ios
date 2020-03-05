//
//  Calendar.swift
//  Uplift
//
//  Created by Artesia Ko on 3/4/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import Foundation
import UIKit

class CalendarGenerator {
    
    static let cal = Calendar.current
    static let currDate = getCalendarDates()[3]
    
    static let calendarCellIdentifier = "calendarCellIdentifier"
    static let classListHeaderViewIdentifier = "classListHeaderViewIdentifier"
    static let daysOfWeek = ["Su", "M", "T", "W", "Th", "F", "Sa"]
    
    static func getCalendarDates() -> [Date] {
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
    
    static func getCalendarFlowLayout() -> UICollectionViewFlowLayout {
        let calendarFlowLayout = UICollectionViewFlowLayout()
        calendarFlowLayout.itemSize = CGSize(width: 24, height: 47)
        calendarFlowLayout.scrollDirection = .horizontal
        calendarFlowLayout.minimumLineSpacing = 40.0
        calendarFlowLayout.sectionInset = .init(top: 0.0, left: 16.0, bottom: 0.0, right: 16.0)
        return calendarFlowLayout
    }
}
