//
//  TodaysClassesCell.swift
//  Fitness
//
//  Created by Joseph Fulgieri on 3/7/18.
//  Copyright © 2018 Keivan Shahida. All rights reserved.
//

import UIKit

class TodaysClassesCell: UICollectionViewCell {
    
    var image: UIImageView!
    var locName: UILabel!
    var hours: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        image = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.width, height: (frame.height)))
        image.layer.cornerRadius = image.frame.height/12
        image.clipsToBounds = true
        
        hours = UILabel(frame: CGRect(x: 20, y: frame.maxY - 20, width: frame.width - 20, height: 20))
        hours.font = UIFont.systemFont(ofSize: 16)
        hours.textColor = .red
        
        locName = UILabel(frame: CGRect(x: 20, y: hours.frame.minY - 30, width: frame.width - 20, height: 30))
        locName.font = UIFont.systemFont(ofSize: 20)
        locName.textColor = .red
        

        contentView.addSubview(image)
        contentView.addSubview(locName)
        contentView.addSubview(hours)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
