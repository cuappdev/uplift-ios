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
        hoursLabel.textColor = .fitnessBlack
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
        dayLabel.textColor = .fitnessBlack
        dayLabel.textAlignment = .left
        dayLabel.sizeToFit()
        dayLabel.text = "MON"
        contentView.addSubview(dayLabel)
    }

    func setupConstraints() {
        dayLabel.snp.updateConstraints {make in
            make.leading.equalToSuperview().offset(22)
            make.height.equalTo(15)
            make.centerY.equalToSuperview()
        }

        hoursScrollView.snp.updateConstraints {make in
            make.leading.equalToSuperview().inset(72)
            make.trailing.equalToSuperview().inset(18)
            make.centerY.equalToSuperview()
            make.height.equalTo(19)
        }

        hoursLabel.snp.updateConstraints {make in
            make.edges.equalToSuperview()
        }
    }
}
