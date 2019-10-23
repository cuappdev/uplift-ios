//
//  GymDetailTimeInfoView.swift
//  Uplift
//
//  Created by Phillip OReggio on 10/22/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import UIKit

class GymDetailTimeInfoView: UILabel {

    private var timesText = NSMutableAttributedString()
    private var hours: [DailyGymHours]

    override init(frame: CGRect) {
        super.init(frame: frame)

        // Backend Request to get hours and tags for day
        //...
        hours = []

        // Hardcoded
        let hardtext =
        """
        7:00 AM - 7:45 AM
        8:00 AM - 8:45 AM
        11:00 AM - 1:30 PM
        5:00 PM - 6:30 PM
        8:30 PM - 10:00 PM
        """
        timesText.mutableString.setString(hardtext)

        // Label Formatting
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5.0
        timesText.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedText?.length ?? 0))
        attributedText = timesText

        backgroundColor = .fitnessWhite
        numberOfLines = 0
        font = ._16MontserratRegular
        textAlignment = .center

        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {

    }

    // MARK: - ..???

    // MARK: - Helper

    func getStringFromFacility(facilities: DailyGymHours) -> String {
        let openTime = facilities.openTime.getStringOfDatetime(format: "h:mm a")
        let closeTime = facilities.closeTime.getStringOfDatetime(format: "h:mm a")

        if facilities.openTime != dailyGymHours.closeTime {
            return "\(openTime) - \(closeTime)"
        }

    }
}

// MARK: - Delegation
protocol WeekDelegate {
    func didChangeDay(day: WeekDay)
}

extension GymDetailTimeInfoView: WeekDelegate {
    func didChangeDay(day: WeekDay) {
        // Backend Request to update hours and
    }
}
