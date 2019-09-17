//
//  ProBioBiographyCell.swift
//  Uplift
//
//  Created by Yana Sang on 5/19/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import UIKit

class ProBioBiographyCell: UICollectionViewCell {
    
    // MARK: - Constraint constants
    enum Constants {
        static let bioSummaryTopPadding: CGFloat = 64
        static let bioTextViewTopPadding: CGFloat = 32
        static let dividerViewHeight: CGFloat = 1
        static let dividerViewTopPadding: CGFloat = 36
    }

    // MARK: - Public data vars
    static var baseHeight: CGFloat {
        return Constants.bioSummaryTopPadding + Constants.bioTextViewTopPadding + Constants.dividerViewTopPadding + Constants.dividerViewHeight
    }
    
    // MARK: - Private view vars
    private let bioSummary = UITextView()
    private let bioTextView = UITextView()
    private let dividerView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
        setupConstraints()
    }

    // MARK: - Public configure
    func configure(for pro: ProBio) {
        bioSummary.text = pro.summary
        bioTextView.text = pro.bio
    }

    // MARK: - Private helpers
    private func setupViews() {
        bioSummary.font = ._20MontserratSemiBold
        bioSummary.textColor = .fitnessBlack
        bioSummary.textAlignment = .center
        bioSummary.isScrollEnabled = false
        bioSummary.isSelectable = false
        bioSummary.textContainerInset = UIEdgeInsets.zero
        bioSummary.textContainer.lineFragmentPadding = 0
        contentView.addSubview(bioSummary)

        bioTextView.font = ._14MontserratLight
        bioTextView.textColor = .fitnessLightBlack
        bioTextView.textAlignment = .center
        bioTextView.isScrollEnabled = false
        bioTextView.isSelectable = false
        bioTextView.textContainerInset = UIEdgeInsets.zero
        bioTextView.textContainer.lineFragmentPadding = 0
        contentView.addSubview(bioTextView)

        dividerView.backgroundColor = .fitnessMutedGreen
        contentView.addSubview(dividerView)
    }

    private func setupConstraints() {
        let horizontalPadding = 40

        bioSummary.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(horizontalPadding)
            make.top.equalToSuperview().inset(Constants.bioSummaryTopPadding)
        }

        bioTextView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(horizontalPadding)
            make.top.equalTo(bioSummary.snp.bottom).offset(Constants.bioTextViewTopPadding)
        }

        dividerView.snp.makeConstraints { make in
            make.height.equalTo(Constants.dividerViewHeight)
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(bioTextView.snp.bottom).offset(Constants.dividerViewTopPadding)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
