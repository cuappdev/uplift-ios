//
//  GymDetailTimeInfoView.swift
//  Uplift
//
//  Created by Phillip OReggio on 10/22/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import UIKit

class GymDetailTimeInfoView: UILabel {

    var facility: Facility
    private var selectedDayIndex = 0
    private var displayedText: String = ""
    private var timesText = NSMutableAttributedString()
    private var paragraphStyle = NSMutableParagraphStyle()

    init(facility: Facility) {
        self.facility = facility
        super.init(frame: CGRect())

        timesText.mutableString.setString(displayedText)

        paragraphStyle.lineSpacing = 5.0
        paragraphStyle.maximumLineHeight = 26
        paragraphStyle.alignment = .center
        updateAttributedText()

        attributedText = timesText
        backgroundColor = .primaryWhite
        numberOfLines = 0
        font = ._16MontserratRegular
        textColor = .primaryBlack
        textAlignment = .center

        updateTimes()
        updateTags()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Updates
    /// Updates appearence of view when information changes
    private func updateAppearence() {
        updateTimes()
        updateTags()
    }

    private func updateTimes() {
        displayedText = getDisplayText(dayIndex: selectedDayIndex)
        updateAttributedText()
        print("display: \(displayedText)")
    }

    /// Adds the additional information tag to certain times (ex: Woman Only swimming hours)
    private func updateTags() {
        let tagLabelWidth = 81
        let tagSideOffset = 25.0
        // Positioning constants relative to text
        let textLineHeight = font.lineHeight
        let timesTextHeight = timesText.string.height(withConstrainedWidth: bounds.width, font: font)
        var viewHeight = bounds.height
        if viewHeight == 0 {
            viewHeight = calculateMaxHeight(width: UIScreen.main.bounds.width)
        }
        let textBodyVerticalInset = (viewHeight - timesTextHeight) / 2.0

        subviews.forEach({ $0.removeFromSuperview() }) // remove all subviews

        let miscInfo = facility.miscInformation
        print("--miscInfo is: \(miscInfo)")
        for i in (0..<miscInfo.count) {
            if miscInfo[i] == "" { // Don't use blank tags
                continue
            } else { // Tag has content to display
                let infoView = AdditionalInfoView()
                infoView.text = miscInfo[i]
                addSubview(infoView)

                // Add to subview
                let inset = textLineHeight * CGFloat(i)
                let tinyOffset: CGFloat = 3.0
                infoView.snp.makeConstraints { make in
                    make.top.equalToSuperview().inset(textBodyVerticalInset + inset + tinyOffset)
                    make.trailing.equalToSuperview().inset(tagSideOffset)
                    make.width.equalTo(tagLabelWidth)
                }
            }
        }

        updateConstraints()
    }

    func updateAttributedText() {
        timesText.mutableString.setString(displayedText)
        timesText.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, timesText.length))
        attributedText = timesText
    }

    // MARK: - Helper
    func getDisplayText(dayIndex: Int) -> String {
        let dayTimes = facility.times.filter { $0.dayOfWeek == dayIndex }
        var display = ""
        dayTimes.forEach { time in
            display.append(getStringFromDailyGymHours(dailyGymHours: time))
           display += "\n"
        }

        return display
    }

    func getStringFromDailyGymHours(dailyGymHours: DailyGymHours) -> String {
        let openTime = dailyGymHours.openTime.getStringOfDatetime(format: "h:mm a")
        let closeTime = dailyGymHours.closeTime.getStringOfDatetime(format: "h:mm a")

        if dailyGymHours.openTime != dailyGymHours.closeTime {
            return "\(openTime) - \(closeTime)"
        }

        return ""
    }

    // MARK: - Sizing
    /// Calculate maximum height based of longes view
    func calculateMaxHeight(width: CGFloat) -> CGFloat {
        let contentPadding = 16.0

        // Look for longest possible display
        var longest = ""
        var newLineCount = 0
        for i in (0..<7) {
            // Find longest time sequence
            let cur = getDisplayText(dayIndex: i)
            let curLineCount = cur.filter { $0 == "\n" }.count
            if curLineCount > newLineCount {
                newLineCount = curLineCount
                longest = cur
            }
        }

        // Return Max Height + padding
        let display = NSMutableAttributedString()
        display.mutableString.setString(longest)
        display.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, timesText.length))

        return longest.height(withConstrainedWidth: width, font: font) + CGFloat(contentPadding * 2)
    }
}

// MARK: - Delegation
protocol WeekDelegate: class {
    func didChangeDay(day: WeekDay)
}

extension GymDetailTimeInfoView: WeekDelegate {
    func didChangeDay(day: WeekDay) {
        selectedDayIndex = day.index - 1
        updateAppearence()
    }
}
