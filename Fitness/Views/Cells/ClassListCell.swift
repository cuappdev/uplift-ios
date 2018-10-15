//
//  ClassListCell.swift
//  Fitness
//
//  Created by Keivan Shahida on 3/21/18.
//  Copyright © 2018 Uplift. All rights reserved.
//

import UIKit
import SnapKit

class ClassListCell: UICollectionViewCell {

    // MARK: - INITIALIZATION
    static let identifier = Identifiers.classListCell
    var timeLabel: UILabel!
    var durationLabel: UILabel!
    var duration: Int!

    var classLabel: UILabel!
    var locationLabel: UILabel!
    var instructorLabel: UILabel!

    var favoriteButton: UIButton!

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = .blue

        //TIME
        timeLabel = UILabel()
        timeLabel.font = ._14MontserratMedium
        timeLabel.textAlignment = .left
        timeLabel.textColor = .fitnessBlack
        timeLabel.sizeToFit()
        contentView.addSubview(timeLabel)

        durationLabel = UILabel()
        durationLabel.font = ._12MontserratLight
        durationLabel.textAlignment = .left
        durationLabel.textColor = .fitnessBlack
        durationLabel.sizeToFit()
        contentView.addSubview(durationLabel)

        //DESCRIPTION
        classLabel = UILabel()
        classLabel.font = ._16MontserratMedium
        classLabel.textAlignment = .left
        classLabel.textColor = .fitnessBlack
        contentView.addSubview(classLabel)

        locationLabel = UILabel()
        locationLabel.font = ._12MontserratLight
        locationLabel.textAlignment = .left
        locationLabel.textColor = .fitnessBlack
        locationLabel.sizeToFit()
        contentView.addSubview(locationLabel)

        instructorLabel = UILabel()
        instructorLabel.font = ._12MontserratRegular
        instructorLabel.textAlignment = .left
        instructorLabel.textColor = UIColor(red: 165/255, green: 165/255, blue: 165/255, alpha: 1.0)
        instructorLabel.sizeToFit()
        contentView.addSubview(instructorLabel)

        //FAVORITE
        favoriteButton = UIButton()
        favoriteButton.setImage(#imageLiteral(resourceName: "grey-star"), for: .normal)
        favoriteButton.sizeToFit()
        contentView.addSubview(favoriteButton)

        setUpContstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LAYOUT
    override open func layoutSubviews() {
        super.layoutSubviews()

        contentView.layer.cornerRadius = 5
        contentView.layer.backgroundColor = UIColor.white.cgColor
        contentView.layer.borderColor = UIColor.fitnessLightGrey.cgColor
        contentView.layer.borderWidth = 0.5

        contentView.layer.shadowColor = UIColor.fitnessBlack.cgColor
        contentView.layer.shadowOffset = CGSize(width: 0.0, height: 10.0)
        contentView.layer.shadowRadius = 5.0
        contentView.layer.shadowOpacity = 0.5
        contentView.layer.masksToBounds = false
        let shadowFrame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 5, bottom: 10, right: 5))
        contentView.layer.shadowPath = UIBezierPath(roundedRect: shadowFrame, cornerRadius: 5).cgPath

    }

    // MARK: - CONSTRAINTS
    func setUpContstraints() {
        
        //DESCRIPTION
        classLabel.snp.makeConstraints { make in
            make.leading.equalTo(101)
            make.top.equalToSuperview().offset(16)
            make.trailing.lessThanOrEqualToSuperview().inset(16)
            make.height.equalTo(19)
        }

        //FAVORITE
        favoriteButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(20)
            make.width.equalTo(16)
            make.height.equalTo(16)
        }

        //TIME
        timeLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(16)
            make.trailing.lessThanOrEqualTo(classLabel.snp.leading).inset(4)
            make.height.equalTo(16)
        }

        durationLabel.snp.makeConstraints { make in
            make.leading.equalTo(timeLabel)
            make.top.equalTo(timeLabel.snp.bottom)
            make.trailing.equalTo(timeLabel)
            make.height.equalTo(16)
        }

        locationLabel.snp.makeConstraints { make in
            make.leading.equalTo(classLabel)
            make.trailing.equalTo(favoriteButton.snp.leading)
            make.top.equalTo(classLabel.snp.bottom)
            make.height.equalTo(16)
        }

        instructorLabel.snp.makeConstraints { make in
            make.leading.equalTo(classLabel)
            make.top.equalTo(locationLabel.snp.bottom).offset(16)
            make.trailing.equalTo(classLabel)
            make.height.equalTo(16)
        }

    }
}
