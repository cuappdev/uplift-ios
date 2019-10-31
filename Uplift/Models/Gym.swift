//
//  Gym.swift
//  Uplift
//
//  Created by Cornell AppDev on 4/14/18.
//  Copyright © 2018 Uplift. All rights reserved.
//

import Foundation

struct Gym {

    let id: String
    let gymHours: [DailyGymHours]
    let name: String
    let facilities: [Facility]

    /// Array of 7 arrays of count 24, representing the busyness in each hour, Sun..Sat
    let popularTimesList: [[Int]]
    let imageURL: URL?
    var isOpen: Bool {
        return Date() > gymHoursToday.openTime ? Date() < gymHoursToday.closeTime : false
    }

    var closedTomorrow: Bool {
        let now = Date()
        let gymHoursTomorrow = gymHours[now.getIntegerDayOfWeekTomorrow()]
        return gymHoursTomorrow.openTime == gymHoursTomorrow.closeTime
    }

    var gymHoursToday: DailyGymHours {
        return gymHours[Date().getIntegerDayOfWeekToday()]
    }

    init(gymData: AllGymsQuery.Data.Gym) {
        id = gymData.id
        name = gymData.name
        imageURL = URL(string: gymData.imageUrl ?? "")

        var popularTimes = Array.init(repeating: Array.init(repeating: 0, count: 24), count: 7)

        if let popular = gymData.popular {
            popular.enumerated().forEach { (i, dailyPopular) in
                dailyPopular?.enumerated().forEach({ (j, dailyPopularItem) in
                    popularTimes[i][j] = dailyPopularItem ?? 0
                })
            }
        }
        popularTimesList = popularTimes

        // unwrap gym hours
        var gymHoursList: [DailyGymHours] = []

        let allGymHours = gymData.times
        for i in 0..<allGymHours.count {
            gymHoursList.append(DailyGymHours(gymHoursData: allGymHours[i]))
        }

        gymHours = gymHoursList

        facilities = gymData.facilities.compactMap {
            guard let facility = $0 else { return nil }
            return Facility(facilityData: facility)
        }
    }

    init(gymData: GymByIdQuery.Data.Gym ) {
        id = gymData.id
        name = gymData.name
        imageURL = URL(string: gymData.imageUrl ?? "")

        var popularTimes = Array.init(repeating: Array.init(repeating: 0, count: 24), count: 7)
        if let popular = gymData.popular {
            popular.enumerated().forEach { (i, dailyPopular) in
                dailyPopular?.enumerated().forEach({ (j, dailyPopularItem) in
                    popularTimes[i][j] = dailyPopularItem ?? 0
                })
            }
        }
        popularTimesList = popularTimes

        // unwrap gym hours
        gymHours = gymData.times.compactMap({ (gymHoursDataId) -> DailyGymHours? in
            guard let gymHoursDataId = gymHoursDataId else { return nil}
            return DailyGymHours(gymHoursDataId: gymHoursDataId)
        })

        facilities = gymData.facilities.compactMap {
            guard let facility = $0 else { return nil }
            return Facility(facilityData: facility)
        }
    }

    func isStatusChangingSoon() -> Bool {
        let changingSoonThreshold = 3600.0
        let now = Date()

        if isOpen {
            return (gymHoursToday.closeTime - changingSoonThreshold) < now
        } else {
            let openTime = gymHours[now.getIntegerDayOfWeekTomorrow()].openTime + Date.secondsPerDay
            return (openTime - changingSoonThreshold) < now
        }
    }

}

struct DailyFacilityHoursRanges {
    var dayOfWeek: Int
    var timeRanges: [FacilityHoursRange] = []

    init(facilityHoursData: AllGymsQuery.Data.Gym.Facility.Detail.Time) {
        dayOfWeek = facilityHoursData.day
        if let timeRangesData = facilityHoursData.timeRanges {
            timeRanges = timeRangesData.compactMap({ rangeData -> FacilityHoursRange? in
                guard let rangeData = rangeData else { return nil }
                return FacilityHoursRange(facilityHoursRangeData: rangeData)
            })
        }
    }

