//
//  GymFacilitiesCell.swift
//  Uplift
//
//  Created by Yana Sang on 9/11/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import SnapKit
import UIKit

class GymFacilitiesCell: UITableViewCell {

    // MARK: - INITIALIZATION
    static let identifier = Identifiers.gymFacilityCell
    var facilityLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        facilityLabel.font = ._14MontserratLight
        facilityLabel.textAlignment = .center
        facilityLabel.textColor = .fitnessLightBlack
        contentView.addSubview(facilityLabel)

        setUpConstraints()
    }

    func setUpConstraints() {
        facilityLabel.snp.makeConstraints { make in
//            make.top.centerX.leading.trailing.equalToSuperview()
            make.center.leading.trailing.equalToSuperview()
            make.height.equalTo(20)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
