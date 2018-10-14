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

    var classId: String! {
        didSet {
            let favorites = UserDefaults.standard.stringArray(forKey: Identifiers.favorites) ?? []
            if favorites.contains(classId) {
                isFavorite = true
            }
        }
    }
    
    var favoriteButton: UIButton!
    var isFavorite: Bool = false {
        didSet {
            let defaults = UserDefaults.standard
            var favorites = defaults.stringArray(forKey: Identifiers.favorites) ?? []
            
            if isFavorite {
                favoriteButton.isSelected = true
                if !favorites.contains(classId) {
                    favorites.append(classId)
                    defaults.set(favorites, forKey: Identifiers.favorites)
                }
            } else {
                favoriteButton.isSelected = false
                if favorites.contains(classId) {
                    favorites = favorites.filter {$0 != classId}
                    defaults.set(favorites, forKey: Identifiers.favorites)
                }
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = .blue

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
        instructorLabel.textColor = UIColor(red: 165/255, green: 165/255, blue: 165/255, alpha: 1.0)
        instructorLabel.sizeToFit()
        contentView.addSubview(instructorLabel)

        //FAVORITE
        favoriteButton = UIButton()
        favoriteButton.setImage(UIImage(named: "grey-star"), for: .normal)
        favoriteButton.setImage(UIImage(named: "yellow-star"), for: .selected)
        favoriteButton.sizeToFit()
        favoriteButton.addTarget(self, action: #selector(favorite), for: .touchUpInside)
        contentView.addSubview(favoriteButton)

        setUpContstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LAYOUT
    override open func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 16, bottom: 12, right: 16))

        contentView.layer.cornerRadius = 5
        contentView.layer.backgroundColor = UIColor.white.cgColor
        contentView.layer.borderColor = UIColor.fitnessLightGrey.cgColor
        contentView.layer.borderWidth = 0.5

        contentView.layer.shadowColor = UIColor.fitnessBlack.cgColor
        contentView.layer.shadowOffset = CGSize(width: 0.0, height: 10.0)
        contentView.layer.shadowRadius = 5.0
        contentView.layer.shadowOpacity = 0.5
        contentView.layer.masksToBounds = false
        let shadowFrame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: -10, bottom: 12, right: 24))
        contentView.layer.shadowPath = UIBezierPath(roundedRect: shadowFrame, cornerRadius: 5).cgPath

    }

    // MARK: - CONSTRAINTS
    func setUpContstraints() {

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
            make.width.equalTo(60)
            make.height.equalTo(16)
        }

        durationLabel.snp.makeConstraints { make in
            make.leading.equalTo(timeLabel)
            make.top.equalTo(timeLabel.snp.bottom)
            make.width.equalTo(60)
            make.height.equalTo(16)
        }

        //DESCRIPTION
        classLabel.snp.makeConstraints { make in
            make.leading.equalTo(timeLabel.snp.trailing).offset(30)
            make.top.equalToSuperview().offset(16)
            make.trailing.lessThanOrEqualToSuperview().inset(16)
            make.height.equalTo(19)
        }

        locationLabel.snp.makeConstraints { make in
            make.leading.equalTo(timeLabel.snp.trailing).offset(30)
            make.trailing.equalTo(favoriteButton.snp.leading)
            make.top.equalTo(classLabel.snp.bottom)
            make.height.equalTo(16)
        }

        instructorLabel.snp.makeConstraints { make in
            make.leading.equalTo(timeLabel.snp.trailing).offset(30)
            make.top.equalTo(locationLabel.snp.bottom).offset(16)
            make.trailing.equalTo(classLabel)
            make.height.equalTo(16)
        }

    }
    
    // MARK: - FAVORITE
    @objc func favorite() {
        isFavorite.toggle()
    }
}
