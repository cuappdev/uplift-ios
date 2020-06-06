//
//  SportsDetailInfoCollectionViewCell.swift
//  Uplift
//
//  Created by Artesia Ko on 4/18/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import UIKit

class SportsDetailInfoCollectionViewCell: UICollectionViewCell {
    
    private let dateLabel = UILabel()
    private let dividerView = UIView()
    private let joinButton = UIButton()
    private let timeLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        dateLabel.font = ._16MontserratLight
        dateLabel.textAlignment = .center
        dateLabel.numberOfLines = 0
        dateLabel.textColor = .primaryBlack
        contentView.addSubview(dateLabel)
        
        timeLabel.font = ._16MontserratMedium
        timeLabel.textAlignment = .center
        timeLabel.numberOfLines = 0
        timeLabel.textColor = .primaryBlack
        contentView.addSubview(timeLabel)
        
        joinButton.setTitle(GameStatus.open.rawValue, for: .normal)
        joinButton.setTitleColor(.primaryBlack, for: .normal)
        joinButton.titleLabel?.font = ._14MontserratBold
        joinButton.layer.borderColor = UIColor.primaryBlack.cgColor
        joinButton.layer.borderWidth = 1
        joinButton.layer.cornerRadius = 20
        joinButton.layer.masksToBounds = true
        joinButton.addTarget(self, action: #selector(joinButtonPressed), for: .touchUpInside)
        contentView.addSubview(joinButton)
        
        dividerView.backgroundColor = .gray01
        contentView.addSubview(dividerView)
        
        setupConstraints()
    }
    
    @objc func joinButtonPressed() {
        // TODO: toggle join button.
    }
    
    func setupConstraints() {
        let dateLabelTopPadding = 24
        let dateTimeVerticalPadding = 8
        let horizontalPadding = 40
        let joinButtonBottomPadding = 24
        let joinButtonHeight = 41
        let joinButtonWidth = 132
        
        dateLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(horizontalPadding)
            make.top.equalToSuperview().offset(dateLabelTopPadding)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(horizontalPadding)
            make.top.equalTo(dateLabel.snp.bottom).offset(dateTimeVerticalPadding)
        }
        
        joinButton.snp.makeConstraints { make in
            make.width.equalTo(joinButtonWidth)
            make.height.equalTo(joinButtonHeight)
            make.bottom.equalToSuperview().inset(joinButtonBottomPadding)
            make.centerX.equalToSuperview()
        }
        
        dividerView.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    func configure(for post: Post) {
        // TODO: add game date field to post, and replace created at with game date.
        dateLabel.text = Date.getTimeStringWithWeekday(time: post.createdAt)
        timeLabel.text = Date.getTimeStringFromDate(time: post.time)
        
        // TODO: check game status and render joinButton title dynamically.
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
