//
//  CategoryCell.swift
//  Fitness
//
//  Created by Joseph Fulgieri on 3/20/18.
//  Copyright © 2018 Keivan Shahida. All rights reserved.
//

import UIKit
import SnapKit

class CategoryCell: UICollectionViewCell {
    
    var image: UIImageView!
    var title: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = frame.height/32
        clipsToBounds = true
        
        image = UIImageView()
        contentView.addSubview(image)
        
        image.snp.updateConstraints{make in
            make.size.equalToSuperview()
            make.center.equalToSuperview()
        }
        
        title = UILabel()
        title.font = UIFont.systemFont(ofSize: 16)
        title.textColor = .white
        contentView.addSubview(title)
        
        title.snp.updateConstraints{make in
            make.center.equalToSuperview()
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
