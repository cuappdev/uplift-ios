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
        let imageViewSize = 80.0
        let titleLabelTopPadding = 24.0
        let descriptionLabelTopPadding = 8.0

        emptyStateImageView.snp.makeConstraints { make in
            make.width.height.equalTo(imageViewSize)
            make.top.centerX.equalToSuperview()
        }

        emptyStateTitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.lessThanOrEqualToSuperview()
            make.top.equalTo(emptyStateImageView.snp.bottom).offset(titleLabelTopPadding)
        }

        emptyStateDescriptionLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.lessThanOrEqualToSuperview()
            make.top.equalTo(emptyStateTitleLabel.snp.bottom).offset(descriptionLabelTopPadding)
        }

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
