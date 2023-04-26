//
//  TodaysClassListItemCell.swift
//  Uplift
//
//  Created by Kevin Chan on 5/20/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import SnapKit
import SkeletonView
import UIKit

class TodaysClassListItemCell: ListItemCollectionViewCell<GymClassInstance> {

    // MARK: - Public static vars
    static let identifier = Identifiers.classesCell

    // MARK: - Private view vars
    private let cancelledLabel = UILabel()
    private let cancelledView = UIView()
    
    private let classNameLabel = UILabel()
    private let hoursLabel = UILabel()
//    private let imageView = UIImageView()
    private let locationWidget = UIImageView()
    private let locationNameLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        // BORDER
        contentView.layer.cornerRadius = 5
        contentView.layer.backgroundColor = UIColor.white.cgColor
        contentView.layer.borderColor = UIColor.gray01.cgColor
        contentView.layer.borderWidth = 1.0

        // SHADOWING
        contentView.layer.shadowColor = UIColor.gray01.cgColor
        contentView.layer.shadowOffset = CGSize(width: 1.0, height: 2.0)
        contentView.layer.shadowRadius = 5.0
        contentView.layer.shadowOpacity = 1.0
        contentView.layer.masksToBounds = false

        setupViews()
        setupConstraints()

        isSkeletonable = true
        updateSkeleton()

        contentView.isSkeletonable = true
        contentView.updateSkeleton()
    }

    // MARK: - Overrides
    override func configure(for item: GymClassInstance) {
        classNameLabel.text = item.className
        locationNameLabel.text = item.location
        hoursLabel.text = getHoursString(from: item)
//        imageView.kf.setImage(with: item.imageURL)

        // Check if class is cancelled or not
        if item.isCancelled {
            cancelledView.isHidden = false
            cancelledLabel.isHidden = false
            classNameLabel.textColor = .gray03
        }
    }

    // MARK: - Private helpers
    private func getHoursString(from gymClassInstance: GymClassInstance) -> String {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: "EDT")!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"

        return "\(dateFormatter.string(from: gymClassInstance.startTime)) - \(dateFormatter.string(from: gymClassInstance.endTime))"
    }

    private func setupViews() {
//        imageView.clipsToBounds = true
//        imageView.layer.cornerRadius = 5
//        imageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
//        imageView.contentMode = .scaleAspectFill
//        contentView.addSubview(imageView)

        cancelledView.backgroundColor = .accentClosed
        cancelledView.isHidden = true
        cancelledView.layer.cornerRadius = 5
        contentView.addSubview(cancelledView)

        cancelledLabel.text = ClientStrings.Home.todaysClassCancelled
        cancelledLabel.textColor = .white
        cancelledLabel.isHidden = true
        cancelledLabel.font = ._12MontserratBold
        contentView.addSubview(cancelledLabel)

        classNameLabel.font = ._16MontserratMedium
        classNameLabel.textColor = .primaryBlack
        classNameLabel.sizeToFit()
        contentView.addSubview(classNameLabel)

        hoursLabel.font = ._12MontserratRegular
        hoursLabel.textColor = .gray05
        contentView.addSubview(hoursLabel)

        locationWidget.contentMode = .scaleAspectFit
        locationWidget.image = UIImage(named: ImageNames.locationPointer)
        contentView.addSubview(locationWidget)

        locationNameLabel.font = ._12MontserratRegular
        locationNameLabel.textColor = .gray02
        contentView.addSubview(locationNameLabel)
    }

    private func setupConstraints() {
        let cancelledViewSize = CGSize(width: 90, height: 27)
//        let cancelledViewTopPadding = 17
        let classNameLabelHorizontalPadding = 21
        let classNameLabelTopPadding = 13
        let hoursLabelRightPadding = 21
//        let imageViewHeight = 100
        let locationNameLabelLeftPadding = 5
        let locationNameLabelRightPadding = 21
        let locationWidgetBottomPadding = 14
        let locationWidgetSize = CGSize(width: 9, height: 13)

//        imageView.snp.makeConstraints { make in
//            make.leading.trailing.top.equalToSuperview()
//            make.height.equalTo(imageViewHeight)
//        }

        cancelledView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview()
            make.size.equalTo(cancelledViewSize)
        }

        cancelledLabel.snp.makeConstraints { make in
            make.width.equalTo(cancelledLabel.intrinsicContentSize.width)
            make.center.equalTo(cancelledView.snp.center)
        }

        classNameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(classNameLabelHorizontalPadding)
            make.top.equalToSuperview().offset(classNameLabelTopPadding)
            make.trailing.lessThanOrEqualToSuperview().inset(classNameLabelHorizontalPadding)
        }

        hoursLabel.snp.makeConstraints { make in
            make.leading.equalTo(classNameLabel)
            make.top.equalTo(classNameLabel.snp.bottom)
            make.trailing.lessThanOrEqualToSuperview().inset(hoursLabelRightPadding)
        }

        locationWidget.snp.makeConstraints { make in
            make.leading.equalTo(classNameLabel)
            make.bottom.equalToSuperview().inset(locationWidgetBottomPadding)
            make.size.equalTo(locationWidgetSize)
        }

        locationNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(locationWidget.snp.trailing).offset(locationNameLabelLeftPadding)
            make.centerY.equalTo(locationWidget)
            make.trailing.lessThanOrEqualToSuperview().inset(locationNameLabelRightPadding)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
