//
//  ClassDetailFunctionCell.swift
//  Fitness
//
//  Created by Kevin Chan on 5/18/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import UIKit

class ClassDetailFunctionCell: UICollectionViewCell {

    // MARK: - Private view vars
    private let functionLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let dividerView = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
        setupConstraints()
    }

    // MARK: - Public configure
    func configure(for gymClassInstance: GymClassInstance) {
        descriptionLabel.text = gymClassInstance.tags.map { $0.name }.joined(separator: " · ")
    }

    // MARK: - Private helpers
    private func setupViews() {
        functionLabel.text = "FUNCTION"
        functionLabel.font = ._16MontserratMedium
        functionLabel.textAlignment = .center
        functionLabel.textColor = .fitnessBlack
        contentView.addSubview(functionLabel)

        descriptionLabel.font = ._14MontserratLight
        descriptionLabel.textAlignment = .center
        descriptionLabel.textColor = .fitnessBlack
        contentView.addSubview(descriptionLabel)

        dividerView.backgroundColor = .fitnessLightGrey
        contentView.addSubview(dividerView)
    }

    private func setupConstraints() {
        let descriptionLabelHeight = 20
        let descriptionLabelTopPadding = 12
        let dividerSpacing = 24
        let dividerViewHeight = 1
        let functionLabelHeight = 19

        functionLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview().offset(dividerSpacing)
            make.trailing.equalToSuperview()
            make.height.equalTo(functionLabelHeight)
        }

        descriptionLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(functionLabel.snp.bottom).offset(descriptionLabelTopPadding)
            make.trailing.equalToSuperview()
            make.height.equalTo(descriptionLabelHeight)
        }

        dividerView.snp.makeConstraints { make in
            make.height.equalTo(dividerViewHeight)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(descriptionLabel.snp.bottom).offset(dividerSpacing)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
