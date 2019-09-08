//
//  ClassListHeaderView.swift
//  Uplift
//
//  Created by Kevin Chan on 5/19/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import UIKit

class ClassListHeaderView: UICollectionReusableView {

    // MARK: - Private view vars
    private let titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
        setupConstraints()
    }

    // MARK: - Public configure
    func configure(with titleLabelText: String) {
        titleLabel.text = titleLabelText
    }

    // MARK: - CONSTRAINTS
    private func setupViews() {
        titleLabel.font = ._14MontserratSemiBold
        titleLabel.textColor = .fitnessDarkGrey
        titleLabel.textAlignment = .center
        addSubview(titleLabel)
    }

    private func setupConstraints() {
        let titleLabelTopPadding = 18

        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(titleLabelTopPadding)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
