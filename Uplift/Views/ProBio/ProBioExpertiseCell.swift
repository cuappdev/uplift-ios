//
//  ProBioExpertiseCell.swift
//  Uplift
//
//  Created by Yana Sang on 5/19/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import UIKit

class ProBioExpertiseCell: UICollectionViewCell {

    // MARK: - Constraint constants
    enum Constants {
        static let descriptionLabelTopPadding: CGFloat = 16
        static let dividerViewHeight: CGFloat = 1
        static let dividerViewTopPadding: CGFloat = 23
        static let expertiseLabelHeight: CGFloat = 20
        static let expertiseLabelTopPadding: CGFloat = 23
    }

    // MARK: - Public data vars
    static var baseHeight: CGFloat {
        return Constants.expertiseLabelTopPadding + Constants.expertiseLabelHeight + Constants.descriptionLabelTopPadding + Constants.dividerViewTopPadding + Constants.dividerViewHeight
    }

    // MARK: - Private view vars
    private let descriptionLabel = UILabel()
    private let dividerView = UIView()
    private let expertiseLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
        setupConstraints()
    }

    // MARK: - Public configure
    func configure(for pro: ProBio) {
        descriptionLabel.text = pro.expertise.joined(separator: " · ")
    }

    // MARK: - Private helpers
    private func setupViews() {
        expertiseLabel.text = "EXPERTISE"
        expertiseLabel.font = ._16MontserratMedium
        expertiseLabel.textAlignment = .center
        expertiseLabel.textColor = .fitnessLightBlack
        contentView.addSubview(expertiseLabel)

        descriptionLabel.font = ._14MontserratLight
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .center
        descriptionLabel.textColor = .fitnessLightBlack
        contentView.addSubview(descriptionLabel)

        dividerView.backgroundColor = .fitnessMutedGreen
        contentView.addSubview(dividerView)
    }

    private func setupConstraints() {
        let descriptionLabelHorizontalPadding = 48

        expertiseLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(Constants.expertiseLabelTopPadding)
            make.height.equalTo(Constants.expertiseLabelHeight)
        }

        descriptionLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(descriptionLabelHorizontalPadding)
            make.top.equalTo(expertiseLabel.snp.bottom).offset(Constants.descriptionLabelTopPadding)
        }

        dividerView.snp.makeConstraints { make in
            make.height.equalTo(Constants.dividerViewHeight)
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(descriptionLabel.snp.bottom).offset(Constants.dividerViewTopPadding)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
