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

// MARK: - Facilities

struct DailyFacilityHoursRanges {
    var dayOfWeek: Int
    var timeRanges: [FacilityHoursRange] = []

    init(facilityHoursData: AllGymsQuery.Data.Gym.Facility.Detail.Time) {
        dayOfWeek = facilityHoursData.day
        timeRanges = facilityHoursData.timeRanges.compactMap({ rangeData -> FacilityHoursRange? in
            guard let rangeData = rangeData else { return nil }
            return FacilityHoursRange(facilityHoursRangeData: rangeData)
        })
    }

    init(facilityHoursData: GymByIdQuery.Data.Gym.Facility.Detail.Time) {
        dayOfWeek = facilityHoursData.day
        timeRanges = facilityHoursData.timeRanges.compactMap({ rangeData -> FacilityHoursRange? in
            guard let rangeData = rangeData else { return nil }
            return FacilityHoursRange(facilityHoursRangeData: rangeData)
        })
    }
}

struct FacilityHoursRange {
    var openTime: Date = Date()
    var closeTime: Date = Date()
    var specialHours: Bool = false
    var restrictions: String = ""

    init(facilityHoursRangeData: AllGymsQuery.Data.Gym.Facility.Detail.Time.TimeRange) {
        openTime = Date.getTimeFromString(datetime: facilityHoursRangeData.startTime)
        closeTime = Date.getTimeFromString(datetime: facilityHoursRangeData.endTime)
        specialHours = facilityHoursRangeData.specialHours
        restrictions = facilityHoursRangeData.restrictions
    }

    init(facilityHoursRangeData: GymByIdQuery.Data.Gym.Facility.Detail.Time.TimeRange) {
        openTime = Date.getTimeFromString(datetime: facilityHoursRangeData.startTime)
        closeTime = Date.getTimeFromString(datetime: facilityHoursRangeData.endTime)
        specialHours = facilityHoursRangeData.specialHours
        restrictions = facilityHoursRangeData.restrictions
    }
}

enum DetailType: String {
    case equipment = "Equipment"
    case hours = "Hours"
    case prices = "Prices"
    case subfacilities = "Sub-Facilities" // MISCELLANEOUS
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
        guard let detailType =  DetailType(rawValue: detailData.detailsType) else {
            return nil
        }
        self.detailType = detailType

        switch detailType {
        case .equipment:
            equipment = detailData.equipment.compactMap({ equipmentData -> Equipment? in
                guard let equipmentData = equipmentData else { return nil }
                return Equipment(equipmentData: equipmentData)
            })
        case .hours:
            times = detailData.times.compactMap({ facilityHoursData -> DailyFacilityHoursRanges? in
                guard let facilityHours = facilityHoursData else { return nil }
                return DailyFacilityHoursRanges(facilityHoursData: facilityHours)
            })
        case .prices:
            items = detailData.items.compactMap({ item -> String? in
                return item ?? nil
            })
            prices = detailData.prices.compactMap({ price -> String? in
                return price ?? nil
            })
        case .subfacilities:
            subfacilities = detailData.subFacilityNames.compactMap({ subfacility -> String? in
                return subfacility ?? nil
            })
        }
    }

    init?(detailData: GymByIdQuery.Data.Gym.Facility.Detail) {
        guard let detailType =  DetailType(rawValue: detailData.detailsType) else {
            return nil
        }
        self.detailType = detailType

        switch detailType {
        case .equipment:
            equipment = detailData.equipment.compactMap({ equipmentData -> Equipment? in
                guard let equipmentData = equipmentData else { return nil }
                return Equipment(equipmentData: equipmentData)
            })
        case .hours:
            times = detailData.times.compactMap({ facilityHoursData -> DailyFacilityHoursRanges? in
                guard let facilityHours = facilityHoursData else { return nil }
                return DailyFacilityHoursRanges(facilityHoursData: facilityHours)
            })
        case .prices:
            items = detailData.items.compactMap({ item -> String? in
                return item ?? nil
            })
            prices = detailData.prices.compactMap({ price -> String? in
                return price ?? nil
            })
        case .subfacilities:
            subfacilities = detailData.subFacilityNames.compactMap({ subfacility -> String? in
                return subfacility ?? nil
            })
        }
    }
}

struct Facility {

    var name: String
    var details: [FacilityDetail] = []

    init(facilityData: AllGymsQuery.Data.Gym.Facility) {
        name = facilityData.name
        details = facilityData.details.compactMap({ detailData -> FacilityDetail? in
            guard let detailData = detailData else { return nil }
            return FacilityDetail(detailData: detailData)
        })
    }

    init(facilityData: GymByIdQuery.Data.Gym.Facility) {
        name = facilityData.name
        details = facilityData.details.compactMap({ detailData -> FacilityDetail? in
            guard let detailData = detailData else { return nil }
            return FacilityDetail(detailData: detailData)
        })
    }
}

struct EquipmentCategory {
    let categoryName: String
    let equipment: [Equipment]
}

struct Equipment {

    var equipmentType: String = ""
    var name: String = ""
    var quantity: String = ""
    var workoutType: String = ""

    init(equipmentData: AllGymsQuery.Data.Gym.Facility.Detail.Equipment) {
        equipmentType = equipmentData.equipmentType
        name = equipmentData.name
        quantity = equipmentData.quantity
        workoutType = equipmentData.workoutType
    }

    init(equipmentData: GymByIdQuery.Data.Gym.Facility.Detail.Equipment) {
        equipmentType = equipmentData.equipmentType
        name = equipmentData.name
        quantity = equipmentData.quantity
        workoutType = equipmentData.workoutType
    }

}
