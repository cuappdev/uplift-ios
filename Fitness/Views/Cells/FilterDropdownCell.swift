//
//  FilterDropdownCell.swift
//  Fitness
//
//  Created by Joseph Fulgieri on 4/2/18.
//  Copyright © 2018 Keivan Shahida. All rights reserved.
//

import UIKit
import SnapKit

class FilterDropdownCell: UIView {

    // MARK: - INITIALIZATION
    var titleLabel: UILabel!
    var checkBox: UIView!
    var checkBoxColoring: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleLabel = UILabel()
        titleLabel.sizeToFit()
        titleLabel.font = ._14MontserratLight
        titleLabel.textColor = .fitnessBlack
        titleLabel.text = "ZUMBA"
        addSubview(titleLabel)
        
        checkBox = UIView()
        checkBox.layer.cornerRadius = 2
        checkBox.backgroundColor = .yellow
        checkBox.layer.borderColor = UIColor.fitnessLightGrey.cgColor
        checkBox.layer.borderWidth = 0.5
        checkBox.layer.masksToBounds = false
        addSubview(checkBox)
        
        setupConstraints()
    }
    
    // MARK: - CONSTRAINTS
    func setupConstraints() {
        titleLabel.snp.updateConstraints{make in
            make.left.equalToSuperview().offset(16)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-16)
        }
        
        checkBox.snp.updateConstraints{make in
            make.top.equalToSuperview().offset(2)
            make.right.equalToSuperview().offset(-34)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
