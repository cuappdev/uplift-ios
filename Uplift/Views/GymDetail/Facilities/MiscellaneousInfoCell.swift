//
//  MiscellaneousInfoCell.swift
//  Uplift
//
//  Created by Phillip OReggio on 10/27/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import UIKit

class MiscellaneousInfoCell: UICollectionViewCell {

    private let textView = UITextView()

    override init(frame: CGRect) {
        super.init(frame: CGRect.zero)

        textView.isEditable = false
        textView.isSelectable = false
        textView.isScrollEnabled = false
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0

        contentView.addSubview(textView)

        textView.snp.makeConstraints { make in
             make.edges.equalToSuperview()
         }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(for miscellaneousInfo: [String]) {
        textView.attributedText = MiscellaneousInfoCell.generateAttributedString(for: miscellaneousInfo, font: UIFont._14MontserratRegular)
    }

    // MARK: - Helper

    private static func generateAttributedString(
        for miscInfo: [String],
        font: UIFont?
    ) -> NSAttributedString {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 3
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font ?? UIFont.systemFont(ofSize: 12),
            .paragraphStyle: style,
            .foregroundColor: UIColor.primaryBlack
        ]

        let string = miscInfo.joined(separator: "\n")

        return NSAttributedString(string: string, attributes: attributes)
    }

    static func getHeight(for miscInfo: [String], font: UIFont? = UIFont._14MontserratRegular) -> CGFloat {
        let nsString = generateAttributedString(for: miscInfo, font: font)
        return nsString.size().height
    }

}
