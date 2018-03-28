//
//  ClassListCell.swift
//  Fitness
//
//  Created by Keivan Shahida on 3/21/18.
//  Copyright © 2018 Keivan Shahida. All rights reserved.
//

import UIKit
import SnapKit

class ClassListCell: UITableViewCell {

    // MARK: - INITIALIZATION
    var timeLabel: UILabel!
    var durationLabel: UILabel!
    
    var classLabel: UILabel!
    var locationLabel: UILabel!
    var instructorLabel: UILabel!
    
    var favoriteButton: UIButton!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.contentView.backgroundColor = .blue
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LAYOUT
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = UIEdgeInsetsInsetRect(contentView.frame, UIEdgeInsetsMake(0, 16, 12, 16))
        
        contentView.layer.cornerRadius = 5
        contentView.layer.backgroundColor = UIColor.white.cgColor
        contentView.layer.borderColor = UIColor.fitnessLightGrey.cgColor
        contentView.layer.borderWidth = 0.5
        
        contentView.layer.shadowColor = UIColor.fitnessBlack.cgColor
        contentView.layer.shadowOffset = CGSize(width: 0.0, height: 10.0)
        contentView.layer.shadowRadius = 5.0
        contentView.layer.shadowOpacity = 0.5
        contentView.layer.masksToBounds = false
        let shadowFrame = UIEdgeInsetsInsetRect(contentView.frame, UIEdgeInsetsMake(0, -10, 12, 24))
        contentView.layer.shadowPath = UIBezierPath(roundedRect: shadowFrame, cornerRadius: 5).cgPath
        
        //TIME
        timeLabel = UILabel()
        timeLabel.text = "8:30 AM"
        timeLabel.font = ._14MontserratMedium
        timeLabel.textAlignment = .left
        timeLabel.textColor = .fitnessBlack
        timeLabel.sizeToFit()
        contentView.addSubview(timeLabel)
        
        durationLabel = UILabel()
        durationLabel.text = "55 min"
        durationLabel.font = ._12MontserratLight
        durationLabel.textAlignment = .left
        durationLabel.textColor = .fitnessBlack
        durationLabel.sizeToFit()
        contentView.addSubview(durationLabel)
        
        //DESCRIPTION
        classLabel = UILabel()
        classLabel.text = "Yoga - Mellow Flow"
        classLabel.font = ._16MontserratMedium
        classLabel.textAlignment = .left
        classLabel.textColor = .fitnessBlack
        classLabel.sizeToFit()
        contentView.addSubview(classLabel)
        
        locationLabel = UILabel()
        locationLabel.text = "Teagle Multipurpose Room"
        locationLabel.font = ._12MontserratLight
        locationLabel.textAlignment = .left
        locationLabel.textColor = .fitnessBlack
        locationLabel.sizeToFit()
        contentView.addSubview(locationLabel)
        
        instructorLabel = UILabel()
        instructorLabel.text = "Clare M."
        instructorLabel.font = ._12MontserratRegular
        instructorLabel.textAlignment = .left
        instructorLabel.textColor = .fitnessLightGrey
        instructorLabel.sizeToFit()
        contentView.addSubview(instructorLabel)
        
        //FAVORITE
        favoriteButton = UIButton()
        favoriteButton.setImage(#imageLiteral(resourceName: "grey-star"), for: .normal)
        favoriteButton.sizeToFit()
        contentView.addSubview(favoriteButton)
        
        setUpContstraints()
    }
    
    // MARK: - CONSTRAINTS
    func setUpContstraints() {
        
        //TIME
        timeLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(16)
            make.width.equalTo(60)
            make.height.equalTo(16)
        }
        
        durationLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalTo(timeLabel.snp.bottom)
            make.width.equalTo(60)
            make.height.equalTo(16)
        }
        
        //DESCRIPTION
        classLabel.snp.makeConstraints { make in
            make.left.equalTo(timeLabel.snp.right).offset(32)
            make.top.equalToSuperview().offset(16)
            make.height.equalTo(19)
        }
        
        locationLabel.snp.makeConstraints { make in
            make.left.equalTo(timeLabel.snp.right).offset(32)
            make.top.equalTo(classLabel.snp.bottom)
            make.height.equalTo(16)
        }
        
        instructorLabel.snp.makeConstraints { make in
            make.left.equalTo(timeLabel.snp.right).offset(32)
            make.top.equalTo(locationLabel.snp.bottom).offset(16)
            make.right.equalToSuperview()
            make.height.equalTo(16)
        }
        
        //FAVORITE
        favoriteButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-16)
            make.width.equalTo(16)
            make.height.equalTo(16)
        }
    }
}
