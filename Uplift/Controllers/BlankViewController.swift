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

    var test: GymDetailCalendarView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray04

        NetworkManager.shared.getGym(id: GymIds.helenNewman) { gym in
            print(gym.facilities.map { $0.name })
            let f = gym.facilities[4].details.first
//            print(f?.times)
            self.test = GymDetailCalendarView(facilityDetail: f!)
            self.view.addSubview(self.test)
//            print(f!)
            self.setupConstraints()
        }

    }

    func setupConstraints() {
        test.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.center.equalToSuperview()
//            make.height.equalTo(150)
        }
    }
}
