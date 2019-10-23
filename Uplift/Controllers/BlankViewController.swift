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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray04

        stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .fill

        let weekView = GymDetailWeekView()
        weekView.snp.makeConstraints { make in
            make.height.equalTo(30)
        }
        let timeInfo = GymDetailTimeInfoView()
//        timeInfo.snp.makeConstraints { make in
//            make.height.equalTo(120)
//        }
        weekView.delegate = timeInfo

        stack.addArrangedSubview(weekView)
        stack.addArrangedSubview(timeInfo)

//        let a = AdditionalInfoView()
//        a.text = "women only"
//        test = a
        view.addSubview(stack)
        setupConstraints()
    }

    func setupConstraints() {
        stack.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.center.equalToSuperview()
            make.height.equalTo(250)

//            make.center.equalToSuperview()
//            make.width.equalTo(80)
        }
    }
}
