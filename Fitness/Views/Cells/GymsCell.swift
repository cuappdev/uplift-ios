//
//  OpenGymsCell.swift
//  Fitness
//
//  Created by Joseph Fulgieri on 3/7/18.
//  Copyright © 2018 Uplift. All rights reserved.
//

import SnapKit
import UIKit

class GymsCell: UICollectionViewCell {

    // MARK: - INITIALIZATION
    static let identifier = Identifiers.gymsCell
    private var colorBar: UIView!
    private var hours: UILabel!
    private var locationName: UILabel!
    private var shadowView: UIView!
    private var status: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)

        // BORDER
        contentView.layer.cornerRadius = 5
        contentView.layer.backgroundColor = UIColor.white.cgColor
        contentView.layer.borderColor = UIColor.fitnessLightGrey.cgColor
        contentView.layer.borderWidth = 0.5

        // SHADOWING
        contentView.layer.shadowColor = UIColor.fitnessBlack.cgColor
        contentView.layer.shadowOffset = CGSize(width: 0.0, height: 15.0)
        contentView.layer.shadowRadius = 5.0
        contentView.layer.shadowOpacity = 0.1
        contentView.layer.masksToBounds = false
        let shadowFrame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 9, right: -3))
        contentView.layer.shadowPath = UIBezierPath(roundedRect: shadowFrame, cornerRadius: 5).cgPath

        // YELLOW BAR
        colorBar = UIView()
        colorBar.backgroundColor = .fitnessYellow
        colorBar.clipsToBounds = true
        colorBar.layer.cornerRadius = 5
        colorBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        contentView.addSubview(colorBar)

        // LOCATION NAME
        locationName = UILabel()
        locationName.font = ._16MontserratMedium
        locationName.textColor = .fitnessBlack
        locationName.textAlignment = .left
        contentView.addSubview(locationName)

        // STATUS
        status = UILabel()
        status.font = ._14MontserratMedium
        contentView.addSubview(status)

        // HOURS
        hours = UILabel()
        hours.font = ._14MontserratMedium
        hours.textColor = .fitnessDarkGrey
        contentView.addSubview(hours)

        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - CONSTRAINTS
    private func setupConstraints() {
        let descriptionLabelHieght = 15
        let leadingPadding = 16
        let trailingPadding = 4
        
        colorBar.snp.updateConstraints { make in
            make.leading.equalToSuperview()
            make.height.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(5)
        }

        locationName.snp.updateConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(leadingPadding)
            make.height.equalTo(22)
            make.trailing.lessThanOrEqualToSuperview().inset(trailingPadding)
        }

        status.snp.updateConstraints { make in
            make.leading.equalTo(locationName)
            make.trailing.lessThanOrEqualToSuperview().inset(trailingPadding)
            make.height.equalTo(descriptionLabelHieght)
            make.top.equalTo(locationName.snp.bottom).offset(6)
        }

        hours.snp.updateConstraints { make in
            make.leading.equalTo(status)
            make.trailing.lessThanOrEqualToSuperview().inset(trailingPadding)
            make.height.equalTo(descriptionLabelHieght)
            make.top.equalTo(status.snp.bottom).offset(3)
        }
    }

    func setGymName(name: String) {
        locationName.text = name
    }

    func setGymStatus(isOpen: Bool, changingSoon: Bool) {
        
        var color: UIColor
        var status: String
        if isOpen {
            if changingSoon {
                color = .fitnessOrange
                status = "Closing soon"
            } else {
                color = .fitnessGreen
                status = "Currently open"
            }
        } else {
            if changingSoon {
                color = .fitnessOrange
                status = "Opening soon"
            } else {
                color = .fitnessRed
                status = "Closed"
            }
        }
        
        self.status.text = status
        self.status.textColor = color
    }

    func setGymHours(hours: String) {
        self.hours.text = hours
    }
}
