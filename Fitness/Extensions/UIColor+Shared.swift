//
//  UIColor+Shared.swift
//  Fitness
//
//  Created by Keivan Shahida on 3/14/18.
//  Copyright © 2018 Uplift. All rights reserved.
//

import UIKit

extension UIColor {

    @nonobjc static let buttonShadow = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
    @nonobjc static let fitnessBlack = UIColor(red: 43/255, green: 43/255, blue: 43/255, alpha: 1.0)
    @nonobjc static let fitnessDarkGrey = UIColor(red: 112/255, green: 112/255, blue: 112/255, alpha: 1.0)
    @nonobjc static let fitnessDisabledGrey = UIColor(red: 165/255, green: 165/255, blue: 165/255, alpha: 1.0)
    @nonobjc static let fitnessGreen = UIColor(red: 100/255, green: 194/255, blue: 112/255, alpha: 1.0)
    @nonobjc static let fitnessLightGrey = UIColor(red: 216/255, green: 216/255, blue: 216/255, alpha: 1.0)
    @nonobjc static let fitnessMediumGrey = UIColor(red: 206/255, green: 206/255, blue: 206/255, alpha: 1.0)
    @nonobjc static let fitnessMutedGreen = UIColor(red: 229/255, green: 236/255, blue: 237/255, alpha: 1.0)
    @nonobjc static let fitnessRed = UIColor(red: 240/255, green: 125/255, blue: 125/255, alpha: 1.0)
    @nonobjc static let fitnessWhite = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
    @nonobjc static let fitnessYellow = UIColor(red: 248/255, green: 231/255, blue: 28/255, alpha: 1.0)

    public static func colorFromCode(_ code: Int) -> UIColor {
        let red = CGFloat(((code & 0xFF0000) >> 16)) / 255
        let green = CGFloat(((code & 0xFF00) >> 8)) / 255
        let blue = CGFloat((code & 0xFF)) / 255

        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
}
