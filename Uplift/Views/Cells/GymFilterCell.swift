//
//  GymFilterCell.swift
//  Uplift
//
//  Created by Joseph Fulgieri on 4/2/18.
//  Copyright © 2018 Uplift. All rights reserved.
//

import SnapKit
import UIKit

class GymFilterCell: UICollectionViewCell {

    static let labelFont = UIFont._14MontserratLight

    var gymNameLabel = UILabel()
    var rightDivider = UIView()
    var selectedCircle = UIView()

    override var isSelected: Bool {
        didSet {
            if self.isSelected {
                gymNameLabel.font = ._14MontserratSemiBold
                selectedCircle.backgroundColor = .primaryYellow
            } else {
                gymNameLabel.font = ._14MontserratRegular
                selectedCircle.backgroundColor = .primaryWhite
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white

        gymNameLabel.font = GymFilterCell.labelFont
        gymNameLabel.textColor = .primaryBlack
        gymNameLabel.sizeToFit()
        gymNameLabel.textAlignment = .center
        contentView.addSubview(gymNameLabel)

        rightDivider.backgroundColor = .gray06
        contentView.addSubview(rightDivider)

        selectedCircle.clipsToBounds = true
        selectedCircle.layer.cornerRadius = 3
        selectedCircle.backgroundColor = .primaryWhite
        contentView.addSubview(selectedCircle)

        isSelected = false

        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(for gymId: GymNameId, showRightDivider: Bool = true) {
        gymNameLabel.text = gymId.name
        rightDivider.isHidden = !showRightDivider
    }

    func setRightDividerVisibility(to visible: Bool) {
        rightDivider.isHidden = !visible
    }

    // MARK: - CONSTRAINTS
    func setupConstraints() {
        let gymNameLabelTopOffset = 5
        let rightDividerBottomOffset = 5
        let selectedCircleSize = 6
        let selectedCircleTopOffset = 5

        gymNameLabel.snp.updateConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(gymNameLabelTopOffset)
        }

        rightDivider.snp.updateConstraints { make in
            make.top.trailing.equalToSuperview()
            make.bottom.equalTo(gymNameLabel.snp.bottom).offset(rightDividerBottomOffset)
            make.width.equalTo(1)
        }

        selectedCircle.snp.updateConstraints { (make) in
            make.centerX.equalTo(gymNameLabel.snp.centerX)
            make.height.width.equalTo(selectedCircleSize)
            make.top.equalTo(gymNameLabel.snp.bottom).offset(selectedCircleTopOffset)
        }
    }

}
