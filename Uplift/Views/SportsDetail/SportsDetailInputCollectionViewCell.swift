//
//  SportsDetailInputCollectionViewCell.swift
//  Uplift
//
//  Created by Artesia Ko on 4/25/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import UIKit

class SportsDetailInputCollectionViewCell: UICollectionViewCell {
    
    private let profileImage = UIImageView()
    private let textField = SportsDetailInputTextField()
    
    private let imageSize = 32
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        profileImage.backgroundColor = .gray02
        profileImage.contentMode = .scaleAspectFill
        profileImage.layer.cornerRadius = CGFloat(imageSize)/2.0
        profileImage.layer.masksToBounds = true
        contentView.addSubview(profileImage)
        
        textField.layer.cornerRadius = CGFloat(imageSize)/2.0
        textField.layer.masksToBounds = true
        textField.font = ._12MontserratLight
        textField.textColor = .primaryBlack
        textField.placeholder = ClientStrings.SportsDetail.addComment
        textField.layer.borderColor = UIColor.gray01.cgColor
        textField.layer.borderWidth = 1
        contentView.addSubview(textField)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        let imageTextFieldHorizontalPadding = 12
        let leadingPadding = 14
        let trailingPadding = 28
        let topPadding = 4
        
        profileImage.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(topPadding)
            make.leading.equalToSuperview().offset(leadingPadding)
            make.height.width.equalTo(imageSize)
        }
        
        textField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(topPadding)
            make.leading.equalTo(profileImage.snp.trailing).offset(imageTextFieldHorizontalPadding)
            make.trailing.equalToSuperview().inset(trailingPadding)
            make.height.equalTo(imageSize)
        }
    }
    
    func configure(for user: User) {
        // TODO: Get profile image.
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
