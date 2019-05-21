//
//  ProBioBiographyCell.swift
//  Fitness
//
//  Created by Yana Sang on 5/19/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import UIKit

class ProBioBiographyCell: UICollectionViewCell {

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
        bioTextView.textColor = .lightBlack
        bioTextView.textAlignment = .center
        bioTextView.isScrollEnabled = false
        bioTextView.isSelectable = false
        bioTextView.textContainerInset = UIEdgeInsets.zero
        bioTextView.textContainer.lineFragmentPadding = 0
        contentView.addSubview(bioTextView)

        dividerView.backgroundColor = .fitnessLightGrey
        contentView.addSubview(dividerView)
    }

    private func setupConstraints() {
        let bioTextViewHorizontalPadding = 40
        let bioTextViewTopPadding = 32
        let bioSummaryHorizontalPadding = 40
        let bioSummaryTopPadding = 64
        let dividerViewHeight = 1
        let dividerViewTopPadding = 36

        bioSummary.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(bioSummaryHorizontalPadding)
            make.top.equalToSuperview().inset(bioSummaryTopPadding)
        }

        bioTextView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(bioTextViewHorizontalPadding)
            make.top.equalTo(bioSummary.snp.bottom).offset(bioTextViewTopPadding)
        }

        dividerView.snp.makeConstraints { make in
            make.height.equalTo(dividerViewHeight)
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(bioTextView.snp.bottom).offset(dividerViewTopPadding)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
