//
//  BlankViewController.swift
//  Uplift
//
//  Created by Phillip OReggio on 10/19/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import UIKit
import SnapKit

class BlankViewController: UIViewController {

    var test: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .fitnessLightGrey

        test = GymDetailTimeInfoView()
        view.addSubview(test)
        setupConstraints()
    }

    func setupConstraints() {
        test.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview() 
            make.center.equalToSuperview()
            make.height.equalTo(130)
        }
    }
}
