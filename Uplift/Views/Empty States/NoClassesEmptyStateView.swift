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
        emptyStateTitleLabel.text = "NO CLASSES TODAY"
        emptyStateTitleLabel.font = ._20MontserratBold
        emptyStateTitleLabel.textColor = .fitnessBlack
        addSubview(emptyStateTitleLabel)

        emptyStateDescriptionLabel = UILabel()
        emptyStateDescriptionLabel.text = "Sit back and make yourself some tea"
        emptyStateDescriptionLabel.font = ._14MontserratRegular
        emptyStateDescriptionLabel.textColor = .fitnessBlack
        addSubview(emptyStateDescriptionLabel)

        emptyStateTitleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.lessThanOrEqualToSuperview()
            make.height.equalTo(emptyStateTitleLabel.intrinsicContentSize.height)
        }

        emptyStateImageView.snp.makeConstraints { make in
            make.bottom.equalTo(emptyStateTitleLabel.snp.top).offset(-24)
            make.width.equalTo(86.0)
            make.height.equalTo(71.0)
            make.centerX.equalToSuperview()
        }

        emptyStateDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(emptyStateTitleLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.width.lessThanOrEqualToSuperview()
        }

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
