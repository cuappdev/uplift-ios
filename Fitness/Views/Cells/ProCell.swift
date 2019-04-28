//
//  ProCell.swift
//  Fitness
//
//  Created by Cameron Hamidi on 4/22/19.
//  Copyright © 2019 Keivan Shahida. All rights reserved.
//

import UIKit
import SnapKit

class ProCell: UICollectionViewCell {
    
    // MARK: - INITIALIZATION
    static let identifier = Identifiers.proCell
    var image: UIImageView!
    var nameLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = frame.height/16
        clipsToBounds = true
        
        //IMAGE
        image = UIImageView()
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        contentView.addSubview(image)
        
        //CLASS NAME
        nameLabel = UILabel()
        nameLabel.text = "a"
        nameLabel.font = ._20MontserratBold
        nameLabel.textColor = .white
        nameLabel.layer.shadowRadius = 10
        nameLabel.layer.shadowColor = UIColor.black.cgColor
        nameLabel.sizeToFit()
        contentView.addSubview(nameLabel)
        
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - CONSTRAINTS
    func setupConstraints() {
        
        image.snp.makeConstraints {make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints{make in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    func setPro(pro: ProBio) {
        image.image = pro.secondaryProfilePic
        nameLabel.text = pro.name
    }
}
