//
//  ClassDetailDescriptionCell.swift
//  Fitness
//
//  Created by Kevin Chan on 5/18/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import UIKit

class ClassDetailDescriptionCell: UICollectionViewCell {

    // MARK: - Private view vars
    private let descriptionTextView = UITextView()

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
        descriptionTextView.isEditable = false
        descriptionTextView.textAlignment = .center
        descriptionTextView.isScrollEnabled = false
        contentView.addSubview(descriptionTextView)
    }

    private func setupConstraints() {
        let descriptionTextViewHorizontalPadding = 40
        let descriptionTextViewVerticalPadding = 24

        descriptionTextView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(descriptionTextViewHorizontalPadding)
            make.trailing.equalToSuperview().offset(-descriptionTextViewHorizontalPadding)
            make.top.equalToSuperview().offset(descriptionTextViewVerticalPadding)
            make.bottom.equalToSuperview().offset(-descriptionTextViewVerticalPadding)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

