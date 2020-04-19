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
    private let timeLabel = UILabel()
    private let joinButton = UIButton()
    private let divider = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        dateLabel.font = ._16MontserratLight
        dateLabel.textAlignment = .center
        dateLabel.numberOfLines = 0
        dateLabel.textColor = .primaryBlack
        addSubview(dateLabel)
        
        timeLabel.font = ._16MontserratMedium
        timeLabel.textAlignment = .center
        timeLabel.numberOfLines = 0
        timeLabel.textColor = .primaryBlack
        addSubview(timeLabel)
        
        joinButton.setTitle("JOIN GAME", for: .normal)
        joinButton.setTitleColor(.primaryBlack, for: .normal)
        joinButton.titleLabel?.font = ._14MontserratBold
        joinButton.layer.borderColor = UIColor.primaryBlack.cgColor
        joinButton.layer.borderWidth = 1
        joinButton.layer.cornerRadius = 20
        joinButton.layer.masksToBounds = true
        joinButton.addTarget(self, action: #selector(joinButtonPressed), for: .touchUpInside)
        addSubview(joinButton)
        
        divider.backgroundColor = .gray01
        addSubview(divider)
        
        setupConstraints()
    }
    
    @objc func joinButtonPressed() {
        // TODO: toggle join button.
    }
    
    func setupConstraints() {
        let horizontalPadding = 40
        let dateLabelTopPadding = 24
        let dateTimeVerticalPadding = 8
        let joinButtonBottomPadding = 24
        
        dateLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(horizontalPadding)
            make.top.equalToSuperview().offset(dateLabelTopPadding)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(horizontalPadding)
            make.top.equalTo(dateLabel.snp.bottom).offset(dateTimeVerticalPadding)
        }
        
        joinButton.snp.makeConstraints { make in
            make.width.equalTo(132)
            make.height.equalTo(41)
            make.bottom.equalToSuperview().inset(joinButtonBottomPadding)
            make.centerX.equalToSuperview()
        }
        
        divider.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    func configure(for post: Post) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd"
        // TODO: add game date field to post, and replace created at with game date.
        var weekday = ""
        switch Calendar.current.component(.weekday, from: post.createdAt) {
            case 1: weekday = "Sunday"
            case 2: weekday = "Monday"
            case 3: weekday = "Tuesday"
            case 4: weekday = "Wednesday"
            case 5: weekday = "Thursday"
            case 6: weekday = "Friday"
            case 7: weekday = "Saturday"
            default: weekday = ""
        }
        dateLabel.text = "\(weekday), \(dateFormatter.string(from: post.createdAt))"
        timeLabel.text = post.time
        
        // TODO: check game status and render joinButton title dynamically.
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
