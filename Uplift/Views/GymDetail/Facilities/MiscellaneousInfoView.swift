//
//  MiscellaneousInfoView.swift
//  Uplift
//
//  Created by Phillip OReggio on 10/27/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import UIKit

class MiscellaneousInfoView: UICollectionViewCell {

    private let textView = UITextView()

    init() {
        super.init(frame: CGRect.zero)

        textView.isEditable = false
        textView.isSelectable = false
        textView.isScrollEnabled = false
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0

        contentView.addSubview(textView)
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(for miscellaneousInfo: [String]) {
        let display = MiscellaneousInfoView.formatMiscellaneous(miscellaneousInfo)
        textView.attributedText = MiscellaneousInfoView.generateAttributedString(for: display, font: UIFont._14MontserratRegular!)
    }

    func setupConstraints() {
        textView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    // MARK: - Helper

    static func formatMiscellaneous(_ misc: [String]) -> String {
        return misc.joined(separator: "\n")
    }

    private static func generateAttributedString(
        for string: String,
        font: UIFont
    ) -> NSAttributedString {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 3
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .paragraphStyle: style,
            .foregroundColor: UIColor.primaryBlack
        ]

        return NSAttributedString(string: string, attributes: attributes)
    }

    static func getHeight(for miscInfo: [String], font: UIFont = UIFont._14MontserratRegular!) -> CGFloat {
        let combinedString = MiscellaneousInfoView.formatMiscellaneous(miscInfo)
        let nsString = generateAttributedString(for: combinedString, font: font)
        return nsString.size().height
    }

}
