//
//  OnboardingEmptyStateView.swift
//  Uplift
//
//  Created by Phillip OReggio on 12/10/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import UIKit

class OnboardingEmptyStateView: UIView {

    // MARK: Views
    private let emptyStateImageView = UIImageView(image: UIImage(named: ImageNames.noWifi))
    private let emptyStateTitleLabel = UILabel()
    private let emptyStateDescriptionLabel = UILabel()
    private let retryButton = UIButton()

    // MARK: Delegation
    var retryConnectionDelegate: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
        setupConstraints()
    }

    func setupViews() {
        addSubview(emptyStateImageView)

        emptyStateTitleLabel.text = ClientStrings.Onboarding.noConnectionTitle
        emptyStateTitleLabel.font = ._24MontserratBold
        emptyStateTitleLabel.textColor = .primaryBlack
        addSubview(emptyStateTitleLabel)

        emptyStateDescriptionLabel.text = ClientStrings.Onboarding.noConnectionSubtext
        emptyStateDescriptionLabel.font = ._14MontserratRegular
        addSubview(emptyStateDescriptionLabel)

        retryButton.backgroundColor = .primaryYellow
        retryButton.setTitle(ClientStrings.Onboarding.noConnectionButton, for: .normal)
        retryButton.titleLabel?.font = ._14MontserratBold
        retryButton.setTitleColor(.primaryBlack, for: .normal)
        retryButton.layer.shadowOpacity = 0.125
        retryButton.layer.cornerRadius = 24
        retryButton.layer.shadowRadius = 8
        retryButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        retryButton.addTarget(self, action: #selector(retryConnection), for: .touchUpInside)
        addSubview(retryButton)
    }

    func setupConstraints() {
        let descriptionLabelHeight: CGFloat = 18.0
        let descriptionLabelTopPadding: CGFloat = 8.0
        let imageTopPadding: CGFloat = 10.0
        let imageViewSize = CGSize(width: 86.0, height: 86.0)
        let titleLabelHeight: CGFloat = 30.0
        let titleLabelTopPadding: CGFloat = 20.0
        let retryButtonSize = CGSize(width: 149.0, height: 48.0)

        emptyStateImageView.snp.makeConstraints { make in
            make.size.equalTo(imageViewSize)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(imageTopPadding)
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

        retryButton.snp.makeConstraints { make in
            make.size.equalTo(retryButtonSize)
            make.centerX.equalToSuperview()
            make.top.equalTo(emptyStateDescriptionLabel.snp.bottom).offset(titleLabelTopPadding)
        }
    }

    @objc func retryConnection() {
        retryConnectionDelegate?()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
