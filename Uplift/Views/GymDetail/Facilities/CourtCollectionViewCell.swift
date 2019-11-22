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
    func configure(facilityHours: FacilityHoursRange, dailyGymHours: [DailyGymHours]) {
        setCourtTitleLabel(facilityHours: facilityHours)
        setInfoLabel(facilityHours: facilityHours, dailyHours: dailyGymHours)
    }

    // MARK: - String Response Parsing
    private func setCourtTitleLabel(facilityHours: FacilityHoursRange) {
        let restrictions = facilityHours.restrictions
        if let index = restrictions.firstIndex(of: ":") {
            courtTitleLabel.text = String(restrictions[..<index])
        } else { // Default: Court
            courtTitleLabel.text = "Court"
        }
    }

    private func setInfoLabel(facilityHours: FacilityHoursRange, dailyHours: [DailyGymHours]) {
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

        let sportName = "\(getSportName(facilityHours: facilityHours))\n"
        let openCloseTime = getOpenAndCloseTime(facilityHours: facilityHours, dailyHours: dailyHours)
        let text = NSMutableAttributedString(string: sportName, attributes: sportAttributes)
        text.append(NSMutableAttributedString(string: openCloseTime, attributes: timeAttributes))
        infoLabel.attributedText = text
    }

    private func getSportName(facilityHours: FacilityHoursRange) -> String {
        let restrictions = facilityHours.restrictions
        var sport = "Basketball" // Default: Basketball
        if let colon = restrictions.index(of: ":") {
            let offset = restrictions.index(colon, offsetBy: 1)
            sport = String(restrictions.suffix(from: offset)).trimmingCharacters(in: .whitespaces)
        }
        return sport.uppercased()
    }

    private func getOpenAndCloseTime(facilityHours: FacilityHoursRange, dailyHours: [DailyGymHours]) -> String {
        let calendar = Calendar(identifier: .gregorian)

        let openAtStart = dailyHours.contains { $0.openTime == facilityHours.openTime }
        let closesAtMidnight = calendar.dateComponents([.hour], from: facilityHours.closeTime).hour == 0

        let openTimeString = facilityHours.openTime.getStringOfDatetime(format: "h:mm a")
        let closeTimeString = facilityHours.closeTime.getStringOfDatetime(format: "h:mm a")

        if openAtStart && closesAtMidnight { return "ALL DAY" }
        if closesAtMidnight { return "AFTER \(openTimeString)" }
        return "\(openTimeString) - \(closeTimeString)"
    }

}
