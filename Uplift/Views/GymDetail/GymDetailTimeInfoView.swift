//
//  GymDetailTimeInfoView.swift
//  Uplift
//
//  Created by Phillip OReggio on 10/22/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import UIKit

class GymDetailTimeInfoView: UIView {

    private let displayText: UITextView

    private var facility: Facility
    private var selectedDayIndex = 0
    private var displayedText = ""
    private var timesText = NSMutableAttributedString()
    private var paragraphStyle = NSMutableParagraphStyle()

    // MARK: - Init
    init(facility: Facility) {
        self.facility = facility
        displayText = UITextView()

        super.init(frame: CGRect())

        timesText.mutableString.setString(displayedText)

        paragraphStyle.lineSpacing = 5.0
        paragraphStyle.maximumLineHeight = 26
        paragraphStyle.alignment = .center

        displayText.attributedText = timesText
        displayText.backgroundColor = .primaryWhite
        displayText.font = ._16MontserratRegular
        displayText.textColor = .primaryBlack
        displayText.textAlignment = .center

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
        // func call to update tags
        updateTimes()
    }

    private func updateTimes() {
        displayedText = makeDisplayText(dayIndex: selectedDayIndex)
        updateAttributedText()
    }

    private func updateTags() {
        let tagLabelWidth = 81
        let tagSideOffset = 25.0
        let textLineHeight = displayText.font!.lineHeight

        let info = facility.miscInformation
        subviews.forEach({ $0.removeFromSuperview() })

        for i in 0..<info.count {
            if info[i] == "" { // Don't use blank tags
                continue
            } else {
                let infoView = SidebarView()
                let spacing = textLineHeight * CGFloat(i)
                let inset: CGFloat = 2

                infoView.text = info[i]
                addSubview(infoView)
                infoView.snp.makeConstraints { make in
                    make.top.equalToSuperview().inset(spacing + inset)
                    make.trailing.equalToSuperview().inset(tagSideOffset)
                    make.width.equalTo(tagLabelWidth)
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
        let dayTimes = facility.times.filter { $0.dayOfWeek == dayIndex }
        let timeStrings: [String] = dayTimes.map { getStringFromDailyGymHours(dailyGymHours: $0) }
        return timeStrings.joined(separator: "\n")
    }

    func getStringFromDailyGymHours(dailyGymHours: DailyGymHours) -> String {
        let openTime = dailyGymHours.openTime.getStringOfDatetime(format: "h:mm a")
        let closeTime = dailyGymHours.closeTime.getStringOfDatetime(format: "h:mm a")

        if dailyGymHours.openTime != dailyGymHours.closeTime {
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
