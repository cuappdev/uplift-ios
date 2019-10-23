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
    private var dayLabel: UILabel!
    private var backCircle: UIView!

    // MARK: - Info
    /// Weekday this cell represents
    var day: WeekDay?
    /// Is this day today
    private var today: Bool = false

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

        backCircle = UIView()
        backCircle.layer.cornerRadius = circleSize / 2
        addSubview(backCircle)

        dayLabel = UILabel()
        dayLabel.font = ._12MontserratBold
        dayLabel.textAlignment = .center
        dayLabel.textColor = .primaryBlack
        addSubview(dayLabel)

        update()
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
        day = weekday
        let todayIndex = Calendar.current.component(.weekday, from: Date())
        self.today = todayIndex == day?.index
        dayLabel.text = weekday.rawValue
        update()
    }

    /// Updates the appearence of the cell when selection changes
    func update() {
        backCircle.alpha = isSelected || today ? 1 : 0
        backCircle.backgroundColor = isSelected ? .primaryYellow : .gray01
    }
}
