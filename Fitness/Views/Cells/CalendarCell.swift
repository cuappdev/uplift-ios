//
//  CalendarCell.swift
//  Fitness
//
//  Created by Keivan Shahida on 3/26/18.
//  Copyright © 2018 Uplift. All rights reserved.
//

import UIKit

class CalendarCell: UICollectionViewCell {

    // MARK: - INITIALIZATION
    static let identifier = Identifiers.calendarCell
    var date: String!
    var dateLabel: UILabel!
    var dateLabelCircle: UIView!
    var dayOfWeekLabel: UILabel!

    override func prepareForReuse() {
        dateLabelCircle.isHidden = true
        dateLabel.textColor = .fitnessBlack
        dayOfWeekLabel.textColor = .fitnessBlack
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .clear

        dateLabelCircle = UIView()
        dateLabelCircle.backgroundColor = .fitnessBlack
        dateLabelCircle.isHidden = true
        dateLabelCircle.layer.cornerRadius = 12
        addSubview(dateLabelCircle)

        dateLabel = UILabel()
        dateLabel.text = "15"
        dateLabel.font = ._12MontserratRegular
        dateLabel.textAlignment = .center
        dateLabel.textColor = .fitnessBlack
        dateLabel.sizeToFit()
        addSubview(dateLabel)

        dayOfWeekLabel = UILabel()
        dayOfWeekLabel.text = "Th"
        dayOfWeekLabel.font = ._12MontserratRegular
        dayOfWeekLabel.textAlignment = .center
        dayOfWeekLabel.textColor = .fitnessDarkGrey
        dayOfWeekLabel.sizeToFit()
        addSubview(dayOfWeekLabel)

        setConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - CONSTRAINTS
    func setConstraints() {
        dateLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(dayOfWeekLabel.snp.bottom).offset(12)
        }

        dayOfWeekLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
        }

        dateLabelCircle.snp.makeConstraints { make in
            make.height.width.equalTo(24)
            make.center.equalTo(dateLabel)
        }
    }
}
