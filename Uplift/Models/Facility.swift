//
//  Facility.swift
//  Uplift
//
//  Created by Kevin Chan on 12/4/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import Foundation

enum FacilityType: String {
    case bowling = "Bowling Alley"
    case fitnessCenter = "Fitness Center"
    case gymnasium = "Gymnasium"
    case miscellaneous = "Miscellaneous"
    case pool = "Pool"
}

struct Facility {

    var facilityType: FacilityType
    var details: [FacilityDetail] = []

    init(facilityData: AllGymsQuery.Data.Gym.Facility, facilityType: FacilityType) {
        self.facilityType = facilityType
        details = facilityData.details.compactMap({ detailData -> FacilityDetail? in
            guard let detailData = detailData,
                let detailType = DetailType(rawValue: detailData.detailsType) else { return nil }
            return FacilityDetail(detailData: detailData, detailType: detailType)
        })
    }

    init(facilityData: GymByIdQuery.Data.Gym.Facility, facilityType: FacilityType) {
        self.facilityType = facilityType
        details = facilityData.details.compactMap({ detailData -> FacilityDetail? in
            guard let detailData = detailData,
                let detailType = DetailType(rawValue: detailData.detailsType) else { return nil }
            return FacilityDetail(detailData: detailData, detailType: detailType)
        })
    }
}

// MARK: - Facility Detail

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

    init(detailData: AllGymsQuery.Data.Gym.Facility.Detail, detailType: DetailType) {
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
            items = detailData.items.compactMap({ $0 })
            prices = detailData.prices.compactMap({ $0 })
        case .subfacilities:
            subfacilities = detailData.subFacilityNames.compactMap({ $0 })
        }
    }

    init(detailData: GymByIdQuery.Data.Gym.Facility.Detail, detailType: DetailType) {
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
            items = detailData.items.compactMap({ $0 })
            prices = detailData.prices.compactMap({ $0 })
        case .subfacilities:
            subfacilities = detailData.subFacilityNames.compactMap({ $0 })
        }
    }

    func getEquipmentCategories() -> [EquipmentCategory] {
        var equipmentDict = [String: [Equipment]]()
        equipment.forEach { equipmentItem in
            equipmentDict[equipmentItem.equipmentType, default: []].append(equipmentItem)
        }

        let equipmentCategories = equipmentDict.compactMap { tuple in
            EquipmentCategory(categoryName: tuple.key, equipment: tuple.value.sorted {
                $0.name < $1.name
            })
        }.sorted { $0.categoryName < $1.categoryName }

        return equipmentCategories
    }
}

// MARK: - Hours

class DailyFacilityHoursRanges {

    var dayOfWeek: Int
    var timeRanges: [FacilityHoursRange]
    var isSelected: Bool

    init(facilityHoursData: AllGymsQuery.Data.Gym.Facility.Detail.Time) {
        dayOfWeek = facilityHoursData.day
        timeRanges = facilityHoursData.timeRanges.compactMap({ rangeData -> FacilityHoursRange? in
            guard let rangeData = rangeData else { return nil }
            return FacilityHoursRange(facilityHoursRangeData: rangeData)
        })
        let dayIndexOfToday = Date().getIntegerDayOfWeekToday()
        isSelected = dayOfWeek == dayIndexOfToday
    }

    init(facilityHoursData: GymByIdQuery.Data.Gym.Facility.Detail.Time) {
        dayOfWeek = facilityHoursData.day
        timeRanges = facilityHoursData.timeRanges.compactMap({ rangeData -> FacilityHoursRange? in
            guard let rangeData = rangeData else { return nil }
            return FacilityHoursRange(facilityHoursRangeData: rangeData)
        })
        let dayIndexOfToday = Date().getIntegerDayOfWeekToday()
        isSelected = dayOfWeek == dayIndexOfToday
    }

}

struct FacilityHoursRange {

    var openTime: Date
    var closeTime: Date
    var specialHours: Bool
    var restrictions: String

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

// MARK: - Equipment

struct EquipmentCategory {
    let categoryName: String
    let equipment: [Equipment]
}

struct Equipment {

    var equipmentType: String
    var name: String
    var quantity: String
    var workoutType: String

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
