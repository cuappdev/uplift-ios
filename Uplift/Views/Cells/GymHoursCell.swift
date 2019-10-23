//
//  GymHoursCell.swift
//  Uplift
//
//  Created by Joseph Fulgieri on 4/18/18.
//  Copyright © 2018 Uplift. All rights reserved.
//

import SnapKit
import UIKit

class GymHoursCell: UITableViewCell {

    // MARK: - INITIALIZATION
    static let identifier = Identifiers.gymHoursCell
    var dayLabel: UILabel!
    var hoursLabel: UILabel!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        hoursLabel = UILabel()
        hoursLabel.font = ._16MontserratRegular
        hoursLabel.textColor = .primaryBlack
        hoursLabel.textAlignment = .center
        hoursLabel.sizeToFit()
        hoursLabel.text = "6: 00 AM - 9: 00 PM"
        contentView.addSubview(hoursLabel)

        dayLabel = UILabel()
        dayLabel.font = ._16MontserratMedium
        dayLabel.textColor = .primaryBlack
        dayLabel.sizeToFit()
        dayLabel.text = DayAbbreviations.thursday
        contentView.addSubview(dayLabel)

        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - CONSTRAINTS
    func setupConstraints() {
        hoursLabel.snp.updateConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(19)
        }

        dayLabel.snp.updateConstraints { make in
            make.right.equalTo(hoursLabel.snp.left).offset(-8)
            make.top.equalToSuperview()
            make.height.equalTo(18)
        }
    }
}
