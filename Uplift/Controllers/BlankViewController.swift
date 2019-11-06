//
//  BlankViewController.swift
//  Uplift
//
//  Created by Phillip OReggio on 11/3/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import UIKit

class BlankViewController: UIViewController {

    var calendar: GymDetailWeekView!
    var court: CourtView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray02

        NetworkManager.shared.getGym(id: GymIds.helenNewman) { gym in
            self.court = CourtView(facility: gym.facilities[2].details.first!, gymHours: gym.gymHours)
            self.calendar = GymDetailWeekView()
            self.calendar.delegate = self.court
            self.view.addSubview(self.calendar)
            self.view.addSubview(self.court)
            self.setupConstraints()
        }
    }

    func setupConstraints() {
        calendar.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.leading.trailing.equalToSuperview()
            make.centerY.equalToSuperview().offset(-40)
        }

        court.snp.makeConstraints { make in
            make.height.equalTo(190)
            make.top.equalTo(calendar.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview()
            make.centerX.equalToSuperview()
        }
    }

}
