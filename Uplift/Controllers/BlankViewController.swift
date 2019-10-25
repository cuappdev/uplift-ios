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

        NetworkManager.shared.getGyms() { gyms in
            var facility: Facility!
            for i in 0..<gyms.count {
                guard !gyms[i].facilities.isEmpty else { continue }
                for j in 0..<gyms[i].facilities.count {
                    if !gyms[i].facilities[j].times.isEmpty {
                        facility = gyms[i].facilities[j]
                        break
                    }

                    if facility != nil { break }
                }
            }


            print(facility)
            self.test = GymDetailCalendarView(facility: facility)
            self.view.addSubview(self.test)
            self.setupConstraints()
        }
    }

    func setupConstraints() {
        test.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.center.equalToSuperview()
        }
    }
}
