//
//  BlankViewController.swift
//  Uplift
//
//  Created by Phillip OReggio on 10/27/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import UIKit
import SnapKit

class BlankViewController: UIViewController {

    var test: MiscellaneousInfoView!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .gray05
 
        let samples = ["Game Area", "Bouldering Wall", "Outdoor Basketball Court", "Short", "Something with a really long name"]
        test = MiscellaneousInfoView(miscellaneousInfo: samples)
        view.addSubview(test)
        setupConstraints()
    }

    func setupConstraints() {
//        test.snp.makeConstraints { make in
//            make.leading.equalToSuperview().inset(56)
//            make.center.equalToSuperview()
//        }
        test.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(56)
            make.center.equalToSuperview()
            make.height.equalTo(80)
        }
    }
}
