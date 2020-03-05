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
    
    static let calendarCellIdentifier = "calendarCellIdentifier"
    static let classListHeaderViewIdentifier = "classListHeaderViewIdentifier"
    static let daysOfWeek = ["Su", "M", "T", "W", "Th", "F", "Sa"]
    
    /// Get a list of dates starting from 3 days before today and ending 6 days after today
    static func getCalendarDates() -> [Date] {
        let cal = Calendar.current
        let currDate = Date()

        guard let startDate = cal.date(byAdding: .day, value: -3, to: currDate), let endDate = cal.date(byAdding: .day, value: 6, to: currDate) else { return  [] }

        var dateList: [Date] = []
        var date = startDate
        while date <= endDate {
            dateList.append(date)
            date = cal.date(byAdding: .day, value: 1, to: date) ?? Date()
        }

        return dateList
    }
    
    /// Get flow layout for calendar collection view.
    static func getCalendarFlowLayout() -> UICollectionViewFlowLayout {
        let calendarFlowLayout = UICollectionViewFlowLayout()
        calendarFlowLayout.itemSize = CGSize(width: 24, height: 47)
        calendarFlowLayout.scrollDirection = .horizontal
        calendarFlowLayout.minimumLineSpacing = 40.0
        calendarFlowLayout.sectionInset = .init(top: 0.0, left: 16.0, bottom: 0.0, right: 16.0)
        return calendarFlowLayout
    }
    
    /// Get cell calendar collection view.
    static func getCalendarCell(_ collectionView: UICollectionView, indexPath: IndexPath, calendarDatesList: [Date], currDate: Date, calendarDateSelected: Date) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarGenerator.calendarCellIdentifier, for: indexPath) as! CalendarCell
            let dateForCell = calendarDatesList[indexPath.item]
            let dayOfWeek = CalendarGenerator.cal.component(.weekday, from: dateForCell) - 1
            let dayOfMonth = CalendarGenerator.cal.component(.day, from: dateForCell)

            var dateLabelCircleIsHidden = true
            var dateLabelFont = UIFont._12MontserratRegular
            var dateLabelTextColor: UIColor?
            var dayOfWeekLabelFont = UIFont._12MontserratRegular
            var dayOfWeekLabelTextColor: UIColor?

            if dateForCell < currDate {
                dateLabelTextColor = .gray02
                dayOfWeekLabelTextColor = .gray02
            }

            if dateForCell == calendarDateSelected {
                dateLabelCircleIsHidden = false
                dateLabelFont = ._12MontserratBold
                dateLabelTextColor = .primaryBlack
                dayOfWeekLabelFont = ._12MontserratBold
                dayOfWeekLabelTextColor = .primaryBlack
            }

            cell.configure(for: "\(dayOfMonth)",
                dateLabelTextColor: dateLabelTextColor,
                dateLabelFont: dateLabelFont!,
                dayOfWeekLabelText: CalendarGenerator.daysOfWeek[dayOfWeek],
                dayOfWeekLabelTextColor: dayOfWeekLabelTextColor,
                dayOfWeekLabelFont: dayOfWeekLabelFont!,
                dateLabelCircleIsHidden: dateLabelCircleIsHidden
            )
            return cell
    }
}
