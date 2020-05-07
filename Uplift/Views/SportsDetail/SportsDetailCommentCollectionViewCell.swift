//
//  SportsDetailCommentTableViewCell.swift
//  Uplift
//
//  Created by Artesia Ko on 4/25/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import UIKit

class SportsDetailCommentCollectionViewCell: UICollectionViewCell {
    
    private let bubbleView = UIView()
    private let commentLabel = UILabel()
    private let nameLabel = UILabel()
    private let profileImage = UIImageView()
    private let timeLabel = UILabel()
    
    // Keep public to allow SportsDetailViewController to use same constraints for calculating cell height.
    public struct Constraints {
        static let bubbleViewVerticalPadding = 4
        static let imagebubbleViewHorizontalPadding = 12
        static let imageSize = 32
        static let leadingPadding = 14
        static let nameLabelHeight = 14
        static let textHorizontalPadding = 16
        static let textVerticalPadding = 8
        static let trailingPadding = 28
    }

     override init(frame: CGRect) {
        super.init(frame: frame)
        
        profileImage.backgroundColor = .gray02
        profileImage.contentMode = .scaleAspectFill
        profileImage.layer.cornerRadius = CGFloat(Constraints.imageSize)/2.0
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
        
        profileImage.snp.remakeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(Constraints.leadingPadding)
            make.height.width.equalTo(Constraints.imageSize)
        }
        
        timeLabel.snp.remakeConstraints { make in
            make.leading.equalTo(profileImage.snp.trailing).offset(Constraints.imagebubbleViewHorizontalPadding + Constraints.textHorizontalPadding)
            make.bottom.equalToSuperview().inset(Constraints.bubbleViewVerticalPadding)
        }
        
        bubbleView.snp.remakeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(profileImage.snp.trailing).offset(Constraints.imagebubbleViewHorizontalPadding)
            make.trailing.equalToSuperview().inset(Constraints.trailingPadding)
            make.bottom.equalTo(timeLabel.snp.top).offset(-Constraints.bubbleViewVerticalPadding)
        }
        
        nameLabel.snp.remakeConstraints { make in
            make.top.equalTo(bubbleView).offset(Constraints.textVerticalPadding)
            make.leading.trailing.equalTo(bubbleView).inset(Constraints.textHorizontalPadding)
            make.height.equalTo(Constraints.nameLabelHeight)
        }
        
        commentLabel.snp.remakeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom)
            make.leading.trailing.equalTo(bubbleView).inset(Constraints.textHorizontalPadding)
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
