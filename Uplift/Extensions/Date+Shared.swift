//
//  NSDate+Shared.swift
//  Uplift
//
//  Created by Cornell AppDev on 4/25/18.
//  Copyright © 2018 Uplift. All rights reserved.
//

import Foundation

extension Date {
    static let secondsPerDay = 86400.0

    static public func getNowString() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        // 2018-10-04T07:00:00
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }

    // MARK: - TIME OF DAY
    static public func getDateFromTime(time: String) -> Date {
        let index = time.index(of: ":")
        let isPM = time.contains("PM")

        let date = Date()
        let calendar = Calendar.current

        var dateComponents = DateComponents()
        dateComponents.year = calendar.component(.year, from: date)
        dateComponents.month = calendar.component(.month, from: date)
        dateComponents.day = calendar.component(.day, from: date)
        dateComponents.timeZone = TimeZone(abbreviation: "EDT")

        let hour = Int(String(time.prefix(upTo: index!)))
        dateComponents.hour = isPM ? hour! + 12 : hour

        let start = time.index(time.startIndex, offsetBy: 3)
        let end = time.index(time.endIndex, offsetBy: -2)
        let minutes = Int(String(time[start..<end]))
        dateComponents.minute = minutes

        return calendar.date(from: dateComponents)!
    }

    static public func convertTimeStringToDate(time: String) -> Date {
        let currDate = Date()
        let timeSections = time.split(separator: ":")
        let date = Calendar.current.date(bySettingHour: Int(timeSections[0]) ?? 0, minute: Int(timeSections[1]) ?? 0, second: Int(timeSections[2]) ?? 0, of: currDate)
        return date ?? currDate
    }

    static public func getDatetimeFromString(datetime: String?) -> Date {
        guard let datetime = datetime else {
            return Date()
        }
        let dateFormatter = DateFormatter()
        // 2018-10-04T07:00:00
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"

        return dateFormatter.date(from: datetime) ?? Date()
    }

    static public func getTimeFromString(datetime: String?, isCloseTime: Bool = false) -> Date {
        guard let datetime = datetime else {
            return Date()
        }
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"

        let date = dateFormatter.date(from: datetime) ?? today

        let calendar = Calendar.current
        var dateComponents = DateComponents()

        dateComponents.year = calendar.component(.year, from: today)
        dateComponents.month = calendar.component(.month, from: today)
        dateComponents.day = calendar.component(.day, from: today)
        dateComponents.timeZone = TimeZone.current
        dateComponents.hour = calendar.component(.hour, from: date)
        dateComponents.minute = calendar.component(.minute, from: date)

        guard let newDate = calendar.date(from: dateComponents) else {
            return date
        }

        // If we are parsing the close time and the time is past midnight
        // we should consider it to be the next day
        if isCloseTime,
            let hour = dateComponents.hour,
            hour < 12,
            let tomorrowsDate = Calendar.current.date(byAdding: .day, value: 1, to: newDate) {
            return tomorrowsDate
        } else {
            return newDate
        }
    }

    static public func getDatetimeFromStrings(dateString: String, timeString: String) -> Date {
        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "HH:mm:ss"
        let time = dateFormatter.date(from: timeString) ?? Date()

        dateFormatter.dateFormat = "YYYY-MM-dd"
        let date = dateFormatter.date(from: dateString) ?? Date()

        let calendar = Calendar.current
        var dateComponents = DateComponents()

        dateComponents.year = calendar.component(.year, from: date)
        dateComponents.month = calendar.component(.month, from: date)
        dateComponents.day = calendar.component(.day, from: date)
        dateComponents.timeZone = TimeZone.current
        dateComponents.hour = calendar.component(.hour, from: time)
        dateComponents.minute = calendar.component(.minute, from: time)

        return calendar.date(from: dateComponents)!
    }

    /// Returns the date associated with the string of form "MMddyyyy"
    static public func getDateFromString(date: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMddyyyy"
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.date(from: date) ?? Date()
    }

    // MARK: - DATE
    static func getStringDate(date: Date) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter.string(from: date)
    }

    // MARK: - DAY OF WEEK
    func getIntegerDayOfWeekToday() -> Int {
        return Calendar.current.component(.weekday, from: self) - 1
    }

    func getIntegerDayOfWeekTomorrow() -> Int {
        return Calendar.current.component(.weekday, from: self) % 7
    }

    func isYesterday() -> Bool {
        return Calendar.current.dateComponents([.day], from: self) == Calendar.current.dateComponents([.day], from: (Date() - Date.secondsPerDay))
    }

    func isToday() -> Bool {
        return Calendar.current.dateComponents([.day], from: self) == Calendar.current.dateComponents([.day], from: Date())
    }

    // MARK: - String
    func getStringOfDatetime(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: self)
    }

    func getHourFormat() -> String {
        return Calendar.current.component(.minute, from: self) == 0
            ? "h a"
            : "h:mm a"
    }

}
