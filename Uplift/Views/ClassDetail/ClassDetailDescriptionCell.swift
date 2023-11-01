//
//  ClassDetailDescriptionCell.swift
//  Uplift
//
//  Created by Kevin Chan on 5/18/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import UIKit

class ClassDetailDescriptionCell: UICollectionViewCell {

    // MARK: - Constraint constants
    enum Constants {
        static let descriptionTextViewHorizontalPadding: CGFloat = 40
    }

    // MARK: - Public data vars
    static var baseHeight: CGFloat {
        return 2.0 * GymDetailConstraints.verticalPadding + GymDetailConstraints.dividerViewHeight
    }

    // MARK: - Private view vars
    private let descriptionTextView = UITextView()
    private let dividerView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
        setupConstraints()
    }

    // MARK: - Public configure
    func configure(for gymClassInstance: GymClassInstance) {
        descriptionTextView.text = gymClassInstance.classDescription
    }

    // MARK: - Private helpers
    private func setupViews() {
        descriptionTextView.font = ._14MontserratLight
        descriptionTextView.backgroundColor = .primaryWhite
        descriptionTextView.textColor = .primaryBlack
        descriptionTextView.isEditable = false
        descriptionTextView.textAlignment = .center
        descriptionTextView.isScrollEnabled = false
        descriptionTextView.textContainerInset = UIEdgeInsets.zero
        descriptionTextView.textContainer.lineFragmentPadding = 0
        contentView.addSubview(descriptionTextView)
        descriptionTextView.sizeToFit()

        dividerView.backgroundColor = .gray01
        contentView.addSubview(dividerView)
    }

    private func setupConstraints() {
        descriptionTextView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Constants.descriptionTextViewHorizontalPadding)
            make.trailing.equalToSuperview().inset(Constants.descriptionTextViewHorizontalPadding)
            make.top.equalToSuperview().offset(GymDetailConstraints.verticalPadding)
            make.bottom.equalToSuperview().inset(GymDetailConstraints.verticalPadding)
        }

        dividerView.snp.updateConstraints {make in
            make.top.equalTo(descriptionTextView.snp.bottom).offset(GymDetailConstraints.verticalPadding)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(GymDetailConstraints.dividerViewHeight)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
