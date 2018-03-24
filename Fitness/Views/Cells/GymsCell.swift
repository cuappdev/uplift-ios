//
//  OpenGymsCell.swift
//  Fitness
//
//  Created by Joseph Fulgieri on 3/7/18.
//  Copyright © 2018 Keivan Shahida. All rights reserved.
//

import UIKit
import SnapKit

class GymsCell: UICollectionViewCell {
    
    var colorBar: UIView!
    var locName: UILabel!
    var hours: UILabel!
    var status: UILabel!
    var shadowView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        /*layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 0.4
        
        layer.cornerRadius = frame.height/10
        clipsToBounds = true
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowRadius = 3*/
        
        contentView.layer.cornerRadius = 5
        contentView.layer.backgroundColor = UIColor.white.cgColor
        contentView.layer.borderColor = UIColor.lightGray.cgColor
        contentView.layer.borderWidth = 0.5
        
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOffset = CGSize(width: 0.0, height: 15.0)
        contentView.layer.shadowRadius = 5.0
        contentView.layer.shadowOpacity = 0.1
        contentView.layer.masksToBounds = false
        let shadowFrame = UIEdgeInsetsInsetRect(contentView.frame, UIEdgeInsetsMake(0, 0, 9, -3))
        contentView.layer.shadowPath = UIBezierPath(roundedRect: shadowFrame, cornerRadius: 5).cgPath
        
        
        
        //YELLOW BAR
        colorBar = UIView()
        colorBar.backgroundColor = .yellow
        colorBar.clipsToBounds = true
        colorBar.layer.cornerRadius = 5
        colorBar.layer.maskedCorners = [.layerMinXMinYCorner,.layerMinXMaxYCorner]
        contentView.addSubview(colorBar)
        
        colorBar.snp.updateConstraints{make in
            make.left.equalToSuperview()
            make.height.equalToSuperview()
            make.width.equalToSuperview().dividedBy(32)
        }
    
        //INFORMATION
        locName = UILabel()
        locName.font = UIFont.systemFont(ofSize: 12)
        contentView.addSubview(locName)
        
        locName.snp.updateConstraints{make in
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-23)
            make.left.equalToSuperview().offset(17)
            make.right.equalToSuperview().offset(-26)
        }
        
        status = UILabel()
        status.font = UIFont.systemFont(ofSize: 8)
        contentView.addSubview(status)
        
        status.snp.updateConstraints{make in
            make.left.equalToSuperview().offset(17)
            make.bottom.equalToSuperview().offset(-10)
            make.top.equalToSuperview().offset(28)
        }
        
        hours = UILabel()
        hours.font = UIFont.systemFont(ofSize: 8)
        hours.textColor = .gray
        contentView.addSubview(hours)
        
        hours.snp.updateConstraints{make in
            make.left.equalTo(status.snp.right).offset(5)
            
            make.bottom.equalToSuperview().offset(-10)
            make.top.equalToSuperview().offset(28)
        }
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
