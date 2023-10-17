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

    func configure(for fitnessCenter: FitnessCenter) {

        locationNameLabel.text = fitnessCenter.name

        if fitnessCenter.isStatusChangingSoon() {
            statusLabel.textColor = .accentOrange
        } else {
            statusLabel.textColor = fitnessCenter.isOpen() ? .accentOpen : .accentClosed
        }
        statusLabel.text = fitnessCenter.isOpen() ? ClientStrings.CommonStrings.open : ClientStrings.CommonStrings.closed

        hoursLabel.text = fitnessCenter.getHoursString()

        if let capacityStatus = fitnessCenter.getCapacityStatus(), let percentStr = fitnessCenter.getCapacityPercent() {
            capacityStatusLabel.isHidden = false
            capacityCountLabel.isHidden = false
            capacityStatusLabel.text = capacityStatus.rawValue
            capacityCountLabel.text = "\(percentStr) full"
            switch capacityStatus {
            case .Light:
                capacityStatusLabel.textColor = .accentOpen
            case .Cramped:
                capacityStatusLabel.textColor = .accentOrange
            case .Full:
                capacityStatusLabel.textColor = .accentRed
            }
        } else {
            capacityStatusLabel.isHidden = true
            capacityCountLabel.isHidden = true
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
        let statusLabelTopPadding = 4
        let statusHoursLabelPadding = 4
        let capacityTopPadding = 2
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
            make.top.equalTo(locationNameLabel.snp.bottom).offset(statusLabelTopPadding)
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
             make.top.equalTo(statusLabel.snp.bottom).offset(capacityTopPadding)
         }

         capacityCountLabel.snp.updateConstraints { make in
             make.leading.equalTo(capacityStatusLabel.snp.trailing).offset(statusHoursLabelPadding)
             make.height.equalTo(capacityStatusLabel)
             make.trailing.lessThanOrEqualToSuperview().inset(trailingPadding)
             make.top.equalTo(capacityStatusLabel)
         }

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
