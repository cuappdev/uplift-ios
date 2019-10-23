//
//  GymDetailTimeInfoView.swift
//  Uplift
//
//  Created by Phillip OReggio on 10/22/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import UIKit

class GymDetailTimeInfoView: UILabel {

    var facility: FakeFacility
    private var selectedDayIndex = 0
    private var displayedText: String = ""
    private var timesText = NSMutableAttributedString()

    init(facility: FakeFacility) {
        self.facility = facility
        super.init(frame: CGRect())


        // Hardcoded
        let hardtext =
        """
        7:00 AM - 7:45 AM
        8:00 AM - 8:45 AM
        11:00 AM - 1:30 PM
        5:00 PM - 6:30 PM
        8:30 PM - 10:00 PM
        7:00 AM - 7:45 AM
        8:00 AM - 8:45 AM
        11:00 AM - 1:30 PM
        5:00 PM - 6:30 PM
        8:30 PM - 10:00 PM
        """
        displayedText = hardtext


        timesText.mutableString.setString(displayedText)

        // Label Formatting
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5.0
        timesText.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedText?.length ?? 0))
        attributedText = timesText

        backgroundColor = .primaryWhite
        numberOfLines = 0
        font = ._16MontserratRegular
        textAlignment = .center

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
        // Filter to get times for day
        let dayTimes = facility.times.filter { $0.dayOfWeek == selectedDayIndex }
        dayTimes.forEach { time in
            displayedText.append(getStringFromDailyGymHours(dailyGymHours: time))
            displayedText += "\n"
        }
        timesText.mutableString.setString(displayedText)
    }

    /// Adds the additional information tag to certain times (ex: Woman Only swimming hours)
    private func updateTags() {
        let tagLabelWidth = 81
        let tagSideOffset = 25.0
        // Positioning constants relative to text
        let textLineHeight = font.lineHeight
        let timesTextHeight = timesText.string.height(withConstrainedWidth: bounds.width, font: font)
        let textBodyVerticalInset = (bounds.height - timesTextHeight) / 2.0

//        print("bounds: \(bounds)")
//        print("text line height: \(textLineHeight)")
//        print("timesTextHeight: \(timesTextHeight)")
//        print("textBodyVerticalInset: \(textBodyVerticalInset)")

        subviews.forEach({ $0.removeFromSuperview() }) // remove all subviews

//        let miscInfo = facility.miscInformation
        // HARDCODED
        let miscInfo = ["", "", "women only", "", "women only", "", "", "women only", "", ""]
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

    // MARK: - Helper
    func getStringFromDailyGymHours(dailyGymHours: FakeGymHours) -> String {
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
        updateAppearence()
    }
}

public struct FakeFacility {
    var times: [FakeGymHours]!
    var miscInfo: [String]

    init() {
        times = [FakeGymHours(), FakeGymHours(), FakeGymHours(), FakeGymHours(), FakeGymHours()]
        miscInfo = ["women only", "women only", "", "", "women only"]
    }
}

public struct FakeGymHours {
    var dayOfWeek: Int = Int.random(in: 0...6)
    var openTime: Date!
    var closeTime: Date!

    init() {
        openTime = Date().addingTimeInterval(TimeInterval(Double.random(in: (0.0...50.0))))
        closeTime = openTime.addingTimeInterval(TimeInterval(Double.random(in: (10.0...70.0))))
    }
}
