//
//  HabitTrackerCheckinCell.swift
//  Fitness
//
//  Created by Joseph Fulgieri on 4/23/19.
//  Copyright © 2019 Keivan Shahida. All rights reserved.
//

import SnapKit
import UIKit

class HabitTrackerCheckinCell: UICollectionViewCell {
    
    // MARK: - INITIALIZATION
    static let identifier = Identifiers.habitTrackerCheckinCell
    
    private var checkinButton: UIButton!
    private var separator: UIView!
    private var streakLabel: UILabel!
    private var titleLabel: UILabel!
    
    private var habit: Habit!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        checkinButton = UIButton()
        checkinButton.setImage(UIImage(named: "empty_circle"), for: .normal)
        checkinButton.setImage(UIImage(named: "checked_circle"), for: .selected)
        checkinButton.addTarget(self, action: #selector(checkIn), for: .touchUpInside)
        contentView.addSubview(checkinButton)
        
        titleLabel = UILabel()
        titleLabel.textColor = .fitnessBlack
        titleLabel.font = ._16MontserratMedium
        contentView.addSubview(titleLabel)
        
        streakLabel = UILabel()
        streakLabel.textColor = .black
        streakLabel.font = ._16MontserratBold
        contentView.addSubview(streakLabel)
        
        separator = UIView()
        separator.backgroundColor = .fitnessLightGrey
        contentView.addSubview(separator)
        
        setupConstraints()
    }
    
    // MARK: - CONSTRAINTS
    private func setupConstraints() {
        let checkinButtonDiameter = 23
        let labelHeight = 22
        let separatorHeight = 1
        let streakLabelWidth = 36
        
        let leadingPadding = 16
        let trailingPadding = 32
        
        checkinButton.snp.makeConstraints { make in
            make.height.width.equalTo(checkinButtonDiameter)
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
            make.leading.equalTo(checkinButton.snp.trailing).offset(11).priority(.high)
            make.centerY.equalToSuperview()
            make.height.equalTo(labelHeight)
            make.trailing.lessThanOrEqualTo(streakLabel.snp.leading).offset(-2)

        }
        
        separator.snp.makeConstraints { make in
            make.height.equalTo(separatorHeight)
            make.leading.equalToSuperview().inset(leadingPadding)
            make.trailing.equalToSuperview().inset(trailingPadding).priority(.high)
            make.bottom.equalToSuperview()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.textColor = .fitnessBlack
        checkinButton.isSelected = false
    }
    
    func configure(habit: Habit) {
        self.habit = habit
        
        titleLabel.text = habit.title
        streakLabel.text = getStreakEmoji()
        
        if let mostRecentCheckin = habit.dates.sorted().last {
            if Date() - Date.secondsPerDay < mostRecentCheckin {
                checkinButton.isSelected = true
                
                let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: habit.title)
                attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
                titleLabel.attributedText = attributeString
                titleLabel.textColor = .fitnessMediumGrey
            }
        }
    }
    
    @objc private func checkIn() {
        if checkinButton.isSelected {
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
        
        checkinButton.isSelected.toggle()
        streakLabel.text = getStreakEmoji()
    }
    
    private func getStreakEmoji() -> String {
        let streak = habit.streak
        
        if streak <= 1 {
            return ""
        }
        
        // Stores pairs of form [level:upper threshold (not inclusive)]
        let levelThresholdDict = [ 0:3, 1:5, 2:8, 3:10, 4:14, 5:20, 6:30, 7:Int.max ]
        
        var level = 0
        for (potentialLevel, threshold) in levelThresholdDict {
            if streak < threshold {
                level = potentialLevel
                break
            }
        }
        
        switch habit.type {
        case .cardio:
            return "\(["💧","💦","🌧","⛲️","🌊", "🏝","🧜‍♀️","🌏"][level]) \(streak)"
        case .strength:
            return "\(["🐛","🦋","🦔","🐒","🦍","🦏","🐆","🐉"][level]) \(streak)"
        case .mindfulness:
            return "\(["☁️","🚁","✈️","🚀","👨‍🚀","🛰","🛸","🌞"][level]) \(streak)"
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
