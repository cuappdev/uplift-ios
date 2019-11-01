//
//  MiscellaneousInfoView.swift
//  Uplift
//
//  Created by Phillip OReggio on 10/27/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import UIKit

class MiscellaneousInfoView: UIView {

    private let textView = UITextView()

    init(miscellaneousInfo: [String]) {
        super.init(frame: CGRect.zero)

        let display = formatMiscellaneous(miscellaneousInfo)
        textView.attributedText = generateAttributedString(for: display, font: UIFont._14MontserratRegular!)
        textView.isEditable = false
        textView.isSelectable = false
        textView.isScrollEnabled = false
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0

        addSubview(textView)
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupConstraints() {
        textView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    // MARK: - Helper

    func formatMiscellaneous(_ misc: [String]) -> String {
        return misc.joined(separator: "\n")
    }

    private func generateAttributedString(
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

}
