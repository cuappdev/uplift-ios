//
//  ClassListCell.swift
//  Uplift
//
//  Created by Cornell AppDev on 3/21/18.
//  Copyright © 2018 Uplift. All rights reserved.
//

import SnapKit
import UIKit

protocol ClassListCellDelegate {
    func toggleFavorite(classDetailId: String)
}

enum ClassListCellStyle {
    /// Displays the time for the primary time label and the duration for the secconday
    case time
    /// Displays the date for the primary time label and the time for the secconday
    case date
}

class ClassListCell: UICollectionViewCell {

    // MARK: - INITIALIZATION
    static let identifier = Identifiers.classListCell
    var primaryTimeLabel: UILabel!
    var secondaryTimeLabel: UILabel!

    var classLabel: UILabel!
    var instructorLabel: UILabel!
    var locationLabel: UILabel!

    var delegate: ClassListCellDelegate?

    var classId: String!
    var favoriteButton: UIButton!
    var isFavorite: Bool = false {
        didSet {
            if oldValue == isFavorite { return }
            let defaults = UserDefaults.standard
            var favorites = defaults.stringArray(forKey: Identifiers.favoriteClasses) ?? []

            if isFavorite {
                favoriteButton.isSelected = true
                if !favorites.contains(classId) {
                    favorites.append(classId)
                    defaults.set(favorites, forKey: Identifiers.favoriteClasses)
                }
            } else {
                favoriteButton.isSelected = false
                if favorites.contains(classId) {
                    favorites = favorites.filter {$0 != classId}
                    defaults.set(favorites, forKey: Identifiers.favoriteClasses)
                }
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = .blue

        // TIME
        primaryTimeLabel = UILabel()
        primaryTimeLabel.font = ._14MontserratMedium
        primaryTimeLabel.textAlignment = .left
        primaryTimeLabel.textColor = .primaryBlack
        primaryTimeLabel.sizeToFit()
        contentView.addSubview(primaryTimeLabel)

        secondaryTimeLabel = UILabel()
        secondaryTimeLabel.font = ._12MontserratRegular
        secondaryTimeLabel.textAlignment = .left
        secondaryTimeLabel.textColor = .primaryBlack
        secondaryTimeLabel.sizeToFit()
        contentView.addSubview(secondaryTimeLabel)

        // DESCRIPTION
        classLabel = UILabel()
        classLabel.font = ._16MontserratMedium
        classLabel.textAlignment = .left
        classLabel.textColor = .primaryBlack
        contentView.addSubview(classLabel)

        locationLabel = UILabel()
        locationLabel.font = ._12MontserratLight
        locationLabel.textAlignment = .left
        locationLabel.textColor = .primaryBlack
        locationLabel.sizeToFit()
        contentView.addSubview(locationLabel)

        instructorLabel = UILabel()
        instructorLabel.font = ._12MontserratRegular
        instructorLabel.textAlignment = .left
        instructorLabel.textColor = .gray02
        instructorLabel.sizeToFit()
        contentView.addSubview(instructorLabel)

        // FAVORITE
        favoriteButton = UIButton()
        favoriteButton.setImage(UIImage(named: ImageNames.starOutlineDark), for: .normal)
        favoriteButton.setImage(UIImage(named: ImageNames.starFilledInDark), for: .selected)
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

        contentView.layer.cornerRadius = 5
        contentView.layer.backgroundColor = UIColor.white.cgColor
        contentView.layer.borderColor = UIColor.gray01.cgColor
        contentView.layer.borderWidth = 0.5

        contentView.layer.shadowColor = UIColor.gray01.cgColor
        contentView.layer.shadowOffset = CGSize(width: 0.0, height: 11.0)
        contentView.layer.shadowRadius = 7.0
        contentView.layer.shadowOpacity = 0.25
        contentView.layer.masksToBounds = false
    }

    // MARK: - CONSTRAINTS
    func setUpContstraints() {
        // DESCRIPTION
        classLabel.snp.makeConstraints { make in
            make.leading.equalTo(101)
            make.top.equalToSuperview().offset(16)
            make.trailing.lessThanOrEqualToSuperview().inset(16)
            make.height.equalTo(19)
        }

        // FAVORITE
        favoriteButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(16)
            make.width.height.equalTo(24)
        }

        // TIME
        primaryTimeLabel.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().offset(16)
            make.trailing.lessThanOrEqualTo(classLabel.snp.leading).inset(4)
            make.height.equalTo(16)
        }

        secondaryTimeLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(primaryTimeLabel)
            make.top.equalTo(primaryTimeLabel.snp.bottom)
            make.height.equalTo(16)
        }

        locationLabel.snp.makeConstraints { make in
            make.leading.equalTo(classLabel)
            make.trailing.equalTo(favoriteButton.snp.leading)
            make.top.equalTo(classLabel.snp.bottom)
            make.height.equalTo(16)
        }

        instructorLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(classLabel)
            make.top.equalTo(locationLabel.snp.bottom).offset(16)
            make.height.equalTo(16)
        }

    }

    // MARK: - FAVORITE
    @objc func favorite() {
        isFavorite.toggle()

        if let delegate = delegate {
            delegate.toggleFavorite(classDetailId: classId)
        }
    }
    
    // MARK: - CONFIGURE
    func configure(gymClassInstance: GymClassInstance, style: ClassListCellStyle) {
            classLabel.text = gymClassInstance.className
            locationLabel.text = gymClassInstance.location
            instructorLabel.text = gymClassInstance.instructor
            classId = gymClassInstance.classDetailId
        
            let favorites = UserDefaults.standard.stringArray(forKey: Identifiers.favoriteClasses) ?? []
            isFavorite = favorites.contains(classId)
            
            switch style {
            case .time:
                secondaryTimeLabel.text = String(Int(gymClassInstance.duration / 60.0)) + ClientStrings.ClassList.dayMinAbbreviation
                primaryTimeLabel.text = gymClassInstance.startTime.getStringOfDatetime(format: "h:mm a")
            case .date:
                secondaryTimeLabel.text = gymClassInstance.startTime.getStringOfDatetime(format: "h:mma")
                if gymClassInstance.startTime.isToday() {
                    primaryTimeLabel.text = ClientStrings.ClassList.dayTodayLabel
                } else {
                    primaryTimeLabel.text = gymClassInstance.startTime.getStringOfDatetime(format: "MMM d")
                }
        }
    }
}
