//
//  AddHockTest.swift
//  Uplift
//
//  Created by alden lamp on 9/24/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import Foundation


// TODO: - Replace this with Unit tests...

class AdHockTest {
    
    static func testWillChangeSoon() {
        let todayDay = Date().getIntegerDayOfWeekToday()
        let tmrDay = Date().getIntegerDayOfWeekTomorrow()

        let dateWithTmr = OpenHours(openHours: [QLOpenHours(dayNum: todayDay, start: 7, end: 8.5), QLOpenHours(dayNum: todayDay, start: 10, end: 22.75), QLOpenHours(dayNum: tmrDay, start: 8.25, end: 8.5)])
        
        let dateWithoutTmr = OpenHours(openHours: [QLOpenHours(dayNum: todayDay, start: 7, end: 8.5), QLOpenHours(dayNum: todayDay, start: 10, end: 22.75)])

        let times = [5.5, 6.1, 7.1, 8, 8.8, 9.1, 10.2, 22.74, 23.5]
        let expectedIsOpen = [false, false, true, true, false, false, true, true, false]
        let expectedIsStatusChangingSoon = [false, true, false, true, false, true, false, true, false]

        let opens1 = "Opens at 7 AM"
        let opens2 = "Opens at 10 AM"
        let opens3 = "Opens at 8:15 AM"
        let closes1 = "Closes at 8:30 AM"
        let closes2 = "Closes at 10:45 PM"
        let closes3 = "Closed"
        let expectedHourStrings = [opens1, opens1, closes1, closes1, opens2, opens2, closes2, closes2, opens3]
        let expectedHourStrings2 = [opens1, opens1, closes1, closes1, opens2, opens2, closes2, closes2, closes3]
        
        for (index, time) in times.enumerated() {
            let testDate = Date.getDateFromHours(day: todayDay, hours: time)
            print("\n\n")
            print(testDate.getStringOfDatetime(format: testDate.getHourFormat()))
            
            if dateWithTmr.isOpen(testDate) != expectedIsOpen[index] {
                print("\nIS OPEN FAILED")
                print("expected: \(expectedIsOpen[index])\nfound: \(dateWithTmr.isOpen(testDate))")
            }
            
            if dateWithTmr.isStatusChangingSoon(testDate) != expectedIsStatusChangingSoon[index] {
                print("\nSTATUS CHANGING SOON FAILED")
                print("expected: \(expectedIsStatusChangingSoon[index])\nfound: \(dateWithTmr.isStatusChangingSoon(testDate))")
            }
            
            if dateWithTmr.getHoursString(testDate) != expectedHourStrings[index] || dateWithoutTmr.getHoursString(testDate) != expectedHourStrings2[index] {
                print("\nGET HOURS STRING FAILED")
                print("expected: \(expectedHourStrings[index])\nfound: \(dateWithTmr.getHoursString(testDate))")
                print("expected: \(expectedHourStrings2[index])\nfound: \(dateWithoutTmr.getHoursString(testDate))")
            }
        }
        
        
        
    }
    
}
