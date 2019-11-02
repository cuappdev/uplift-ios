//
//  GymDetailTimeInfoView.swift
//  Uplift
//
//  Created by Phillip OReggio on 10/22/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import UIKit

class GymDetailTimeInfoView: UIView {

    private let displayText = UITextView()

    private var facilityDetail: FacilityDetail
    private var selectedDayIndex = 0
    private var displayedText = ""
    private var timesText = NSMutableAttributedString()
    private var paragraphStyle = NSMutableParagraphStyle()

    // MARK: - Init
    init(facilityDetail: FacilityDetail) {
        self.facilityDetail = facilityDetail
        super.init(frame: .zero)

        timesText.mutableString.setString(displayedText)

        paragraphStyle.lineSpacing = 5.0
        paragraphStyle.maximumLineHeight = 26
        paragraphStyle.alignment = .center

        displayText.attributedText = timesText
        displayText.backgroundColor = .primaryWhite
        displayText.font = ._16MontserratRegular
        displayText.textColor = .primaryBlack
        displayText.textAlignment = .center
        addSubview(displayText)

        setupConstraints()
        updateAppearance()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupConstraints() {
        displayText.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    // MARK: - Update
    private func updateAppearance() {
        // Update Tags
        updateTimes()
    }

    private func updateTimes() {
        displayedText = makeDisplayText(dayIndex: selectedDayIndex)
        updateAttributedText()
    }

    private func updateTags() {
        let tagLabelWidth = 81
        let tagLabelHeight = 17
        let tagSideOffset = 25.0
        let textLineHeight = displayText.font?.lineHeight ?? 0

        let dailyFacilityHoursRange = facilityDetail.times.filter { $0.dayOfWeek == selectedDayIndex }
        let restrictions = dailyFacilityHoursRange.flatMap { $0.timeRanges.map { $0.restrictions} }

        subviews.forEach({ $0.removeFromSuperview() })

        for i in 0..<restrictions.count {
            if restrictions[i].isEmpty { // Ignore Blank Tags
                continue
            } else {
                let restrictionView = AdditionalInfoView()
                let spacing = textLineHeight * CGFloat(i)
                let inset: CGFloat = 2

                restrictionView.text = restrictions[i]
                addSubview(restrictionView)
                restrictionView.snp.makeConstraints { make in
                    make.top.equalToSuperview().inset(spacing + inset)
                    make.trailing.equalToSuperview().inset(tagSideOffset)
                    make.width.equalTo(tagLabelWidth)
                    make.height.equalTo(tagLabelHeight)
                }
            }
        }

        updateConstraints()
    }

    func updateAttributedText() {
        timesText.mutableString.setString(displayedText)
        let range = NSRange(location: 0, length: timesText.length)
        timesText.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: range)
        displayText.attributedText = timesText
    }

    // MARK: - Helper
    func makeDisplayText(dayIndex: Int) -> String {
        let dailyFacilityHoursRange = facilityDetail.times.filter { $0.dayOfWeek == dayIndex }
        let facilityHoursRange = dailyFacilityHoursRange.flatMap { $0.timeRanges }
        let timeStrings: [String] = facilityHoursRange.map { getStringFromDailyGymHours(facilityHours: $0) }
        return timeStrings.joined(separator: "\n")
    }

    func getStringFromDailyGymHours(facilityHours: FacilityHoursRange) -> String {
        let openTime = facilityHours.openTime.getStringOfDatetime(format: "h:mm a")
        let closeTime = facilityHours.closeTime.getStringOfDatetime(format: "h:mm a")

        if facilityHours.openTime != facilityHours.closeTime {
            return "\(openTime) - \(closeTime)"
        }

        return ""
    }
}

// MARK: - Delegation
protocol WeekDelegate: class {
    func didChangeDay(day: WeekDay)
}

extension GymDetailTimeInfoView: WeekDelegate {
    func didChangeDay(day: WeekDay) {
        selectedDayIndex = day.index - 1
        updateAppearance()
    }
}
