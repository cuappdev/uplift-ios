//
//  OpenHours.swift
//  Uplift
//
//  Created by alden lamp on 9/19/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import Foundation

struct OpenHours {

    private var rawHours: [Int: [QLOpenHours]]

    private var todaysHours: [QLOpenHours]? {
        rawHours[Date().getIntegerDayOfWeekToday()]
    }

    private var tomorrowsHours: [QLOpenHours]? {
        rawHours[Date().getIntegerDayOfWeekTomorrow()]
    }

    init(openHours: [QLOpenHours]) {
        rawHours = [:]
        for openHour in openHours {
            if rawHours.keys.contains(openHour.day) {
                rawHours[openHour.day]?.append(openHour)
            } else {
                rawHours[openHour.day] = [openHour]
            }
        }
    }

    func isStatusChangingSoon(_ date: Date = Date()) -> Bool {
        return todaysHours?.first { $0.willChangeSoon(date) == true } != nil
    }

    func isOpen(_ date: Date = Date()) -> Bool {
        guard todaysHours != nil else {return false}
        return !todaysHours!.filter { $0.isDateInRange(date) }.isEmpty
    }

    private func currentOpenHours(_ date: Date = Date()) -> QLOpenHours? {
        todaysHours?.filter({  $0.isDateInRange(date) }).first
    }

    private func nextOpenHoursToday(_ date: Date = Date()) -> QLOpenHours? {
        todaysHours?.filter({ $0.startTime > date }).sorted(by: { $0.startTime < $1.startTime }).first
    }

    private func nextOpenHoursTomorrow() -> QLOpenHours? {
        tomorrowsHours?.sorted(by: { $0.startTime < $1.startTime }).first
    }

    func getHoursString(_ date: Date = Date()) -> String {
        let strFormat: String

        // Gym is open
        if let nowHourRange = currentOpenHours(date) {
            strFormat = nowHourRange.endTime.getHourFormat()
            let closeTime = nowHourRange.endTime.getStringOfDatetime(format: strFormat)
            return ClientStrings.Home.gymDetailCellClosesAt + closeTime

        // Gym will open today
        } else if let nextOpenToday = nextOpenHoursToday(date) {
            strFormat = nextOpenToday.startTime.getHourFormat()
            return ClientStrings.Home.gymDetailCellOpensAt + (nextOpenToday.startTime.getStringOfDatetime(format: strFormat))

        // Gym will open tmr
        } else if let nextOpenTomorrow = nextOpenHoursTomorrow() {
            strFormat = nextOpenTomorrow.startTime.getHourFormat()
            return ClientStrings.Home.gymDetailCellOpensAt + nextOpenTomorrow.startTime.getStringOfDatetime(format: strFormat)

        // Closed
        } else {
            return ClientStrings.CommonStrings.closed
        }
    }

}
