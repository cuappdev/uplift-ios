//
//  GymHoursHeaderView.swift
//  Fitness
//
//  Created by Joseph Fulgieri on 4/18/18.
//  Copyright © 2018 Uplift. All rights reserved.
//

import UIKit
import SnapKit

class GymHoursHeaderView: UITableViewHeaderFooterView {

    // MARK: - INITIALIZATION
    static let identifier = Identifiers.gymHoursHeaderView
    var clockImageView: UIImageView!
    var hoursLabel: UILabel!
    var downArrow: UIImageView!
    var rightArrow: UIImageView!

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        hoursLabel = UILabel()
        hoursLabel.font = ._16MontserratMedium
        hoursLabel.textColor = .fitnessBlack
        hoursLabel.sizeToFit()
        hoursLabel.textAlignment = .center
        hoursLabel.text = "6: 00 AM - 9: 00 PM"
        contentView.addSubview(hoursLabel)

        clockImageView = UIImageView(image: #imageLiteral(resourceName: "clock-icon"))
        contentView.addSubview(clockImageView)

        rightArrow = UIImageView(image: #imageLiteral(resourceName: "right-arrow-solid"))
        contentView.addSubview(rightArrow)

        downArrow = UIImageView(image: .none)
        contentView.addSubview(downArrow)

        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - CONSTRAINTS
    func setupConstraints() {
        hoursLabel.snp.updateConstraints { make in
            make.top.centerX.equalToSuperview()
            make.height.equalTo(19)
        }

        clockImageView.snp.updateConstraints { make in
            make.right.equalTo(hoursLabel.snp.left).offset(-8)
            make.centerY.equalTo(hoursLabel.snp.centerY)
            make.height.equalTo(14)
            make.width.equalTo(14)
        }

        rightArrow.snp.updateConstraints { make in
            make.left.equalTo(hoursLabel.snp.right).offset(8)
            make.centerY.equalTo(hoursLabel.snp.centerY)
            make.height.equalTo(9)
            make.width.equalTo(5)
        }

        downArrow.snp.updateConstraints { make in
            make.left.equalTo(hoursLabel.snp.right).offset(8)
            make.centerY.equalTo(hoursLabel.snp.centerY)
            make.height.equalTo(5)
            make.width.equalTo(9)
        }
    }
}
