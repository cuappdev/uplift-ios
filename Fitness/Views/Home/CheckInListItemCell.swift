//
//  CheckInListItemCell.swift
//  Fitness
//
//  Created by Joseph Fulgieri on 4/23/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import SnapKit
import UIKit

class CheckInListItemCell: ListItemCollectionViewCell<Habit> {
    
    // MARK: - Public static vars
    static let identifier = Identifiers.habitTrackerCheckinCell

    // MARK: - Private view vars
    private let checkInButton = UIButton()
    private let dividerView = UIView()
    private let streakLabel = UILabel()
    private let titleLabel = UILabel()

    // MARK: - Private data vars
    private var habit: Habit!

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
        setupConstraints()
    }

    // MARK: - Overrides
    override func configure(for item: Habit) {
        habit = item
        titleLabel.text = habit.title
        streakLabel.text = getStreakEmoji()

        if let mostRecentCheckin = habit.dates.sorted().last {
            if Date() - Date.secondsPerDay < mostRecentCheckin {
                checkInButton.isSelected = true

                let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: habit.title)
                attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
                titleLabel.attributedText = attributeString
                titleLabel.textColor = .fitnessMediumGrey
            }
        }
    }

    // MARK: - Private helpers
    private func setupViews() {
        checkInButton.setImage(UIImage(named: "empty_circle"), for: .normal)
        checkInButton.setImage(UIImage(named: "checked_circle"), for: .selected)
        checkInButton.addTarget(self, action: #selector(checkIn), for: .touchUpInside)
        contentView.addSubview(checkInButton)

        titleLabel.textColor = .fitnessBlack
        titleLabel.font = ._16MontserratMedium
        contentView.addSubview(titleLabel)

        streakLabel.textColor = .black
        streakLabel.font = ._16MontserratBold
        contentView.addSubview(streakLabel)

        dividerView.backgroundColor = .fitnessLightGrey
        contentView.addSubview(dividerView)
    }

    private func setupConstraints() {
        let checkInButtonDiameter = 23
        let dividerViewHeight = 1
        let labelHeight = 22
        let leadingPadding = 16
        let streakLabelWidth = 36
        let titleLabelLeftPadding = 11
        let titleLabelRightPadding = 2
        let trailingPadding = 32

        checkInButton.snp.makeConstraints { make in
            make.height.width.equalTo(checkInButtonDiameter)
            make.leading.equalToSuperview().inset(leadingPadding)
            make.centerY.equalToSuperview()
        }

        streakLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(trailingPadding)
            make.height.equalTo(labelHeight)
            make.centerY.equalToSuperview()
            make.width.equalTo(streakLabelWidth)
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(checkInButton.snp.trailing).offset(titleLabelLeftPadding).priority(.high)
            make.centerY.equalToSuperview()
            make.height.equalTo(labelHeight)
            make.trailing.lessThanOrEqualTo(streakLabel.snp.leading).offset(-titleLabelRightPadding)

        }

        dividerView.snp.makeConstraints { make in
            make.height.equalTo(dividerViewHeight)
            make.leading.equalToSuperview().inset(leadingPadding)
            make.trailing.equalToSuperview().inset(trailingPadding).priority(.high)
            make.bottom.equalToSuperview()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.textColor = .fitnessBlack
        checkInButton.isSelected = false
    }
    
    @objc private func checkIn() {
        if checkInButton.isSelected {
            Habit.removeDate(habit: habit, date: Date())
            habit.dates.removeFirst()

            titleLabel.attributedText = nil
            titleLabel.text = habit.title
            titleLabel.textColor = .fitnessBlack
        } else {
            Habit.logDate(habit: habit, date: Date())

            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: habit.title)
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
            titleLabel.attributedText = attributeString
            titleLabel.textColor = .fitnessMediumGrey
        }
        
        habit = Habit.getHabit(habit: habit.title, type: habit.type)

        checkInButton.isSelected.toggle()
        streakLabel.text = getStreakEmoji()
    }

    private func getStreakEmoji() -> String {
        let streak = habit.streak

        if streak <= 1 {
            return ""
        }

        // Stores pairs of form [level:upper threshold (not inclusive)]
        let levelThresholdDict = [
            0: 3,
            1: 5,
            2: 8,
            3: 10,
            4: 14,
            5: 20,
            6: 30,
            7: Int.max
        ]

        var level = 0
        for (potentialLevel, threshold) in levelThresholdDict {
            if streak < threshold {
                level = potentialLevel
                break
            }
        }

        switch habit.type {
        case .cardio:
            return "\(["💧", "💦", "🌧", "⛲️", "🌊", "🏝", "🧜‍♀️", "🌏"][level]) \(streak)"
        case .strength:
            return "\(["🐛", "🦋", "🦔", "🐒", "🦍", "🦏", "🐆", "🐉"][level]) \(streak)"
        case .mindfulness:
            return "\(["☁️", "🚁", "✈️", "🚀", "👨‍🚀", "🛰", "🛸", "🌞"][level]) \(streak)"
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
