//
//  SportsDetailInputTextField.swift
//  Uplift
//
//  Created by Artesia Ko on 4/25/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import UIKit

class SportsDetailInputTextField: UITextField {

    // https://stackoverflow.com/questions/25367502/create-space-at-the-beginning-of-a-uitextfield
    let textInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textInset)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textInset)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textInset)
    }

}
