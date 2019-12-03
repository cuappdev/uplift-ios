//
//  NoClassesEmptyStateView.swift
//  Uplift
//
//  Created by Austin Astorga on 10/9/18.
//  Copyright © 2018 Uplift. All rights reserved.
//

import UIKit

class NoClassesEmptyStateView: UIView {

    var emptyStateImageView: UIImageView!
    var emptyStateTitleLabel: UILabel!
    var emptyStateDescriptionLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)

        emptyStateImageView = UIImageView(image: UIImage(named: "tea"))
        addSubview(emptyStateImageView)

        emptyStateTitleLabel = UILabel()
        emptyStateTitleLabel.text = ClientStrings.Calendar.noClassesTodayLabel
        emptyStateTitleLabel.font = ._24MontserratBold
        emptyStateTitleLabel.textColor = .primaryBlack
        addSubview(emptyStateTitleLabel)

        emptyStateDescriptionLabel = UILabel()
        emptyStateDescriptionLabel.text = ClientStrings.Calendar.noClassesTodayDescription
        emptyStateDescriptionLabel.font = ._14MontserratRegular
        emptyStateDescriptionLabel.textColor = .primaryBlack
        addSubview(emptyStateDescriptionLabel)

        setupConstraints()
    }

    private func setupConstraints() {

        emptyStateImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.height.equalTo(80)
            make.centerX.equalToSuperview()
        }

        emptyStateTitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.lessThanOrEqualToSuperview()
            make.top.equalTo(emptyStateImageView.snp.bottom).offset(24)
            make.height.equalTo(emptyStateTitleLabel.intrinsicContentSize.height)
        }

        emptyStateDescriptionLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.lessThanOrEqualToSuperview()
            make.top.equalTo(emptyStateTitleLabel.snp.bottom).offset(8)
            make.height.equalTo(emptyStateTitleLabel.intrinsicContentSize.height)
        }

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
