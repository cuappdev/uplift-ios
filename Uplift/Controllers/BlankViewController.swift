//
//  BlankViewController.swift
//  Uplift
//
// Blank testing ground for a UIView
//
//  Created by Phillip OReggio on 10/2/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import UIKit
import SnapKit

class BlankViewController: UIViewController {

    var testView = GymDetailWeekView()

    override func viewDidLoad() {
        view.backgroundColor = .lightGray

        view.addSubview(testView)

        setUpConstraints()
    }

    private func setUpConstraints() {
        testView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(30)
            make.center.equalToSuperview()
        }
    }
}
