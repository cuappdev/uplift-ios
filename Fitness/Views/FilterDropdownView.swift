//
//  ClassTypeFilterViewHeader.swift
//  Fitness
//
//  Created by Joseph Fulgieri on 4/2/18.
//  Copyright © 2018 Keivan Shahida. All rights reserved.
//

import UIKit
import SnapKit

class FilterDropdownView: UIView {

    // MARK: - INITIALIZATION
    var titleLabel: UILabel!
    var dropIcon: UIImageView!
    var dropArea: UIView!
    
    var cells: [FilterDropdownCell]!
    var data: [String]!
    var isDropped: Bool!
    var showAllButton: UIButton?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        isDropped = false
        
        titleLabel = UILabel()
        titleLabel.font = ._12LatoBlack
        titleLabel.textColor = .fitnessDarkGrey
        titleLabel.sizeToFit()
        addSubview(titleLabel)
        
        dropIcon = UIImageView(image: #imageLiteral(resourceName: "grey-star")) //replace with proper image
        addSubview(dropIcon)
        
        dropArea = UIView()
        addSubview(dropArea)
        dropArea.isUserInteractionEnabled = true
        
        setupConstraints()
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.drop(sender:) ))
        self.dropArea.addGestureRecognizer(gesture)
        
        //testing
        isDropped = true
        let cell = FilterDropdownCell(frame: .zero)
        addSubview(cell)
        cell.snp.updateConstraints{make in
            make.top.equalTo(dropArea.snp.bottom)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalTo(dropArea.snp.bottom).offset(32)
        }
    }
    
    @objc func drop( sender:UITapGestureRecognizer){
        print("drop!")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - CONSTRAINTS
    func setupConstraints() {
        titleLabel.snp.updateConstraints{make in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
        
        dropIcon.snp.updateConstraints{make in
            make.centerY.equalToSuperview()
            make.height.equalToSuperview().dividedBy(4)
            make.right.equalToSuperview().offset(-31)
        }
        
        dropArea.snp.updateConstraints{make in
            make.top.equalToSuperview()
            make.right.equalToSuperview()
            make.left.equalToSuperview()
            make.bottom.equalTo(titleLabel.snp.bottom).offset(20)
        }
    }
}
