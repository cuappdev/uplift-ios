//
//  GymListItemCell.swift
//  Uplift
//
//  Created by Joseph Fulgieri on 3/7/18.
//  Copyright © 2018 Uplift. All rights reserved.
//

import SnapKit
import UIKit

class GymListItemCell: ListItemCollectionViewCell<Gym> {

    // MARK: - Public static vars
    static let identifier = Identifiers.gymsCell

    // MARK: - Private view vars
    private let colorBar = UIView()
    private let hoursLabel = UILabel()
    private let locationNameLabel = UILabel()
    private let shadowView = UIView()
    private let statusLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        // BORDER
        contentView.layer.cornerRadius = 5
        contentView.layer.backgroundColor = UIColor.white.cgColor
        contentView.layer.borderColor = UIColor.fitnessLightGrey.cgColor
        contentView.layer.borderWidth = 0.5

        // SHADOWING
        contentView.layer.shadowColor = UIColor.fitnessBlack.cgColor
        contentView.layer.shadowOffset = CGSize(width: 0.0, height: 15.0)
        contentView.layer.shadowRadius = 5.0
        contentView.layer.shadowOpacity = 0.1
        contentView.layer.masksToBounds = false
        let shadowFrame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 9, right: -3))
        contentView.layer.shadowPath = UIBezierPath(roundedRect: shadowFrame, cornerRadius: 5).cgPath

        setupViews()
        setupConstraints()
    }

    // MARK: - Public configure
    override func configure(for gym: Gym) {
        super.configure(for: gym)

        // Set gym name
        locationNameLabel.text = gym.name

        // Set gym status
        let changingSoon = gym.isStatusChangingSoon()
        if gym.isOpen {
            if changingSoon {
                statusLabel.textColor = .fitnessOrange
                statusLabel.text = "Closing soon"
            } else {
                statusLabel.textColor = .fitnessGreen
                statusLabel.text = "Open"
            }
        } else {
            if changingSoon {
                statusLabel.textColor = .fitnessOrange
                statusLabel.text = "Opening soon"
            } else {
                statusLabel.textColor = .fitnessRed
                statusLabel.text = "Closed"
            }
        }

        // Set gym hours
        hoursLabel.text = getHoursString(from: gym)
    }

    // MARK: - Private helpers
    private func getHoursString(from gym: Gym) -> String {
        let now = Date()
        let isOpen = gym.isOpen

        let gymHoursToday = gym.gymHoursToday
        let gymHoursTomorrow = gym.gymHours[now.getIntegerDayOfWeekTomorrow()]

        let format: String

        if now > gymHoursToday.closeTime {
            format = gymHoursTomorrow.openTime.getHourFormat()
            if gym.closedTomorrow {
                return "Closed Tomorrow"
            } else {
                return "Opens at \(gymHoursTomorrow.openTime.getStringOfDatetime(format: format))"
            }
        } else if !isOpen {
            format = gymHoursToday.openTime.getHourFormat()
            return "Opens at \(gymHoursToday.openTime.getStringOfDatetime(format: format))"
        } else {
            format = gymHoursToday.closeTime.getHourFormat()
            let openTime = gymHoursToday.openTime.getStringOfDatetime(format: format)
            let closeTime = gymHoursToday.closeTime.getStringOfDatetime(format: format)

            return "\(openTime) - \(closeTime)"
        }
    }

    private func setupViews() {
        // YELLOW BAR
        colorBar.backgroundColor = .fitnessYellow
        colorBar.clipsToBounds = true
        colorBar.layer.cornerRadius = 5
        colorBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        contentView.addSubview(colorBar)

        locationNameLabel.font = ._16MontserratMedium
        locationNameLabel.textColor = .fitnessBlack
        locationNameLabel.textAlignment = .left
        contentView.addSubview(locationNameLabel)

        statusLabel.font = ._14MontserratMedium
        contentView.addSubview(statusLabel)

        hoursLabel.font = ._14MontserratMedium
        hoursLabel.textColor = .fitnessDarkGrey
        contentView.addSubview(hoursLabel)
    }

    private func setupConstraints() {
        let colorBarWidth = 5
        let descriptionLabelHeight = 15
        let hoursLabelTopPadding = 3
        let leadingPadding = 16
        let locationLabelHeight = 22
        let locationLabelVerticalInset = 12
        let statusLabelTopPadding = 6
        let trailingPadding = 4

        colorBar.snp.updateConstraints { make in
            make.leading.equalToSuperview()
            make.height.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(colorBarWidth)
        }

        locationNameLabel.snp.updateConstraints { make in
            make.top.equalToSuperview().offset(locationLabelVerticalInset)
            make.leading.equalToSuperview().offset(leadingPadding)
            make.height.equalTo(locationLabelHeight)
            make.trailing.lessThanOrEqualToSuperview().inset(trailingPadding)
        }

        statusLabel.snp.updateConstraints { make in
            make.leading.equalTo(locationNameLabel)
            make.trailing.lessThanOrEqualToSuperview().inset(trailingPadding)
            make.height.equalTo(descriptionLabelHeight)
            make.top.equalTo(locationNameLabel.snp.bottom).offset(statusLabelTopPadding)
        }

        hoursLabel.snp.updateConstraints { make in
            make.leading.equalTo(statusLabel.snp.trailing).offset(4)
            make.trailing.lessThanOrEqualToSuperview().inset(trailingPadding)
            make.height.equalTo(descriptionLabelHeight)
//            make.top.equalTo(statusLabel.snp.bottom).offset(hoursLabelTopPadding)
            make.centerY.equalTo(statusLabel.snp.centerY)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
