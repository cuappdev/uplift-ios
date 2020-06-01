//
//  PaddedTextField.swift
//  Uplift
//
//  Created by Artesia Ko on 5/24/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import UIKit

// https://medium.com/@sunnyleeyun/swift-4-add-padding-extension-to-uitextfield-uitextview-42ed550ab821
class PaddedTextField : UITextField {

    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
      
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
      
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
      
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
}
