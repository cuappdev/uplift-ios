//
//  PriceInformationView.swift
//  Uplift
//
//  Created by Yana Sang on 10/17/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import UIKit

class PriceInformationView: UIView {

    /// MARK: - Private view vars
    private let backgroundView = UIView()
    private let costsList = UITextView()
    private let itemsList = UITextView()

    /// MARK: - Private data vars
    private let costsListString = "$3.50\n$2.50"
    private let itemsListString = "Price per game\nShoe rental"

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }

    private func setupViews() {
        backgroundView.layer.cornerRadius = 4.0
        backgroundView.backgroundColor = .gray01
        addSubview(backgroundView)

        itemsList.attributedText = generateAttributedString(for: itemsListString, font: UIFont._14MontserratRegular!)
        itemsList.backgroundColor = .gray01
        itemsList.isEditable = false
        itemsList.isSelectable = false
        itemsList.isScrollEnabled = false
        itemsList.textContainerInset = .zero
        itemsList.textContainer.lineFragmentPadding = 0
        addSubview(itemsList)

        costsList.attributedText = generateAttributedString(for: costsListString, font: UIFont._14MontserratSemiBold!)
        costsList.backgroundColor = .gray01
        costsList.isEditable = false
        costsList.isSelectable = false
        costsList.isScrollEnabled = false
        costsList.textContainerInset = .zero
        costsList.textContainer.lineFragmentPadding = 0
        addSubview(costsList)
    }

    private func setupConstraints() {
        let backgroundHeight: CGFloat = 68
        let backgroundWidth: CGFloat = 202
        let contentPadding: CGFloat = 12
        let costsListWidth: CGFloat = 39

        backgroundView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(backgroundWidth)
            make.height.equalTo(backgroundHeight)
        }

        costsList.snp.makeConstraints { make in
            make.top.equalTo(backgroundView).offset(contentPadding)
            make.trailing.bottom.equalTo(backgroundView).inset(contentPadding)
            make.width.equalTo(costsListWidth)
        }

        itemsList.snp.makeConstraints { make in
            make.top.leading.equalTo(backgroundView).offset(contentPadding)
            make.trailing.equalTo(costsList.snp.leading).offset(-contentPadding)
            make.bottom.equalTo(backgroundView).inset(contentPadding)
        }
    }

    private func generateAttributedString(
        for string: String,
        font: UIFont
    ) -> NSAttributedString {

        let style = NSMutableParagraphStyle()
        style.lineSpacing = 8
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .paragraphStyle: style,
            .foregroundColor: UIColor.primaryBlack
        ]

        return NSAttributedString(string: string, attributes: attributes)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
