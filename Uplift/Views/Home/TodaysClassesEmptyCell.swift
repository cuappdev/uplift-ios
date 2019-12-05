//
//  TodaysClassesEmptyCell.swift
//  Uplift
//
//  Created by Yana Sang on 12/4/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import UIKit

class TodaysClassesEmptyCell: UICollectionViewCell {

    private let backgroundCardView = UIView()
    private let emptyStateView = NoClassesEmptyStateView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setUpViews()
        setUpConstraints()
    }

    func setUpViews() {
        backgroundCardView.layer.cornerRadius = 5
        backgroundCardView.layer.backgroundColor = UIColor.white.cgColor
        backgroundCardView.layer.borderColor = UIColor.gray01.cgColor
        backgroundCardView.layer.borderWidth = 1.0

        backgroundCardView.layer.shadowColor = UIColor.gray01.cgColor
        backgroundCardView.layer.shadowOffset = CGSize(width: 0.0, height: 11.0)
        backgroundCardView.layer.shadowRadius = 7.0
        backgroundCardView.layer.shadowOpacity = 1.0
        backgroundCardView.layer.masksToBounds = false
        backgroundCardView.addSubview(emptyStateView)

        contentView.addSubview(backgroundCardView)
    }

    func setUpConstraints() {
        let backgroundCardHeight = 195.0
        let emptyStateHeight = 159.0
        let emptyStatePadding = 25.0

        backgroundCardView.snp.makeConstraints { make in
            make.top.width.centerX.equalToSuperview()
            make.height.equalTo(backgroundCardHeight)
        }

        emptyStateView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(emptyStateHeight)
            make.leading.trailing.equalToSuperview().inset(emptyStatePadding)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
