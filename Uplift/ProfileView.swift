//
//  ProfileView.swift
//  Uplift
//
//  Created by Cameron Hamidi on 3/1/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import UIKit

class ProfileView: UIView {

    var dismissClosure: (() -> ())!

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .white

        let gesture = UISwipeGestureRecognizer(target: self, action: #selector(close))
        gesture.direction = .left
        addGestureRecognizer(gesture)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func close() {
        if let dismiss = dismissClosure {
            dismiss()
        }
    }

}
