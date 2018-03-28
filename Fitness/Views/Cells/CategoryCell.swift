//
//  CategoryCell.swift
//  Fitness
//
//  Created by Joseph Fulgieri on 3/20/18.
//  Copyright © 2018 Keivan Shahida. All rights reserved.
//
<<<<<<< HEAD
=======

>>>>>>> master
import UIKit
import SnapKit

class CategoryCell: UICollectionViewCell {
    
    // MARK: - INITIALIZATION
    var image: UIImageView!
    var title: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = frame.height/32
        clipsToBounds = true
        
        //IMAGE
        image = UIImageView()
        contentView.addSubview(image)
        
        //TITLE
        title = UILabel()
        title.font = UIFont.systemFont(ofSize: 16)
        title.textColor = .white
        contentView.addSubview(title)
        
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - CONSTRAINTS
    func setupConstraints()  {
        image.snp.updateConstraints{make in
            make.size.equalToSuperview()
            make.center.equalToSuperview()
        }
        
        title.snp.updateConstraints{make in
            make.center.equalToSuperview()
        }
    }
}
