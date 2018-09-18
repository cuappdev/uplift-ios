//
//  GymHoursCell.swift
//  Fitness
//
//  Created by Joseph Fulgieri on 4/18/18.
//  Copyright © 2018 Keivan Shahida. All rights reserved.
//

import UIKit
import SnapKit

class GymHoursCell: UITableViewCell {

    // MARK: - INITIALIZATION
    static let identifier = Identifiers.gymHoursCell
    var dayLabel: UILabel!
    var hoursLabel: UILabel!

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        hoursLabel = UILabel()
        hoursLabel.font = ._16MontserratLight
        hoursLabel.textColor = .fitnessBlack
        hoursLabel.textAlignment = .center
        hoursLabel.sizeToFit()
        hoursLabel.text = "6: 00 AM - 9: 00 PM"
        contentView.addSubview(hoursLabel)

        dayLabel = UILabel()
        dayLabel.font = ._14MontserratMedium
        dayLabel.textColor = .fitnessBlack
        dayLabel.sizeToFit()
        dayLabel.text = "Th"
        contentView.addSubview(dayLabel)

        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - CONSTRAINTS
    func setupConstraints() {
        hoursLabel.snp.updateConstraints {make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(19)
        }

        dayLabel.snp.updateConstraints {make in
            make.right.equalTo(hoursLabel.snp.left).offset(-4)
            make.top.equalToSuperview()
            make.height.equalTo(18)
        }
    }
}
