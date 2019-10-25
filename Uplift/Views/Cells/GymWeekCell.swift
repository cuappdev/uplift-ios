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

    // MARK: - Info
    var weekDay: WeekDay!
    private var isToday: Bool = false

    override var isSelected: Bool {
      didSet {
        backCircle.alpha = isSelected || isToday ? 1 : 0
        backCircle.backgroundColor = isSelected ? .fitnessYellow : .fitnessLightGrey
      }
    }

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
        dayLabel.textColor = .fitnessBlack
        addSubview(dayLabel)
    }

    private func setupConstraints() {
        backCircle.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalToSuperview()
        }

        dayLabel.snp.makeConstraints { make in
            make.center.equalTo(backCircle)
        }
    }

    // MARK: - Functionality
    func configure(weekday: WeekDay) {
        weekDay = weekday
        let todayIndex = Calendar.current.component(.weekday, from: Date())
        self.isToday = todayIndex == weekDay.index
        dayLabel.text = weekday.rawValue
    }
}
