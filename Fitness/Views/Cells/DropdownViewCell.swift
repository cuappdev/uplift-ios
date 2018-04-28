//
//  DropdownViewCell.swift
//  Fitness
//
//  Created by Joseph Fulgieri on 4/15/18.
//  Copyright © 2018 Keivan Shahida. All rights reserved.
//

import UIKit
import SnapKit

class DropdownViewCell: UITableViewCell {
    
    // MARK: - INITIALIZATION
    var titleLabel: UILabel!
    var id: Int!
    
    var checkBox: UIView!
    var checkBoxColoring: UIView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.contentView.backgroundColor = .white
        
        //TITLE LABEL
        titleLabel = UILabel()
        titleLabel.sizeToFit()
        titleLabel.font = ._14MontserratLight
        titleLabel.textColor = .fitnessBlack
        titleLabel.text = ""
        addSubview(titleLabel)
        
        //CHECKBOX
        checkBox = UIView()
        checkBox.layer.cornerRadius = 3
        checkBox.layer.borderColor = UIColor.fitnessLightGrey.cgColor
        checkBox.layer.borderWidth = 0.5
        checkBox.layer.masksToBounds = false
        addSubview(checkBox)
        
        checkBoxColoring = UIView()
        checkBoxColoring.backgroundColor = .white
        checkBoxColoring.layer.cornerRadius = 1
        checkBox.addSubview(checkBoxColoring)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
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
            make.left.equalTo(checkBox.snp.right).offset(-20)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        checkBoxColoring.snp.updateConstraints{make in
            make.top.left.equalToSuperview().offset(3)
            make.bottom.right.equalToSuperview().offset(-3)
        }
    }
}
