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
        var facility: Facility!
        NetworkManager.shared.getGym(id: GymIds.teagleDown) { gym in
            facility = gym.facilities.randomElement()
            self.test = GymDetailCalendarView(facility: facility)
            self.view.addSubview(self.test)
            self.setupConstraints()
        }

    }

    func setupConstraints() {
        test.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.center.equalToSuperview()
            make.height.equalTo(150)
        }
    }
}
