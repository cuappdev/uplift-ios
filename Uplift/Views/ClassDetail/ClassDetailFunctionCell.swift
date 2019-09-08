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
        static let dividerSpacing: CGFloat = 24
        static let dividerViewHeight: CGFloat = 1
        static let functionDescriptionLabelTopPadding: CGFloat = 12
        static let functionLabelHeight: CGFloat = 19
        static let functionLabelTopPadding: CGFloat = 24
    }

    // MARK: - Public data vars
    static var baseHeight: CGFloat {
        return Constants.functionLabelTopPadding + Constants.functionLabelHeight + Constants.functionDescriptionLabelTopPadding + Constants.dividerSpacing + Constants.dividerViewHeight
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
        functionLabel.text = "FUNCTION"
        functionLabel.font = ._16MontserratMedium
        functionLabel.textAlignment = .center
        functionLabel.textColor = .lightBlack
        contentView.addSubview(functionLabel)

        descriptionLabel.font = ._14MontserratLight
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .center
        descriptionLabel.textColor = .fitnessBlack
        contentView.addSubview(descriptionLabel)

        dividerView.backgroundColor = .fitnessMutedGreen
        contentView.addSubview(dividerView)
    }

    private func setupConstraints() {
        let descriptionLabelHorizontalPadding = 48
    
        functionLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(Constants.functionLabelTopPadding)
            make.height.equalTo(Constants.functionLabelHeight)
        }

        descriptionLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(descriptionLabelHorizontalPadding)
            make.top.equalTo(functionLabel.snp.bottom).offset(Constants.functionDescriptionLabelTopPadding)
        }

        dividerView.snp.makeConstraints { make in
            make.height.equalTo(Constants.dividerViewHeight)
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(descriptionLabel.snp.bottom).offset(Constants.dividerSpacing)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
