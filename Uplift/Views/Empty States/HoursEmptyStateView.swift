//
//  HoursEmptyStateView.swift
//  Uplift
//
//  Created by Yana Sang on 11/12/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import UIKit

class HoursEmptyStateView: UIView {

    private let emptyStateDescriptionLabel = UILabel()
    private let emptyStateImageView = UIImageView(image: UIImage(named: "tea"))
    private let emptyStateTitleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
        setupConstraints()
    }

    func setupViews() {
        addSubview(emptyStateImageView)

        emptyStateTitleLabel.text = ClientStrings.GymDetail.noTimesToday
        emptyStateTitleLabel.font = ._24MontserratBold
        emptyStateTitleLabel.textColor = .primaryBlack
        addSubview(emptyStateTitleLabel)

        emptyStateDescriptionLabel.text = ClientStrings.Calendar.noClassesTodayDescription
        emptyStateDescriptionLabel.font = ._14MontserratRegular
        addSubview(emptyStateDescriptionLabel)
    }

    func setupConstraints() {
        let descriptionLabelHeight: CGFloat = 18.0
        let descriptionLabelTopPadding: CGFloat = 8.0
        let imageViewHeight: CGFloat = 71.0
        let imageViewWidth: CGFloat = 86.0
        let titleLabelHeight: CGFloat = 30.0
        let titleLabelTopPadding: CGFloat = 24.0

        emptyStateImageView.snp.makeConstraints { make in
            make.height.equalTo(imageViewHeight)
            make.width.equalTo(imageViewWidth)
            make.centerX.top.equalToSuperview()
        }

        emptyStateTitleLabel.snp.makeConstraints { make in
            make.height.equalTo(titleLabelHeight)
            make.centerX.equalToSuperview()
            make.top.equalTo(emptyStateImageView.snp.bottom).offset(titleLabelTopPadding)
        }

        emptyStateDescriptionLabel.snp.makeConstraints { make in
            make.height.equalTo(descriptionLabelHeight)
            make.centerX.equalToSuperview()
            make.top.equalTo(emptyStateTitleLabel.snp.bottom).offset(descriptionLabelTopPadding)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
