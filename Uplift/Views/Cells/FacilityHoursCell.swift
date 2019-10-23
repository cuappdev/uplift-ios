//
//  FacilityHoursCell.swift
//  Uplift
//
//  Created by Ji Hwan Seung on 4/24/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import SnapKit
import UIKit

class FacilityHoursCell: UITableViewCell {

    // MARK: - INITIALIZATION
    static let identifier = Identifiers.facilityHoursCell

    // MARK: - Public view vars
    let dayLabel = UILabel()
    let hoursLabel = UILabel()

    // MARK: - Private view vars
    private let hoursScrollView = UIScrollView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        hoursScrollView.contentSize.height = 1.0
        hoursScrollView.alwaysBounceVertical = false
        hoursScrollView.showsVerticalScrollIndicator = false
        contentView.addSubview(hoursScrollView)

        hoursLabel.font = ._16MontserratLight
        hoursLabel.textColor = .primaryBlack
        hoursLabel.textAlignment = .left
        hoursLabel.sizeToFit()
        hoursLabel.text = "6: 00 AM - 9: 00 PM"
        hoursScrollView.addSubview(hoursLabel)

        setupViews()
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private helpers
    func setupViews() {
        dayLabel.font = UIFont._12MontserratBold
        dayLabel.textColor = .primaryBlack
        dayLabel.textAlignment = .left
        dayLabel.sizeToFit()
        dayLabel.text = "MON"
        contentView.addSubview(dayLabel)
    }

    func setupConstraints() {
        let dayLabelHeight = 15
        let dayLabelLeftPadding = 22
        let hoursScrollViewHeight = 19
        let hoursScrollViewLeftPadding = 72
        let hoursScrollViewRightPadding = 18

        dayLabel.snp.updateConstraints {make in
            make.leading.equalToSuperview().offset(dayLabelLeftPadding)
            make.height.equalTo(dayLabelHeight)
            make.centerY.equalToSuperview()
        }

        hoursScrollView.snp.updateConstraints {make in
            make.leading.equalToSuperview().inset(hoursScrollViewLeftPadding)
            make.trailing.equalToSuperview().inset(hoursScrollViewRightPadding)
            make.centerY.equalToSuperview()
            make.height.equalTo(hoursScrollViewHeight)
        }

        hoursLabel.snp.updateConstraints {make in
            make.edges.equalToSuperview()
        }
    }
}
