//
//  LoadingCollectionViewCell.swift
//  Uplift
//
//  Created by Cameron Hamidi on 2/9/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import UIKit

class LoadingCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .gray01
        contentView.layer.cornerRadius = 5
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
