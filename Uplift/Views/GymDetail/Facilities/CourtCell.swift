//
//  CourtCell.swift
//  Uplift
//
//  Created by Phillip OReggio on 11/3/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import UIKit

class CourtCell: UICollectionViewCell {

    private var facilityHoursRange: FacilityHoursRange!
    private var dailyHours: [DailyGymHours]!
    private var dayIndex = 0

    private let nameLabel = UILabel()
    private let courtImageView = UIImageView()
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
        infoLabel.font = ._12MontserratRegular
        nameLabel.font = ._14MontserratSemiBold
        courtImageView.image = UIImage(named: "testImage")
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
        let imageSize = CGSize(width: 124, height: 164)

        nameLabel.snp.makeConstraints { make in
            make.top.centerX.equalToSuperview()
        }

        courtImageView.snp.makeConstraints { make in
            make.size.equalTo(imageSize)
            make.top.equalTo(nameLabel).offset(imageOffset)
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

    // MARK: - Parsing String
    private func getName() -> String {
        var str = "Court"
        let numberStrings = facilityHoursRange.restrictions.components(separatedBy: CharacterSet.decimalDigits.inverted)
        if !numberStrings.isEmpty { str.append(" #\(numberStrings.first ?? "0")") }
        return str
    }

    private func getSport() -> String {
        let restrictions = facilityHoursRange.restrictions
        // Has parenthesis: depends on the date being even/odd
        if var firstParenIndex = restrictions.firstIndex(of: "(") {
            // First sport is for odd dates, second is even dates
            if let dateOfMonth = Calendar.current.dateComponents([.day], from: facilityHoursRange.openTime).day {
                if dateOfMonth % 2 == 0 { // Even
                    let orIndex = restrictions.range(of: "or") ?? restrictions.startIndex..<restrictions.endIndex
                    var lastParen = restrictions.lastIndex(of: "(") ?? restrictions.endIndex
                    lastParen = restrictions.index(lastParen, offsetBy: -1)
                    let sportStr = String(restrictions[orIndex.upperBound...lastParen])
                    return sportStr.trimmingCharacters(in: .whitespaces)
                } else { // Odd
                    var colonIndex = restrictions.firstIndex(of: ":") ?? restrictions.endIndex
                    colonIndex = restrictions.index(colonIndex, offsetBy: 1)
                    firstParenIndex = restrictions.index(firstParenIndex, offsetBy: -1)
                    let sportStr = String(restrictions[colonIndex...firstParenIndex])
                    return sportStr.trimmingCharacters(in: .whitespaces)
                }
            }
        }

        // Has colon: Is after colon
        if let colonIndex = restrictions.index(of: ":") {
            let str = String(restrictions.suffix(from: colonIndex))
            return str.trimmingCharacters(in: .whitespaces)
        } else { // No Colon: Just the sport
            return restrictions
        }
    }

    private func getTime() -> String {
        print("sameOpenTime Arr: \(dailyHours.map { $0.openTime == facilityHoursRange.openTime }.contains(true))")
        print("openTime arr: \(dailyHours.map { $0.openTime })")
        print("facility Open Time: \(facilityHoursRange.openTime)")
        print("sameCloseTime Arr: \(dailyHours.map { $0.closeTime == facilityHoursRange.closeTime}.contains(true))")
        print("closeTime arr: \(dailyHours.map { $0.closeTime })")
        print("facility Close Time: \(facilityHoursRange.closeTime)")

        let sameOpenTime = dailyHours.map { $0.openTime == facilityHoursRange.openTime }.contains(true)
        let sameCloseTime = dailyHours.map { $0.closeTime == facilityHoursRange.closeTime}.contains(true)

        let openTimeString = facilityHoursRange.openTime.getStringOfDatetime(format: "h:mm a")
        let closeTimeString = facilityHoursRange.closeTime.getStringOfDatetime(format: "h:mm a")

        if sameOpenTime && sameCloseTime { return "All Day" }
        if sameCloseTime { return "After \(closeTimeString)" }
        return "\(openTimeString) - \(closeTimeString)"
    }
}
