//
//  GymHoursHeaderView.swift
//  Fitness
//
//  Created by Joseph Fulgieri on 4/18/18.
//  Copyright © 2018 Keivan Shahida. All rights reserved.
//

import UIKit
import SnapKit

class GymHoursHeaderView: UITableViewHeaderFooterView {

    //MARK: - INITIALIZATION
    var clockImageView: UIImageView!
    var hoursLabel: UILabel!
    var downArrow: UIImageView!
    var rightArrow: UIImageView!
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        hoursLabel = UILabel()
        hoursLabel.font = ._16MontserratMedium
        hoursLabel.textColor = .fitnessBlack
        hoursLabel.sizeToFit()
        hoursLabel.textAlignment = .center
        hoursLabel.text = "6: 00 AM - 9: 00 PM"
        contentView.addSubview(hoursLabel)
        
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - CONSTRAINTS
    func setupConstraints() {
        hoursLabel.snp.updateConstraints{make in
            make.top.centerX.equalToSuperview()
            make.height.equalTo(19)
        }
    }
}
