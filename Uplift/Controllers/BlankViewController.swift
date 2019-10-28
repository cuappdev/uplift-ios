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

        view.backgroundColor = .gray03

        NetworkManager.shared.getGym(id: GymIds.noyes) {
            self.test = MiscellaneousInfoView(miscellaneousInfo: $0.facilities[0].miscInformation)
            self.setupConstraints()
        }
    }

    func setupConstraints() {
        view.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(56)
            make.center.equalToSuperview()
        }
    }
}
