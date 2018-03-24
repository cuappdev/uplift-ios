//
//  TodaysClassesCell.swift
//  Fitness
//
//  Created by Joseph Fulgieri on 3/7/18.
//  Copyright © 2018 Keivan Shahida. All rights reserved.
//

import UIKit
import SnapKit

class ClassesCell: UICollectionViewCell {
    
    var image: UIImageView!
    var className: UILabel!
    var locName: UILabel!
    var hours: UILabel!
    var locWidget: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        
        contentView.layer.cornerRadius = 5
        contentView.layer.backgroundColor = UIColor.white.cgColor
        contentView.layer.borderColor = UIColor.lightGray.cgColor
        contentView.layer.borderWidth = 0.5
        
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOffset = CGSize(width: 0.0, height: 15.0)
        contentView.layer.shadowRadius = 3.0
        contentView.layer.shadowOpacity = 0.1
        contentView.layer.masksToBounds = false
        let shadowFrame = UIEdgeInsetsInsetRect(contentView.frame, UIEdgeInsetsMake(0, 0, 9, -3))
        contentView.layer.shadowPath = UIBezierPath(roundedRect: shadowFrame, cornerRadius: 5).cgPath
        
        
        
        image = UIImageView()
        image.clipsToBounds = true
        image.layer.cornerRadius = 5
        image.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        contentView.addSubview(image)
        
        image.snp.updateConstraints{make in
            make.right.equalToSuperview()
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalToSuperview().offset(-95)
        }
        
        className = UILabel()
        className.font = UIFont.systemFont(ofSize: 16)
        className.sizeToFit()
        contentView.addSubview(className)
        
        className.snp.updateConstraints{make in
            make.left.equalToSuperview().offset(21)
            make.top.equalTo(image.snp.bottom).offset(13)
        }
        

        hours = UILabel()
        hours.font = UIFont.systemFont(ofSize: 12)
        hours.sizeToFit()
        hours.textColor = .lightGray
        contentView.addSubview(hours)
        
        hours.snp.updateConstraints{make in
            make.left.equalToSuperview().offset(21)
            make.top.equalTo(className.snp.bottom)
        }
        
        locWidget = UIImageView()
        locWidget.image = #imageLiteral(resourceName: "location_widget")
        contentView.addSubview(locWidget)
        
        locWidget.snp.updateConstraints{make in
            make.left.equalToSuperview().offset(21)
            make.bottom.equalToSuperview().offset(-14)
            make.top.equalTo(hours.snp.bottom).offset(21)
            make.right.equalToSuperview().offset(-198)
        }
        
        locName = UILabel()
        locName.sizeToFit()
        locName.font = UIFont.systemFont(ofSize: 12)
        locName.textColor = .lightGray
        contentView.addSubview(locName)
        
        locName.snp.updateConstraints{make in
            make.left.equalTo(locWidget.snp.right).offset(5)
            make.bottom.equalToSuperview().offset(-13)
            make.top.equalTo(hours.snp.bottom).offset(20)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
