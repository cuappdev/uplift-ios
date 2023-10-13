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

    // Returns the string with the leading zero removed if one exists
    func removeLeadingZero() -> String {
        if self.hasPrefix("0") {
            return String( self[String.Index(encodedOffset: 1)...] )
        } else {
            return self
        }
    }

    static func getFromPercent(value: Double) -> String {
        "\(Int(round(value * 100)))%"
    }

}