    init(facilityHoursData: GymByIdQuery.Data.Gym.Facility.Detail.Time) {
        dayOfWeek = facilityHoursData.day
        if let timeRangesData = facilityHoursData.timeRanges {
            timeRanges = timeRangesData.compactMap({ rangeData -> FacilityHoursRange? in
                guard let rangeData = rangeData else { return nil }
                return FacilityHoursRange(facilityHoursRangeData: rangeData)
            })
        }
    }
}

struct FacilityHoursRange {
    var openTime: Date = Date()
    var closeTime: Date
    var specialHours: Bool = false
    var restrictions: String = ""

    init(facilityHoursRangeData: AllGymsQuery.Data.Gym.Facility.Detail.Time.TimeRange?) {
        if let hoursRangeData = facilityHoursRangeData {
            openTime = Date.getTimeFromString(datetime: hoursRangeData.startTime)
            closeTime = Date.getTimeFromString(datetime: hoursRangeData.endTime)
            specialHours = hoursRangeData.specialHours
            restrictions = hoursRangeData.restrictions ?? ""
        } else {
            closeTime = openTime
        }
    }

    init(facilityHoursRangeData: GymByIdQuery.Data.Gym.Facility.Detail.Time.TimeRange?) {
        if let hoursRangeData = facilityHoursRangeData {
            openTime = Date.getTimeFromString(datetime: hoursRangeData.startTime)
            closeTime = Date.getTimeFromString(datetime: hoursRangeData.endTime)
            specialHours = hoursRangeData.specialHours
            restrictions = hoursRangeData.restrictions ?? ""
        } else {
            closeTime = openTime
        }
    }
}

struct DailyGymHours {
    var dayOfWeek: Int = 0
    var openTime: Date = Date()
    var closeTime: Date

    init(gymHoursData: AllGymsQuery.Data.Gym.Time?) {
        if let gymHoursData = gymHoursData {
            dayOfWeek = gymHoursData.day
            openTime = Date.getTimeFromString(datetime: gymHoursData.startTime)
            closeTime = Date.getTimeFromString(datetime: gymHoursData.endTime)
        } else {
            closeTime = openTime
        }
    }

    init(gymHoursDataId: GymByIdQuery.Data.Gym.Time?) {
        if let gymHoursData = gymHoursDataId {
            dayOfWeek = gymHoursData.day
            openTime = Date.getTimeFromString(datetime: gymHoursData.startTime)
            closeTime = Date.getTimeFromString(datetime: gymHoursData.endTime)
        } else {
            closeTime = openTime
        }
    }

}

enum DetailType: String {
    case equipment = "Equipment"
    case hours = "Hours"
    case prices = "Prices"
    case subfacilities = "Sub-Facilities" // MISCELLANEOUS
    case phoneNumbers = "Phone Numbers"
}

struct FacilityDetail {

    var detailType: DetailType

    // Equipment
    var equipment: [Equipment] = []

    // Hours
    var times: [DailyFacilityHoursRanges] = []

    // Prices
    var items: [String] = []
    var prices: [String] = []

    // Subfacilities
    var subfacilities: [String] = []

