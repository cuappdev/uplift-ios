//
//  GymCellFooter.swift
//  Uplift
//
//  Created by Elvis Marcelo on 3/22/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import Foundation
import UIKit

class GymCellFooter: UIView {
    private let hoursLabel = UILabel()
    private let locationNameLabel = UILabel()
    private let statusLabel = UILabel()
    private let capacityStatusLabel = UILabel()
    private let capacityCountLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupViews()
        setupConstraints()
    }

    func configure(for gym: Gym) {
        locationNameLabel.text = gym.name

        //set gym status
        let changingSoon = gym.isStatusChangingSoon()

        if(gym.isOpen) {
            statusLabel.textColor = changingSoon ? .accentOrange : .accentOpen
        } else {
            statusLabel.textColor = changingSoon ? .accentOrange : .accentClosed
        }

        statusLabel.text = gym.isOpen ? ClientStrings.CommonStrings.open : ClientStrings.CommonStrings.closed

        // Set gym hours
        hoursLabel.text = getHoursString(from: gym)

        capacityStatusLabel.text = "Cramped"
        capacityCountLabel.text = "120/140"
    }

    private func getHoursString(from gym: Gym) -> String {
        let now = Date()
        let isOpen = gym.isOpen

        let gymHoursToday = gym.gymHoursToday
        let gymHoursTomorrow = gym.gymHours[now.getIntegerDayOfWeekTomorrow()]

        let format: String

        if now > gymHoursToday.closeTime {
            format = gymHoursTomorrow.openTime.getHourFormat()
            if gym.closedTomorrow {
                return ClientStrings.CommonStrings.closed
            } else {
                return ClientStrings.Home.gymDetailCellOpensAt + gymHoursTomorrow.openTime.getStringOfDatetime(format: format)
            }
        } else if !isOpen {
            format = gymHoursToday.openTime.getHourFormat()
            return ClientStrings.Home.gymDetailCellOpensAt + (gymHoursToday.openTime.getStringOfDatetime(format: format))
        } else {
            format = gymHoursToday.closeTime.getHourFormat()
            let openTime = gymHoursToday.openTime.getStringOfDatetime(format: format)
            let closeTime = gymHoursToday.closeTime.getStringOfDatetime(format: format)

            return ClientStrings.Home.gymDetailCellClosesAt + closeTime
        }
    }

    private func setupViews() {
        locationNameLabel.font = ._16MontserratMedium
        locationNameLabel.textColor = .primaryBlack
        locationNameLabel.textAlignment = .left
        addSubview(locationNameLabel)

        statusLabel.font = ._12MontserratMedium
        addSubview(statusLabel)

        hoursLabel.font = ._12MontserratMedium
        hoursLabel.textColor = .gray02
        addSubview(hoursLabel)

        capacityStatusLabel.font = ._12MontserratMedium
        addSubview(capacityStatusLabel)

        capacityCountLabel.font = ._12MontserratMedium
        capacityCountLabel.textColor = .gray02
        addSubview(capacityCountLabel)
    }

    private func setupConstraints() {
        let descriptionLabelHeight = 15
        let leadingPadding = 16
        let locationLabelHeight = 22
        let topBottomLabelVerticalPadding = 8
        let statusHoursLabelPadding = 4
        let statusLabelTopPadding = 1
        let trailingPadding = 4

        locationNameLabel.snp.updateConstraints { make in
            make.top.equalToSuperview().offset(topBottomLabelVerticalPadding)
            make.leading.equalToSuperview().offset(leadingPadding)
            make.height.equalTo(locationLabelHeight)
            make.trailing.lessThanOrEqualToSuperview().inset(trailingPadding)
        }

        statusLabel.snp.updateConstraints { make in
            make.leading.equalTo(locationNameLabel)
            make.trailing.lessThanOrEqualToSuperview().inset(trailingPadding)
            make.height.equalTo(descriptionLabelHeight)
            make.bottom.equalTo(capacityStatusLabel.snp.top).offset(-statusLabelTopPadding)
        }

        hoursLabel.snp.updateConstraints { make in
            make.leading.equalTo(statusLabel.snp.trailing).offset(statusHoursLabelPadding)
            make.trailing.lessThanOrEqualToSuperview().inset(trailingPadding)
            make.height.equalTo(descriptionLabelHeight)
            make.centerY.equalTo(statusLabel.snp.centerY)
        }

        capacityStatusLabel.snp.updateConstraints { make in
            make.leading.equalTo(locationNameLabel)
            make.trailing.lessThanOrEqualToSuperview().inset(trailingPadding)
            make.height.equalTo(statusLabel)
            make.bottom.equalTo(capacityCountLabel.snp.bottom)
        }

        capacityCountLabel.snp.updateConstraints { make in
            make.leading.equalTo(capacityStatusLabel.snp.trailing).offset(statusHoursLabelPadding)
            make.height.equalTo(statusLabel)
            make.trailing.lessThanOrEqualToSuperview().inset(trailingPadding)
            make.bottom.equalToSuperview().offset(-topBottomLabelVerticalPadding)
        }

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

