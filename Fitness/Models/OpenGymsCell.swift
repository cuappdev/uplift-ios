//
//  OpenGymsCell.swift
//  Fitness
//
//  Created by Joseph Fulgieri on 3/7/18.
//  Copyright © 2018 Keivan Shahida. All rights reserved.
//

import UIKit

class OpenGymsCell: UICollectionViewCell {
    
    var image: UIImageView!
    var locName: UILabel!
    var hours: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        image = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.width, height: (frame.height - 50)))
        image.layer.cornerRadius = image.frame.height/12
        image.clipsToBounds = true
        
        
        locName = UILabel(frame: CGRect(x: 0, y: image.frame.maxY, width: frame.width, height: 30))
        locName.font = UIFont.systemFont(ofSize: 20)

        hours = UILabel(frame: CGRect(x: 0, y: locName.frame.maxY, width: frame.width, height: 20))
        hours.font = UIFont.systemFont(ofSize: 16)
        hours.textColor = .gray
        
        contentView.addSubview(image)
        contentView.addSubview(locName)
        contentView.addSubview(hours)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
