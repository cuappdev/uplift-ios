//
//  String+Shared.swift
//  Uplift
//
//  Created by Joseph Fulgieri on 9/5/18.
//  Copyright © 2018 Uplift. All rights reserved.
//

import UIKit

extension String {

    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        return ceil(boundingBox.height)
    }

    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        return ceil(boundingBox.width)
    }

    private func generateListString(for stringList: [String],
                                    lineSpacing: CGFloat = 3,
                                    alignment: NSTextAlignment = .left,
                                    font: UIFont) -> NSAttributedString {
        let listString = stringList.joined(separator: "\n")

        let style = NSMutableParagraphStyle()
        style.lineSpacing = lineSpacing
        style.alignment = alignment
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .paragraphStyle: style
        ]

        return NSAttributedString(string: listString, attributes: attributes)
    }

    // Returns the string with the leading zero removed if one exists
    func removeLeadingZero() -> String {
        if (self.hasPrefix("0")) {
            return String( self[String.Index(encodedOffset: 1)...] )
        } else {
            return self
        }
    }

}
