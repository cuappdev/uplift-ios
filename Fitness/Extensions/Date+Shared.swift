//
//  NSDate+Shared.swift
//  Fitness
//
//  Created by Keivan Shahida on 4/25/18.
//  Copyright © 2018 Keivan Shahida. All rights reserved.
//

import Foundation

extension Date {

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
    
    static public func getDatetimeFromString(datetime: String?) -> Date {
        guard let datetime = datetime else {
            return Date()
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        
        return dateFormatter.date(from: datetime) ?? Date()
    }

    // MARK: - DATE
    func getStringDate(date: Date) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let newDate: String = dateFormatter.string(from: date)
        return newDate
    }

    // MARK: - MINUTES
    static public func getMinutesFromDuration(duration: String) -> Int {
        var durationMinutes = duration

        if durationMinutes.hasPrefix("0") {
            durationMinutes = durationMinutes.substring(from: String.Index(encodedOffset: 2))
        } else {
            let hours = durationMinutes.substring(to: String.Index(encodedOffset: durationMinutes.count-3))
            durationMinutes = durationMinutes.substring(from: String.Index(encodedOffset: 2))
            durationMinutes = String( Int(hours)!*60 + Int(durationMinutes)!)
        }

        return Int(durationMinutes)!
    }

    // MARK: - DAY OF WEEK
    func getIntegerDayOfWeekToday() -> Int {
        return Calendar.current.component(.weekday, from: self)-1
    }

    func getIntegerDayOfWeekTomorrow() -> Int {
        return Calendar.current.component(.weekday, from: self)
    }
    
    // MARK: - String
    func getStringOfDatetime(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self) ?? ""
    }
}
