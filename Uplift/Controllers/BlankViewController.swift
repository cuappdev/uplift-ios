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

    var stack: UIStackView!
    var h: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray04

        // Backend Debugging
        var facil: FakeFacility
        facil = FakeFacility()
//        NetworkManager.shared.getGym(id: GymIds.noyes) { gym in
//           print("-----")
//           print("facil: \(gym.facilities)")
//           facil = gym.facilities[0]
//        }
//        var f: Facility?
//        NetworkManager.shared.getGyms { gymsa in
//            print("\n\n\ndoing it")
//            gyms.forEach { gym in
//                if gym.facilities.count > 0 {
//                    f = gym.facilities[0]
//                }
//            }
//        }
//        DispatchQueue.main.async {
//            facil = f
//        }


        stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .fill

        let weekView = GymDetailWeekView()
        weekView.snp.makeConstraints { make in
            make.height.equalTo(24)
        }
        let timeInfo = GymDetailTimeInfoView(facility: facil)
        weekView.delegate = timeInfo

        h = timeInfo.calculateMaxHeight(width: view.window?.frame.width ?? 0)
        timeInfo.snp.makeConstraints { make in
            print("~~height: \(h)")
            make.height.equalTo(h)
        }

        stack.addArrangedSubview(weekView)
        stack.addArrangedSubview(timeInfo)

        stack.backgroundColor = .accentBlue
        view.addSubview(stack)
        setupConstraints()
    }

    func setupConstraints() {
        stack.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.center.equalToSuperview()
            make.height.equalTo(h + 24)

//            make.center.equalToSuperview()
//            make.width.equalTo(80)
        }
    }
}
