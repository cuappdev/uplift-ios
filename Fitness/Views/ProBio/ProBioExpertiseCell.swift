//
//  ProBioExpertiseCell.swift
//  Fitness
//
//  Created by Yana Sang on 5/19/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import UIKit

class ProBioExpertiseCell: UICollectionViewCell {

    // MARK: - Private view vars
    private let expertiseLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let dividerView = UIView()

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
        expertiseLabel.textColor = .lightBlack
        contentView.addSubview(expertiseLabel)

        descriptionLabel.font = ._14MontserratLight
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .center
        descriptionLabel.textColor = .lightBlack
        contentView.addSubview(descriptionLabel)

        dividerView.backgroundColor = .fitnessLightGrey
        contentView.addSubview(dividerView)
    }

    private func setupConstraints() {
        let descriptionLabelHorizontalPadding = 48
        let descriptionLabelTopPadding = 16
        let dividerViewHeight = 1
        let dividerViewTopPadding = 23
        let expertiseLabelHeight = 20
        let expertiseLabelTopPadding = 23

        expertiseLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(expertiseLabelTopPadding)
            make.height.equalTo(expertiseLabelHeight)
        }

        descriptionLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(descriptionLabelHorizontalPadding)
            make.top.equalTo(expertiseLabel.snp.bottom).offset(descriptionLabelTopPadding)
        }

        dividerView.snp.makeConstraints { make in
            make.height.equalTo(dividerViewHeight)
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(descriptionLabel.snp.bottom).offset(dividerViewTopPadding)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