    init?(detailData: AllGymsQuery.Data.Gym.Facility.Detail) {
        guard let detailType =  DetailType(rawValue: detailData.detailsType ?? "") else {
            return nil
        }
        self.detailType = detailType

        switch detailType {
        case .equipment:
            if let equipmentGymData = detailData.equipment {
                equipment = equipmentGymData.compactMap({ equipmentData -> Equipment? in
                    guard let equipmentData = equipmentData else { return nil }
                    return Equipment(equipmentData: equipmentData)
                })
            }
        case .hours:
            if let facilityHoursData = detailData.times {
                times = facilityHoursData.compactMap({ facilityHoursData -> DailyFacilityHoursRanges? in
                    guard let facilityHours = facilityHoursData else { return nil }
                    return DailyFacilityHoursRanges(facilityHoursData: facilityHours)
                })
            }
        case .prices:
            if let itemsData = detailData.items {
                items = itemsData.compactMap({ item -> String in
                    return item ?? ""
                })
            }
            if let pricesData = detailData.prices {
                prices = pricesData.compactMap({ price -> String in
                    return price ?? ""
                })
            }
        case .subfacilities:
            if let subfacilitiesData = detailData.subFacilityNames {
                subfacilities = subfacilitiesData.compactMap({ subfacility -> String in
                    return subfacility ?? ""
                })
            }
        default:
            return
        }
    }

    init?(detailData: GymByIdQuery.Data.Gym.Facility.Detail) {
        guard let detailType =  DetailType(rawValue: detailData.detailsType ?? "") else {
            return nil
        }
        self.detailType = detailType

        switch detailType {
        case .equipment:
            // equipment
            if let equipmentGymData = detailData.equipment {
                equipment = equipmentGymData.compactMap({ equipmentData -> Equipment? in
                    guard let equipmentData = equipmentData else { return nil }
                    return Equipment(equipmentData: equipmentData)
                })
            }
        case .hours:
            // times
            if let facilityHoursData = detailData.times {
                times = facilityHoursData.compactMap({ facilityHoursData -> DailyFacilityHoursRanges? in
                    guard let facilityHours = facilityHoursData else { return nil }
                    return DailyFacilityHoursRanges(facilityHoursData: facilityHours)
                })
            }
        case .prices:
            // items & prices
            if let itemsData = detailData.items {
                items = itemsData.compactMap({ item -> String in
                    return item ?? ""
                })
            }
            if let pricesData = detailData.prices {
                prices = pricesData.compactMap({ price -> String in
                    return price ?? ""
                })
            }
        case .subfacilities:
            // subfacilities
            if let subfacilitiesData = detailData.subFacilityNames {
                subfacilities = subfacilitiesData.compactMap({ subfacility -> String in
                    return subfacility ?? ""
                })
            }
        default:
            return
        }
    }
}

struct Facility {

    var name: String
    var details: [FacilityDetail]

    init(facilityData: AllGymsQuery.Data.Gym.Facility) {
        name = facilityData.name
        if let detailsData = facilityData.details {
            details = detailsData.compactMap({ detailData -> FacilityDetail? in
                guard let detailData = detailData else { return nil }
                return FacilityDetail(detailData: detailData)
            })
        } else {
            details = []
        }
    }

    init(facilityData: GymByIdQuery.Data.Gym.Facility) {
        name = facilityData.name
        if let detailsData = facilityData.details {
            details = detailsData.compactMap({ detailData -> FacilityDetail? in
                guard let detailData = detailData else { return nil }
                return FacilityDetail(detailData: detailData)
            })
        } else {
            details = []
        }
    }
}

struct Equipment {

    var equipmentType: String = ""
    var name: String = ""
    var quantity: String = "0"
    var workoutType: String = ""

    init(equipmentData: AllGymsQuery.Data.Gym.Facility.Detail.Equipment?) {
        if let equipmentData = equipmentData {
            equipmentType = equipmentData.equipmentType ?? ""
            name = equipmentData.name
            quantity = equipmentData.quantity ?? "0"
            workoutType = equipmentData.workoutType ?? ""
        }
    }

    init(equipmentData: GymByIdQuery.Data.Gym.Facility.Detail.Equipment?) {
        if let equipmentData = equipmentData {
            equipmentType = equipmentData.equipmentType ?? ""
            name = equipmentData.name
            quantity = equipmentData.quantity ?? "0"
            workoutType = equipmentData.workoutType ?? ""
        } else {
            equipmentType = ""
            name = ""
            quantity = ""
            workoutType = ""
        }
    }

}
