//
//  SportsDetailCommentTableViewCell.swift
//  Uplift
//
//  Created by Artesia Ko on 4/25/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import UIKit

class SportsDetailCommentCollectionViewCell: UICollectionViewCell {
    
    private var bubbleView = UIView()
    private var commentLabel = UILabel()
    private var nameLabel = UILabel()
    private var profileImage = UIImageView()
    private var timeLabel = UILabel()
    
    private let imageSize = 32

     override init(frame: CGRect) {
        super.init(frame: frame)
        
        profileImage.backgroundColor = .gray02
        profileImage.contentMode = .scaleAspectFill
        profileImage.layer.cornerRadius = CGFloat(imageSize)/2.0
        profileImage.layer.masksToBounds = true
        contentView.addSubview(profileImage)
        
        bubbleView.backgroundColor = .gray01
        bubbleView.layer.cornerRadius = 20
        bubbleView.layer.masksToBounds = true
        contentView.addSubview(bubbleView)
        
        nameLabel.font = ._12MontserratMedium
        nameLabel.textColor = .primaryBlack
        contentView.addSubview(nameLabel)
        
        commentLabel.font = ._12MontserratLight
        commentLabel.textColor = .primaryBlack
        commentLabel.numberOfLines = 0
        contentView.addSubview(commentLabel)
        
        timeLabel.font = ._12MontserratRegular
        timeLabel.textColor = .gray02
        contentView.addSubview(timeLabel)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        let bubbleViewVerticalPadding = 4
        let imagebubbleViewHorizontalPadding = 12
        let leadingPadding = 14
        let textHorizontalPadding = 16
        let textVerticalPadding = 8
        let trailingPadding = 28
        
        profileImage.snp.remakeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(leadingPadding)
            make.height.width.equalTo(imageSize)
        }
        
        timeLabel.snp.remakeConstraints { make in
            make.leading.equalTo(profileImage.snp.trailing).offset(imagebubbleViewHorizontalPadding + textHorizontalPadding)
            make.bottom.equalToSuperview().inset(bubbleViewVerticalPadding)
        }
        
        bubbleView.snp.remakeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(profileImage.snp.trailing).offset(imagebubbleViewHorizontalPadding)
            make.trailing.equalToSuperview().inset(trailingPadding)
            make.bottom.equalTo(timeLabel.snp.top).offset(-bubbleViewVerticalPadding)
        }
        
        nameLabel.snp.remakeConstraints { make in
            make.top.equalTo(bubbleView).offset(textVerticalPadding)
            make.leading.trailing.equalTo(bubbleView).inset(textHorizontalPadding)
        }
        
        commentLabel.snp.remakeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom)
            make.leading.trailing.equalTo(bubbleView).inset(textHorizontalPadding)
        }
    }
    
    func configure(for comment: Comment) {
        // TODO: update profileImage.
        nameLabel.text = "TODO: Add name."
        commentLabel.text = comment.text
        timeLabel.text = Date.getTimeStringSince(fromDate: comment.createdAt)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
