//
//  GymWeekCell.swift
//  Uplift
//
//  Created by Phillip OReggio on 10/6/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import UIKit
import SnapKit

class GymWeekCell: UICollectionViewCell {

    // MARK: - Views
    private let dayLabel = UILabel()
    private let backCircle = UIView()

    // MARK: - Inits
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup
    private func setupViews() {
        let circleSize: CGFloat = 24

        backCircle.layer.cornerRadius = circleSize / 2
        addSubview(backCircle)

        dayLabel.font = ._12MontserratBold
        dayLabel.textAlignment = .center
        dayLabel.textColor = .primaryBlack
        addSubview(dayLabel)
    }

    private func setupConstraints() {
        backCircle.snp.makeConstraints { make in
            make.center.size.equalToSuperview()
        }

        dayLabel.snp.makeConstraints { make in
            make.center.equalTo(backCircle)
        }
    }

    // MARK: - Functionality
    func configure(weekDay: WeekDay, isSelected: Bool) {
        let todayIndex = Calendar.current.component(.weekday, from: Date())
        let isToday = todayIndex == weekDay.rawValue
        backCircle.alpha = isSelected || isToday ? 1 : 0
        backCircle.backgroundColor = isSelected ? .primaryYellow : .gray01
        dayLabel.text = weekDay.dayAbbreviation
    }
}
