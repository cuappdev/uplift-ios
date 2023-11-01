//
//  ClassDetailFunctionCell.swift
//  Uplift
//
//  Created by Kevin Chan on 5/18/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import UIKit

class ClassDetailFunctionCell: UICollectionViewCell {

    // MARK: - Constraint constants
    enum Constants {
        static let descriptionLabelHorizontalPadding = 48
        static let functionDescriptionLabelTopPadding: CGFloat = 12
        static let functionLabelHeight: CGFloat = 18
    }

    // MARK: - Public data vars
    static var baseHeight: CGFloat {
        return GymDetailConstraints.verticalPadding + Constants.functionLabelHeight + Constants.functionDescriptionLabelTopPadding + GymDetailConstraints.verticalPadding + GymDetailConstraints.dividerViewHeight
    }

    // MARK: - Private view vars
    private let functionLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let dividerView = UIView()

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
        functionLabel.text = ClientStrings.ClassDetail.functionLabel
        functionLabel.font = ._16MontserratBold
        functionLabel.textAlignment = .center
        functionLabel.textColor = .primaryBlack
        contentView.addSubview(functionLabel)

        descriptionLabel.font = ._14MontserratLight
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .center
        descriptionLabel.textColor = .primaryBlack
        contentView.addSubview(descriptionLabel)

        dividerView.backgroundColor = .gray01
        contentView.addSubview(dividerView)
    }

    private func setupConstraints() {
        functionLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(GymDetailConstraints.verticalPadding)
            make.height.equalTo(Constants.functionLabelHeight)
        }

        descriptionLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(Constants.descriptionLabelHorizontalPadding)
            make.top.equalTo(functionLabel.snp.bottom).offset(Constants.functionDescriptionLabelTopPadding)
        }

        dividerView.snp.makeConstraints { make in
            make.height.equalTo(GymDetailConstraints.dividerViewHeight)
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(descriptionLabel.snp.bottom).offset(GymDetailConstraints.verticalPadding)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
