//
//  GymFilterCell.swift
//  Fitness
//
//  Created by Joseph Fulgieri on 4/2/18.
//  Copyright © 2018 Keivan Shahida. All rights reserved.
//

import UIKit
import SnapKit

class GymFilterCell: UICollectionViewCell {
    
    // MARK: - INITIALIZATION
    var gymNameLabel: UILabel!
    //var separator: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        gymNameLabel = UILabel()
        gymNameLabel.font = ._14MontserratLight
        gymNameLabel.textColor = .fitnessBlack
        gymNameLabel.sizeToFit()
        gymNameLabel.textAlignment = .center
        contentView.addSubview(gymNameLabel)
        
        /*separator = UIView()
        separator.backgroundColor = .fitnessLightGrey
        contentView.addSubview(separator)*/
        
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - CONSTRAINTS
    func setupConstraints() {
        gymNameLabel.snp.updateConstraints{make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(14)
            make.right.equalToSuperview().offset(-14)
        }
        
        /*separator.snp.updateConstraints{make in
            make.height.equalToSuperview()
            make.centerY.equalToSuperview()
            make.right.equalToSuperview()
            make.left.equalTo(separator.snp.right).offset(-3)
        }*/
    }
}
