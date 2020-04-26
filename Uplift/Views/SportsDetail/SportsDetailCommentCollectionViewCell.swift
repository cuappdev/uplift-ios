//
//  SportsDetailCommentTableViewCell.swift
//  Uplift
//
//  Created by Artesia Ko on 4/25/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import UIKit

class SportsDetailCommentCollectionViewCell: UICollectionViewCell {
    
    private var bubble = UIView()
    private var commentLabel = UILabel()
    private var nameLabel = UILabel()
    private var profileImage = UIImageView()
    private var timeLabel = UILabel()
    
    private let imageHeight = 32

     override init(frame: CGRect) {
        super.init(frame: frame)
        
        profileImage.backgroundColor = .gray02
        profileImage.layer.cornerRadius = CGFloat(imageHeight/2)
        profileImage.layer.masksToBounds = true
        contentView.addSubview(profileImage)
        
        bubble.backgroundColor = .gray01
        bubble.layer.cornerRadius = 20
        bubble.layer.masksToBounds = true
        contentView.addSubview(bubble)
        
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
        let bubbleVerticalPadding = 4
        let imageBubbleHorizontalPadding = 12
        let leadingPadding = 14
        let textHorizontalPadding = 16
        let textVerticalPadding = 8
        let trailingPadding = 28
        
        profileImage.snp.remakeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(leadingPadding)
            make.height.width.equalTo(imageHeight)
        }
        
        timeLabel.snp.remakeConstraints { make in
            make.leading.equalTo(profileImage.snp.trailing).offset(imageBubbleHorizontalPadding + textHorizontalPadding)
            make.bottom.equalToSuperview().inset(bubbleVerticalPadding)
        }
        
        bubble.snp.remakeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(profileImage.snp.trailing).offset(imageBubbleHorizontalPadding)
            make.trailing.equalToSuperview().inset(trailingPadding)
            make.bottom.equalTo(timeLabel.snp.top).offset(-bubbleVerticalPadding)
        }
        
        nameLabel.snp.remakeConstraints { make in
            make.top.equalTo(bubble).offset(textVerticalPadding)
            make.leading.trailing.equalTo(bubble).inset(textHorizontalPadding)
        }
        
        commentLabel.snp.remakeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom)
            make.leading.trailing.equalTo(bubble).inset(textHorizontalPadding)
        }
    }
    
    func configure(for comment: Comment) {
        // TODO: update profileImage.
        nameLabel.text = "TODO: Add name."
        commentLabel.text = comment.text

        let fromDate = comment.createdAt
        let toDate = Date()

        // https://stackoverflow.com/questions/34457434/swift-convert-time-to-time-ago
        if let interval = Calendar.current.dateComponents([.year], from: fromDate, to: toDate).year, interval > 0  {
            timeLabel.text = "\(interval) y"
        } else if let interval = Calendar.current.dateComponents([.month], from: fromDate, to: toDate).month, interval > 0  {
            timeLabel.text = "\(interval) mos"
        } else if let interval = Calendar.current.dateComponents([.day], from: fromDate, to: toDate).day, interval > 0  {
           timeLabel.text = "\(interval) d"
        } else if let interval = Calendar.current.dateComponents([.hour], from: fromDate, to: toDate).hour, interval > 0 {
            timeLabel.text = "\(interval) h"
        } else if let interval = Calendar.current.dateComponents([.minute], from: fromDate, to: toDate).minute, interval > 0 {
            timeLabel.text = "\(interval) m"
        } else if let interval = Calendar.current.dateComponents([.second], from: fromDate, to: toDate).second, interval > 0 {
            timeLabel.text = "\(interval) s"
        } else {
            timeLabel.text = "now"
        }
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
