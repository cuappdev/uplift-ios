//
//  SportsFilterCollectionViewCell.swift
//  Uplift
//
//  Created by Cameron Hamidi on 5/5/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import SnapKit
import UIKit

enum SportsFilterSection {
    case gym
    case numPlayers
    case sports
    case startTime
}

class SportsFilterCollectionViewCell: UICollectionViewCell {
    
    private let bottomDivider = UIView()
    private let titleLabel = UILabel()
    
    private let titleLabelLeadingOffset: CGFloat = 16.0
    private let titleLabelTopOffset: CGFloat = 24.0

    override init(frame: CGRect) {
        super.init(frame: frame)

        bottomDivider.backgroundColor = .gray01
        contentView.addSubview(bottomDivider)

        bottomDivider.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(1)
        }

        titleLabel.font = ._12MontserratBold
        titleLabel.textColor = .gray04
        contentView.addSubview(bottomDivider)

        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(titleLabelLeadingOffset)
            make.top.equalToSuperview().offset(titleLabelTopOffset)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDividerVisibility(to visible: Bool) {
        bottomDivider.isHidden = !visible
    }

}
