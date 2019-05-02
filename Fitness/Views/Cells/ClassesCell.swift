//
//  TodaysClassesCell.swift
//  Fitness
//
//  Created by Joseph Fulgieri on 3/7/18.
//  Copyright © 2018 Uplift. All rights reserved.
//
import SnapKit
import UIKit

class ClassesCell: UICollectionViewCell {

    // MARK: - INITIALIZATION
    static let cancelledIdentifier = Identifiers.classesCell + "-cancelled"
    static let identifier = Identifiers.classesCell
    var cancelledLabel: UILabel!
    var cancelledView: UIView!
    var className: UILabel!
    var duration: Int!
    var hours: UILabel!
    var image: UIImageView!
    var locationName: UILabel!
    var locationWidget: UIImageView!

    override init(frame: CGRect) {
        super.init(frame: frame)

        // BORDER
        contentView.layer.cornerRadius = 5
        contentView.layer.backgroundColor = UIColor.white.cgColor
        contentView.layer.borderColor = UIColor.fitnessLightGrey.cgColor
        contentView.layer.borderWidth = 0.5

        // SHADOWING
        contentView.layer.shadowColor = UIColor.fitnessBlack.cgColor
        contentView.layer.shadowOffset = CGSize(width: 0.0, height: 8.0)
        contentView.layer.shadowRadius = 3.0
        contentView.layer.shadowOpacity = 0.1
        contentView.layer.masksToBounds = false
        let shadowFrame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 4, right: -2))
        contentView.layer.shadowPath = UIBezierPath(roundedRect: shadowFrame, cornerRadius: 5).cgPath

        // IMAGE
        image = UIImageView()
        image.clipsToBounds = true
        image.layer.cornerRadius = 5
        image.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        image.contentMode = .scaleAspectFill
        contentView.addSubview(image)

        // CANCELLED VIEW
        cancelledView = UIView()
        cancelledView.backgroundColor = .fitnessRed
        cancelledView.isHidden = true
        contentView.addSubview(cancelledView)

        // CANCELLED LABEL
        cancelledLabel = UILabel()
        cancelledLabel.text = "CANCELLED"
        cancelledLabel.textColor = .white
        cancelledLabel.isHidden = true
        cancelledLabel.font = ._12MontserratBold
        contentView.addSubview(cancelledLabel)

        // CLASS NAME
        className = UILabel()
        className.font = ._16MontserratMedium
        className.textColor = .fitnessBlack
        className.sizeToFit()
        contentView.addSubview(className)

        // HOURS
        hours = UILabel()
        hours.font = ._12MontserratRegular
        hours.sizeToFit()
        hours.textColor = UIColor(red: 39/255, green: 61/255, blue: 82/255, alpha: 0.6)
        contentView.addSubview(hours)

        // LOCATION WIDGET
        locationWidget = UIImageView()
        locationWidget.contentMode = .scaleAspectFit
        locationWidget.image = #imageLiteral(resourceName: "location_pointer")
        contentView.addSubview(locationWidget)

        // LOCATION NAME
        locationName = UILabel()
        locationName.font = ._12MontserratRegular
        locationName.textColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.3)
        contentView.addSubview(locationName)

        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func classIsCancelled() {
        cancelledView.isHidden = false
        cancelledLabel.isHidden = false
        className.textColor = .fitnessDisabledGrey
    }

    // MARK: - CONSTRAINTS
    func setupConstraints() {
        image.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(100)
        }

        cancelledView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(17)
            make.leading.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(32)
        }

        cancelledLabel.snp.makeConstraints { make in
            make.width.equalTo(cancelledLabel.intrinsicContentSize.width)
            make.center.equalTo(cancelledView.snp.center)
        }

        className.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(21)
            make.top.equalTo(image.snp.bottom).offset(13)
            make.trailing.lessThanOrEqualToSuperview().inset(21)
        }

        hours.snp.makeConstraints { make in
            make.leading.equalTo(className)
            make.top.equalTo(className.snp.bottom)
            make.trailing.lessThanOrEqualToSuperview().inset(21)
        }

        locationWidget.snp.makeConstraints { make in
            make.leading.equalTo(className)
            make.bottom.equalToSuperview().inset(14)
            make.width.equalTo(9)
            make.height.equalTo(13)
        }

        locationName.snp.makeConstraints { make in
            make.leading.equalTo(locationWidget.snp.trailing).offset(5)
            make.centerY.equalTo(locationWidget)
            make.trailing.lessThanOrEqualToSuperview().inset(21)
        }
    }
}
