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
        
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 0.4
        
        layer.cornerRadius = frame.height/10
        clipsToBounds = true
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowRadius = 3
        
        
        
        shadowView = UIView()
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOpacity = 0.5
        shadowView.layer.shadowRadius = 10
        contentView.addSubview(shadowView)
        
        shadowView.snp.updateConstraints{make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        
        
        colorBar = UIView()
        colorBar.backgroundColor = .yellow
        contentView.addSubview(colorBar)
        
        colorBar.snp.updateConstraints{make in
            make.left.equalToSuperview()
            make.height.equalToSuperview()
            make.width.equalToSuperview().dividedBy(32)
        }
    
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
