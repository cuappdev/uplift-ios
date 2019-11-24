//
//  PriceInformationCell.swift
//  Uplift
//
//  Created by Yana Sang on 10/17/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import UIKit

class PriceInformationCell: UICollectionViewCell {

    struct Constants {
        static let padding: CGFloat = 12
    }

    // MARK: - Private view vars
    private let background = UIView()
    private let itemsList = UITextView()
    private let pricesList = UITextView()

    override init(frame: CGRect) {
        super.init(frame: .zero)

        setupViews()
        setupConstraints()
    }

    func configure(items: [String], prices: [String]) {
        itemsList.attributedText = generateAttributedString(for: items, font: ._14MontserratRegular)
        pricesList.attributedText = generateAttributedString(for: prices, font: ._14MontserratSemiBold, alignment: .right)
        
        pricesList.snp.updateConstraints { make in
            make.width.equalTo(pricesList.intrinsicContentSize.width)
        }
    }

    private func setupViews() {
        background.layer.cornerRadius = 4.0
        background.backgroundColor = .gray01
        contentView.addSubview(background)

        itemsList.backgroundColor = .gray01
        itemsList.isEditable = false
        itemsList.isSelectable = false
        itemsList.isScrollEnabled = false
        itemsList.textContainerInset = .zero
        itemsList.textContainer.lineFragmentPadding = 0
        background.addSubview(itemsList)

        pricesList.backgroundColor = .gray01
        pricesList.isEditable = false
        pricesList.isSelectable = false
        pricesList.isScrollEnabled = false
        pricesList.textContainerInset = .zero
        pricesList.textContainer.lineFragmentPadding = 0
        background.addSubview(pricesList)
    }

    private func setupConstraints() {
        let backgroundWidth: CGFloat = 202

        background.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(Constants.padding)
            make.width.equalTo(backgroundWidth)
        }

        pricesList.snp.makeConstraints { make in
            make.top.trailing.bottom.equalToSuperview().inset(Constants.padding)
            make.width.equalTo(pricesList.intrinsicContentSize.width)
        }

        itemsList.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview().inset(Constants.padding)
            make.trailing.equalTo(pricesList.snp.leading).offset(-Constants.padding)
        }
    }

    private func generateAttributedString(
        for list: [String],
        font: UIFont?,
        alignment: NSTextAlignment = .left
    ) -> NSAttributedString {

        let string = list.joined(separator: "\n")
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 4.0
        style.alignment = alignment
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font as Any,
            .paragraphStyle: style,
            .foregroundColor: UIColor.primaryBlack
        ]

        return NSAttributedString(string: string, attributes: attributes)
    }

    static func getHeight(for items: [String]) -> CGFloat {
        let lineHeight: CGFloat = 20

        let baseHeight = 4.0 * Constants.padding
        let listHeight = lineHeight * CGFloat(items.count)

        return baseHeight + listHeight
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
