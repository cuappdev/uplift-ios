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
    var colorBar: UIView!
    var hours: UILabel!
    var locationName: UILabel!
    var shadowView: UIView!
    var status: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)

        //BORDER
        contentView.layer.cornerRadius = 5
        contentView.layer.backgroundColor = UIColor.white.cgColor
        contentView.layer.borderColor = UIColor.fitnessLightGrey.cgColor
        contentView.layer.borderWidth = 0.5

        //SHADOWING
        contentView.layer.shadowColor = UIColor.fitnessBlack.cgColor
        contentView.layer.shadowOffset = CGSize(width: 0.0, height: 15.0)
        contentView.layer.shadowRadius = 5.0
        contentView.layer.shadowOpacity = 0.1
        contentView.layer.masksToBounds = false
        let shadowFrame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 9, right: -3))
        contentView.layer.shadowPath = UIBezierPath(roundedRect: shadowFrame, cornerRadius: 5).cgPath

        //YELLOW BAR
        colorBar = UIView()
        colorBar.backgroundColor = .fitnessYellow
        colorBar.clipsToBounds = true
        colorBar.layer.cornerRadius = 5
        colorBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        contentView.addSubview(colorBar)

        //LOCATION NAME
        locationName = UILabel()
        locationName.font = ._16MontserratMedium
        locationName.textAlignment = .left
        contentView.addSubview(locationName)

        //STATUS
        status = UILabel()
        status.font = ._12MontserratMedium
        contentView.addSubview(status)

        //HOURS
        hours = UILabel()
        hours.font = ._12MontserratMedium
        hours.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.35)
        contentView.addSubview(hours)

        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - CONSTRAINTS
    func setupConstraints() {
        colorBar.snp.updateConstraints {make in
            make.leading.equalToSuperview()
            make.height.equalToSuperview()
            make.width.equalToSuperview().dividedBy(32)
        }

        locationName.snp.updateConstraints {make in
            make.top.equalToSuperview().offset(12)
            make.leading.equalToSuperview().offset(15)
            make.trailing.lessThanOrEqualToSuperview().inset(4)
        }

        status.snp.updateConstraints {make in
            make.leading.equalTo(locationName)
            make.height.equalTo(15)
            make.top.equalTo(locationName.snp.bottom).offset(2)
        }

        hours.snp.updateConstraints {make in
            make.leading.equalTo(status.snp.trailing).offset(5)
            make.trailing.lessThanOrEqualToSuperview().inset(4)
            make.height.top.equalTo(status)
        }
    }

    func setGymName(name: String) {
        locationName.text = name
    }

    func setGymStatus(isOpen: Bool) {
        let color: UIColor = isOpen ? .fitnessGreen : .fitnessRed
        self.status.text = isOpen ? "Open" : "Closed"
        self.status.textColor = color
    }

    func setGymHours(hours: String) {
        self.hours.text = hours
    }
}
