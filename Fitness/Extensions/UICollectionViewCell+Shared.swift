//
//  UICollectionViewCell+Shared.swift
//  Fitness
//
//  Created by Kevin Chan on 5/20/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import UIKit

extension UICollectionViewCell {

    func zoomIn() {
        UIView.animate(
            withDuration: 0.35,
            delay: 0.0,
            usingSpringWithDamping: 1.0,
            initialSpringVelocity: 0.0,
            options: [],
            animations: {
                self.transform = CGAffineTransform(scaleX: 0.96, y: 0.96)
        }, completion: nil)
    }

    func zoomOut() {
        UIView.animate(
            withDuration: 0.35,
            delay: 0.0,
            usingSpringWithDamping: 1.0,
            initialSpringVelocity: 0.0,
            options: [],
            animations: {
                self.transform = .identity
        }, completion: nil)
    }

}
