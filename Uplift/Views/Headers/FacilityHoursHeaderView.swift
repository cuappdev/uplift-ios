//
//  FacilityHoursHeaderView.swift
//  Uplift
//
//  Created by Ji Hwan Seung on 4/24/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import UIKit
import SnapKit

class FacilityHoursHeaderView: UITableViewHeaderFooterView {
    
    // MARK: - INITIALIZATION
    static let identifier = Identifiers.facilityHoursHeaderView
    var iconImageView: UIImageView!
    var downArrow: UIImageView!
    var facilityNameLabel: UILabel!
    var upArrow: UIImageView!
    var statusLabel: UILabel!
    var todayTimeLabel: UILabel!

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        facilityNameLabel = UILabel()
        facilityNameLabel.font = ._16MontserratMedium
        facilityNameLabel.textColor = .primaryBlack
        facilityNameLabel.sizeToFit()
        facilityNameLabel.textAlignment = .left
        facilityNameLabel.text = ""
        contentView.addSubview(facilityNameLabel)

        iconImageView = UIImageView()
        contentView.addSubview(iconImageView)

        downArrow = UIImageView(image: .none)
        contentView.addSubview(downArrow)
        
        upArrow = UIImageView(image: UIImage(named: ImageNames.downArrow))
        contentView.addSubview(upArrow)
        
        statusLabel = UILabel()
        statusLabel.font = ._12MontserratMedium
        statusLabel.textColor = .accentOpen
        statusLabel.sizeToFit()
        statusLabel.textAlignment = .left
        contentView.addSubview(statusLabel)
        
        todayTimeLabel = UILabel()
        todayTimeLabel.font = ._12MontserratRegular
        todayTimeLabel.textColor = .primaryBlack
        todayTimeLabel.sizeToFit()
        todayTimeLabel.textAlignment = .left
        contentView.addSubview(todayTimeLabel)
        
        // TODO: Fix this with proper down arrow
        upArrow.transform = CGAffineTransform(rotationAngle: .pi)

        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - CONSTRAINTS
    func setupConstraints() {
        
        iconImageView.snp.updateConstraints {make in
            make.left.equalToSuperview().offset(24)
            make.centerY.equalToSuperview().offset(4)
            make.height.equalTo(14)
            make.width.equalTo(16)
        }

        facilityNameLabel.snp.updateConstraints {make in
            make.centerY.centerX.equalToSuperview()
            make.left.equalTo(iconImageView.snp.right).offset(8)
            make.height.equalTo(20)
        }

        downArrow.snp.updateConstraints {make in
            make.right.equalToSuperview().offset(-24)
            make.centerY.equalTo(facilityNameLabel.snp.centerY).offset(2)
            make.height.equalTo(8)
            make.width.equalTo(16)
        }

        upArrow.snp.updateConstraints {make in
            make.right.equalToSuperview().offset(-24)
            make.centerY.equalTo(facilityNameLabel.snp.centerY).offset(2)
            make.height.equalTo(8)
            make.width.equalTo(16)
        }

        statusLabel.snp.makeConstraints {make in
            make.left.equalTo(iconImageView.snp.left)
            make.top.equalTo(facilityNameLabel.snp.bottom).offset(8)
            make.height.equalTo(15)
        }

        todayTimeLabel.snp.makeConstraints {make in
            make.left.equalTo(statusLabel.snp.right).offset(4)
            make.top.equalTo(statusLabel.snp.top)
            make.height.equalTo(15)
        }
    }
}
