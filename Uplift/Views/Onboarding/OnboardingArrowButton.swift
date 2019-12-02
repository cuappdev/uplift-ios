//
//  OnboardingArrowButton.swift
//  Uplift
//
//  Created by Phillip OReggio on 11/20/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import UIKit
import SnapKit

class OnboardingArrowButton: UIButton {

    private var changesColor = true

    init(arrowFacesRight: Bool, changesColor: Bool = true) {
        super.init(frame: .zero)

        let circleRadius: CGFloat = 17.5
        let borderSize: CGFloat = 2
        let arrowSize = CGSize(width: 16.95, height: 11.59)

        clipsToBounds = false
        backgroundColor = changesColor ? .primaryYellow : .none

        layer.cornerRadius = circleRadius
        layer.borderColor = UIColor.primaryBlack.cgColor
        layer.borderWidth = borderSize

        let arrowView = UIImageView(image: UIImage(named: ImageNames.arrow))
        if arrowFacesRight {
            arrowView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        }
        addSubview(arrowView)

        arrowView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(arrowSize)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("Loading from nib not implemented")
    }

    func toggleState(on: Bool) {
        isEnabled = on
        backgroundColor = on && changesColor ? .primaryYellow : .none
    }
}
