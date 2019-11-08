//
//  CourtCell.swift
//  Uplift
//
//  Created by Phillip OReggio on 11/3/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import UIKit

class CourtCell: UICollectionViewCell {

    // MARK: Model Info
    private var facilityHoursRange: FacilityHoursRange!
    private var dailyHours: [DailyGymHours]!
    private var dayIndex = 0

    // MARK: Display
    private let nameLabel = UILabel()
    private let courtImageView = UIImageView(image: UIImage(named: "court-single"))
    private let infoLabel = UILabel()
    private let sportAttributes: [NSAttributedString.Key: Any]
    private let timeAttributes: [NSAttributedString.Key: Any]

    override init(frame: CGRect) {
        // Paragraph Styles
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 4
        style.alignment = .center
        sportAttributes = [
            .font: UIFont._14MontserratBold as Any,
            .paragraphStyle: style,
            .foregroundColor: UIColor.primaryBlack
        ]
        timeAttributes = [
            .font: UIFont._12MontserratMedium as Any,
            .paragraphStyle: style,
            .foregroundColor: UIColor.primaryBlack
        ]
        super.init(frame: frame)

        // Views
        infoLabel.numberOfLines = 0
        nameLabel.font = ._14MontserratSemiBold
        addSubview(nameLabel)
        addSubview(courtImageView)
        addSubview(infoLabel)

        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        let imageOffset = 9
        let imageSize = CGSize(width: 125, height: 166)

        nameLabel.snp.makeConstraints { make in
            make.top.centerX.equalToSuperview()
        }

        courtImageView.snp.makeConstraints { make in
            make.size.equalTo(imageSize)
            make.top.equalTo(nameLabel.snp.bottom).offset(imageOffset)
        }

        infoLabel.snp.makeConstraints { make in
            make.center.equalTo(courtImageView)
        }
    }

    /// DailyHours should only contain hour information for the day of this cell
    func configure(facilityHours: FacilityHoursRange, dailyGymHours: [DailyGymHours]) {
        facilityHoursRange = facilityHours
        dailyHours = dailyGymHours

        // Update Visual Attributes with parsed info
        nameLabel.text = getName()
        let text = NSMutableAttributedString(string: getSport() + "\n", attributes: sportAttributes)
        text.append(NSMutableAttributedString(string: getTime(), attributes: timeAttributes))
        infoLabel.attributedText = text
    }

    // MARK: - String Response Parsing
    private func getName() -> String {
        let restrictions = facilityHoursRange.restrictions
        if let index = restrictions.firstIndex(of: ":") {
            return String(restrictions.prefix(upTo: index))
        } else { // Default: Court
            return "Court"
        }
    }

    private func getSport() -> String {
        let restrictions = facilityHoursRange.restrictions
        var sport = ""
        if let colon = restrictions.index(of: ":") {
            let offset = restrictions.index(colon, offsetBy: 1)
            sport = String(restrictions.suffix(from: offset)).trimmingCharacters(in: .whitespaces)
        } else { // Default: Basketball
            sport = "Basketball"
        }

        return sport.uppercased()
    }

    private func getTime() -> String {
        let calendar = Calendar(identifier: .gregorian)

        let openAtStart = dailyHours.map { $0.openTime == facilityHoursRange.openTime }.contains(true)
        let closesAtMidnight = calendar.dateComponents([.hour], from: facilityHoursRange.closeTime).hour == 0

        let openTimeString = facilityHoursRange.openTime.getStringOfDatetime(format: "h:mm a")
        let closeTimeString = facilityHoursRange.closeTime.getStringOfDatetime(format: "h:mm a")

        if openAtStart && closesAtMidnight { return "ALL DAY" }
        if closesAtMidnight { return "AFTER \(openTimeString)" }
        return "\(openTimeString) - \(closeTimeString)"
    }
}
