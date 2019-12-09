//
//  CourtCell.swift
//  Uplift
//
//  Created by Phillip OReggio on 11/3/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import UIKit

class CourtCollectionViewCell: UICollectionViewCell {

    // MARK: Private view vars
    private let courtTitleLabel = UILabel()
    private let courtImageView = UIImageView(image: UIImage(named: ImageNames.court))
    private let infoLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        infoLabel.numberOfLines = 0
        addSubview(infoLabel)

        courtTitleLabel.font = ._14MontserratSemiBold
        addSubview(courtTitleLabel)

        addSubview(courtImageView)

        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        let courtImageViewSize = CGSize(width: 125, height: 166)
        let courtImageViewTopPadding = 9

        courtTitleLabel.snp.makeConstraints { make in
            make.top.centerX.equalToSuperview()
        }

        courtImageView.snp.makeConstraints { make in
            make.size.equalTo(courtImageViewSize)
            make.top.equalTo(courtTitleLabel.snp.bottom).offset(courtImageViewTopPadding)
        }

        infoLabel.snp.makeConstraints { make in
            make.center.equalTo(courtImageView)
        }
    }

    /// DailyHours should only contain hour information for the day of this cell
    func configure(
        courtsHoursRange: FacilityHoursRange,
        facilityHoursRanges: [FacilityHoursRange],
        courtIndex: Int
    ) {
        courtTitleLabel.text = "Court #\(courtIndex + 1)"
        infoLabel.attributedText = getInfoLabelAttributedStr(courtsHoursRange: courtsHoursRange, facilityHoursRanges: facilityHoursRanges)
    }

    // MARK: - String Response Parsing
    private func getInfoLabelAttributedStr(
        courtsHoursRange: FacilityHoursRange,
        facilityHoursRanges: [FacilityHoursRange]
    ) -> NSAttributedString {
        // Attributed Text
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 4
        style.alignment = .center
        let sportAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont._14MontserratBold as Any,
            .paragraphStyle: style,
            .foregroundColor: UIColor.primaryBlack
        ]
        let timeAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont._12MontserratMedium as Any,
            .paragraphStyle: style,
            .foregroundColor: UIColor.primaryBlack
        ]

        let sportName = "\(courtsHoursRange.restrictions.uppercased())\n"
        let openCloseTime = getOpenAndCloseTime(courtsHoursRange: courtsHoursRange, facilityHoursRanges: facilityHoursRanges)
        let text = NSMutableAttributedString(string: sportName, attributes: sportAttributes)
        text.append(NSMutableAttributedString(string: openCloseTime, attributes: timeAttributes))
        return text
    }

    private func getOpenAndCloseTime(
        courtsHoursRange: FacilityHoursRange,
        facilityHoursRanges: [FacilityHoursRange]
    ) -> String {

        let openAtStart = facilityHoursRanges.contains { $0.openTime == courtsHoursRange.openTime }
        let closesAtEnd = facilityHoursRanges.contains(where: { $0.closeTime == courtsHoursRange.closeTime })

        if openAtStart && closesAtEnd { return "ALL DAY" }

        let openTimeString = courtsHoursRange.openTime.getStringOfDatetime(format: "h:mm a")
        let closeTimeString = courtsHoursRange.closeTime.getStringOfDatetime(format: "h:mm a")

        if closesAtEnd {
            return "AFTER \(openTimeString)"
        } else if openAtStart {
            return "BEFORE \(closeTimeString)"
        }
        return "\(openTimeString) - \(closeTimeString)"
    }

}
