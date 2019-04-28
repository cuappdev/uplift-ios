//
//  OtherProCollectionViewCell.swift
//  Fitness
//
//  Created by Cameron Hamidi on 3/14/19.
//  Copyright © 2019 Keivan Shahida. All rights reserved.
//

import UIKit
import SnapKit

class OtherProCollectionViewCell: UICollectionViewCell {
    static let identifier = Identifiers.otherProCell
    
    var pro: ProBio!
    
    var shadowView: UIView!
    var smallPicImageView: UIImageView!
    var nameLabel: UILabel!
    var summaryLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        shadowView = UIView()
        shadowView.backgroundColor = .white
        shadowView.layer.cornerRadius = 6
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOpacity = 0.3
        shadowView.layer.shadowRadius = 6.0
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.addSubview(shadowView)
        
        smallPicImageView = UIImageView()
        smallPicImageView.clipsToBounds = true
        smallPicImageView.layer.masksToBounds = false
        smallPicImageView.layer.cornerRadius = 20
        smallPicImageView.clipsToBounds = true
        smallPicImageView.backgroundColor = .green
        shadowView.addSubview(smallPicImageView)
        
        nameLabel = UILabel()
        nameLabel.textColor = .black
        nameLabel.font = ._16MontserratRegular
        nameLabel.textAlignment = .left
        shadowView.addSubview(nameLabel)
        
        summaryLabel = UILabel()
        summaryLabel.textColor = UIColor.colorFromCode(0xC0C0C0)
        summaryLabel.font = ._14MontserratRegular
        summaryLabel.textAlignment = .left
        summaryLabel.numberOfLines = 0
        shadowView.addSubview(summaryLabel)
    }
    
    override func updateConstraints() {
        shadowView.snp.makeConstraints{make in
            make.top.equalToSuperview().offset(3)
            make.leading.equalToSuperview().offset(3)
            make.bottom.equalToSuperview().offset(-3)
            make.trailing.equalToSuperview().offset(-3)
        }
        
        smallPicImageView.snp.makeConstraints{make in
            make.height.width.equalTo(40)
            make.top.leading.equalToSuperview().offset(7)
        }
        
        nameLabel.snp.makeConstraints{make in
            make.top.equalTo(smallPicImageView).offset(3)
            make.leading.equalTo(smallPicImageView.snp.trailing).offset(5)
            make.trailing.equalToSuperview().offset(2)
        }
        
        summaryLabel.snp.makeConstraints{make in
            make.top.equalTo(nameLabel.snp.bottom).offset(1)
            make.leading.equalTo(nameLabel)
            make.trailing.equalTo(nameLabel)
        }
        
        super.updateConstraints()
    }
    
    func configure(for pro: ProBio){
        smallPicImageView.image = #imageLiteral(resourceName: "Combined Shape.png")
        nameLabel.text = pro.name
//        nameLabel.sizeToFit()
        summaryLabel.text = pro.summary
        summaryLabel.sizeToFit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
