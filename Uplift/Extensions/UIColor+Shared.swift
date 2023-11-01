//
//  UIColor+Shared.swift
//  Uplift
//
//  Created by Cornell AppDev on 3/14/18.
//  Copyright © 2018 Uplift. All rights reserved.
//

import UIKit

extension UIColor {

    // MARK: - Accent Colors
    @nonobjc static let accentBlue = colorFromCode(0x1395FE)
    @nonobjc static let accentClosed = colorFromCode(0xF07D7D)
    @nonobjc static let accentOpen = colorFromCode(0x64C270)
    @nonobjc static let accentGreen = colorFromCode(0x64C270)
    @nonobjc static let accentOrange = colorFromCode(0xFE8F13)
    @nonobjc static let accentPurple = colorFromCode(0x3813FE)
    @nonobjc static let accentRed = colorFromCode(0xFE1313)
    @nonobjc static let accentSeafoam = colorFromCode(0x13FED7)
    @nonobjc static let accentTurquoise = colorFromCode(0x1395FE)

    // MARK: - Button Shadow Color
    @nonobjc static let buttonShadow = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)

    // MARK: - Grays
    // Used for old designs, to be replaced when views are re-implemented
    @nonobjc static let upliftMediumGrey = UIColor(red: 206/255, green: 206/255, blue: 206/255, alpha: 1.0)
    @nonobjc static let gray01 = colorFromCode(0xE5ECED)
    @nonobjc static let gray02 = colorFromCode(0xA1A5A6)
    @nonobjc static let gray03 = colorFromCode(0xA5A5A5)
    @nonobjc static let gray04 = colorFromCode(0x707070)
    @nonobjc static let gray05 = colorFromCode(0x738390)
    @nonobjc static let gray06 = colorFromCode(0xE5ECE3)
    @nonobjc static let gray07 = colorFromCode(0xA5A5A5)

    // MARK: - Primary Colors
    @nonobjc static let primaryBlack = colorFromCode(0x222222)
    @nonobjc static let primaryLightYellow = colorFromCode(0xFCF5A4)
    @nonobjc static let primaryWhite = colorFromCode(0xFFFFFF)
    @nonobjc static let primaryYellow = colorFromCode(0xF8E71C)

    public static func colorFromCode(_ code: Int) -> UIColor {
        let red = CGFloat(((code & 0xFF0000) >> 16)) / 255
        let green = CGFloat(((code & 0xFF00) >> 8)) / 255
        let blue = CGFloat((code & 0xFF)) / 255

        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }

}
