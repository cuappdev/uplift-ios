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
            make.leading.equalTo(checkinCircle.snp.trailing).offset(11)
            make.centerY.equalToSuperview()
            make.height.equalTo(22)
            make.trailing.lessThanOrEqualTo(streakLabel.snp.leading).offset(-2)

        }
        
        // todo - fix nonsensical constraint error
        separator.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-32)
            make.bottom.equalToSuperview()
        }
    }
    
    func configure(habit: Habit) {
        titleLabel.text = habit.title
        
        let streak = habit.streak
        if streak > 1 {
            streakLabel.text = getStreakEmoji(streak: streak, type: habit.type) + String(habit.streak)
        }
        
        if let mostRecentCheckin = habit.dates.sorted().last {
            if Date() - 86400.0 < mostRecentCheckin {
                checkinCircle.isSelected = true
                
                let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: habit.title)
                attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
                titleLabel.attributedText = attributeString
                titleLabel.textColor = .fitnessMediumGrey
            }
        }
        
        self.habit = habit
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
        
        let streak = habit.streak
        if streak > 1 {
            streakLabel.text = getStreakEmoji(streak: streak, type: habit.type) + String(habit.streak)
        } else {
            streakLabel.text = ""
        }
    }
    
    func getStreakEmoji(streak: Int, type: HabitTrackingType) -> String {
        // TODO
        
        return "🌈 "
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
