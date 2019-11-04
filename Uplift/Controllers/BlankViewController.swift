//
//  BlankViewController.swift
//  Uplift
//
//  Created by Phillip OReggio on 11/3/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import UIKit

class BlankViewController: UIViewController {

    var court: CourtView!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .gray02

        court = CourtView()

        setupConstraints()
    }

    func setupConstraints() {
        court.snp.makeConstraints { make in
            make.height.equalTo(190)
            make.leading.trailing.equalToSuperview()
            make.centerX.equalToSuperview()
        }
    }

}
