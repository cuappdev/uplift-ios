//
//  DropdownHeaderView.swift
//  Fitness
//
//  Created by Joseph Fulgieri on 4/15/18.
//  Copyright © 2018 Keivan Shahida. All rights reserved.
//

import UIKit

class DropdownHeaderView: UITableViewHeaderFooterView {

    // MARK: - INITIALIZATION
    static let identifier = Identifiers.dropdownViewCell
    var titleLabel: UILabel!
    var rightArrow: UIImageView!
    var downArrow: UIImageView!

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        layer.backgroundColor = UIColor.white.cgColor

        titleLabel = UILabel()
        titleLabel.font = ._12LatoBlack
        titleLabel.textColor = .fitnessDarkGrey
        titleLabel.sizeToFit()
        contentView.addSubview(titleLabel)

        rightArrow = UIImageView(image: #imageLiteral(resourceName: "right_arrow"))
        contentView.addSubview(rightArrow)

        downArrow = UIImageView(image: .none )
        contentView.addSubview(downArrow)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - CONSTRAINTS
    override open func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
    }

    func setupConstraints() {
        titleLabel.snp.updateConstraints {make in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }

        rightArrow.snp.updateConstraints {make in
            make.centerY.equalToSuperview()
            make.height.equalToSuperview().dividedBy(4)
            make.right.equalToSuperview().offset(-31)
            make.left.equalTo(rightArrow.snp.right).offset(-8)
        }

        downArrow.snp.updateConstraints {make in
            make.centerY.equalToSuperview()
            make.height.equalToSuperview().dividedBy(6)
            make.right.equalToSuperview().offset(-29)
            make.left.equalTo(downArrow.snp.right).offset(-12)
        }
    }
}
