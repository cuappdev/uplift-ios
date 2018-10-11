//
//  HomeCollectionHeaderView.swift
//  Fitness
//
//  Created by Joseph Fulgieri on 3/18/18.
//  Copyright © 2018 Uplift. All rights reserved.
//
import UIKit

class HomeSectionHeaderView: UICollectionReusableView {

    // MARK: - INITIALIZATION
    static let identifier = Identifiers.homeSectionHeaderView
    var titleLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = UIColor.clear

        titleLabel = UILabel()
        titleLabel.font = ._14MontserratBold
        titleLabel.textColor = .fitnessDarkGrey
        addSubview(titleLabel)

        // MARK: - CONSTRAINTS
        titleLabel.snp.updateConstraints {make in
            make.leading.equalTo(16)
            make.top.equalToSuperview()
            make.height.equalTo(titleLabel.intrinsicContentSize.height)
        }
    }

    func setTitle(title: String) {
        titleLabel.text = title

        titleLabel.snp.updateConstraints { make in
            make.height.equalTo(titleLabel.intrinsicContentSize.height)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
