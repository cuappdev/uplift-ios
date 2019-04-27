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
    
    static let identifier = Identifiers.habitTrackerCheckinCell
    
    var checkinCircle: UIButton!
    var titleLabel: UILabel!
    var streakLabel: UILabel!
    var separator: UIView!
    
    var habit: Habit!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        checkinCircle = UIButton()
        checkinCircle.translatesAutoresizingMaskIntoConstraints = false
        checkinCircle.setImage(UIImage(named: "empty_circle"), for: .normal) // todo -images
        checkinCircle.setImage(UIImage(named: "checked_circle"), for: .selected)
        checkinCircle.addTarget(self, action: #selector(checkIn), for: .touchUpInside)
        contentView.addSubview(checkinCircle)
        
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = .fitnessBlack
        titleLabel.font = ._16MontserratMedium
        contentView.addSubview(titleLabel)
        
        streakLabel = UILabel()
        streakLabel.translatesAutoresizingMaskIntoConstraints = false
        streakLabel.textColor = .black
        streakLabel.font = ._16MontserratBold
        contentView.addSubview(streakLabel)
        
        separator = UIView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = .fitnessLightGrey
        contentView.addSubview(separator)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        checkinCircle.snp.makeConstraints { make in
            make.height.width.equalTo(23)
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }

        streakLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-32)
            make.height.equalTo(22)
            make.centerY.equalToSuperview()
            make.width.equalTo(36)  // todo - adjust once we have the streak
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(checkinCircle.snp.trailing).offset(11).priority(.high)
            make.centerY.equalToSuperview()
            make.height.equalTo(22)
            make.trailing.lessThanOrEqualTo(streakLabel.snp.leading).offset(-2)

        }
        
        separator.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-32).priority(.high)
            make.bottom.equalToSuperview()
        }
    }
    
    func configure(habit: Habit) {
        self.habit = habit
        
        titleLabel.text = habit.title
        streakLabel.text = getStreakEmoji()
        
        if let mostRecentCheckin = habit.dates.sorted().last {
            if Date() - 86400.0 < mostRecentCheckin {
                checkinCircle.isSelected = true
                
                let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: habit.title)
                attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
                titleLabel.attributedText = attributeString
                titleLabel.textColor = .fitnessMediumGrey
            }
        }
    }
    
    @objc func checkIn() {
        switch checkinCircle.isSelected {
        case true:
            Habit.removeDate(habit: habit, date: Date())
            habit.dates.removeFirst()
            
            titleLabel.attributedText = nil
            titleLabel.text = habit.title
            titleLabel.textColor = .fitnessBlack
        case false:
            Habit.logDate(habit: habit, date: Date())
            
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: habit.title)
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
            titleLabel.attributedText = attributeString
            titleLabel.textColor = .fitnessMediumGrey
        }
        
        habit = Habit.getHabit(habit: habit.title, type: habit.type)
        
        checkinCircle.isSelected.toggle()
        streakLabel.text = getStreakEmoji()
    }
    
    func getStreakEmoji() -> String {
        let streak = habit.streak
        
        if streak <= 1 {
            return ""
        }
        
        let level: Int
        if streak < 3 {
            level = 0
        } else if streak < 5 {
            level = 1
        } else if streak < 8 {
            level = 2
        } else if streak < 10 {
            level = 3
        } else if streak < 14 {
            level = 4
        } else if streak < 20 {
            level = 5
        } else if streak < 30 {
            level = 6
        } else {
            level = 7
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
