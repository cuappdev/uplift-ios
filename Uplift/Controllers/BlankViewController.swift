//
//  BlankViewController.swift
//  Uplift
//
//  Created by Phillip OReggio on 11/19/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import UIKit

class BlankViewController: UIViewController {

    var testView: OnboardingView!
    var rightButton: OnboardingArrowButton!
    var leftButton: OnboardingArrowButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Class Test
        NetworkManager.shared.getClassNames { classes in
            let image: UIImage! = UIImage(named: ImageNames.runningMan)
            let text = "Here is some sample text. This is a decent length string. Filler Text."
            self.testView = OnboardingView(image: image, text: text, classNames: classes.map { $0 })
            self.view.addSubview(self.testView)

            self.rightButton = OnboardingArrowButton(arrowFacesRight: true)
            self.leftButton = OnboardingArrowButton(arrowFacesRight: false)

            self.setupConstraints()
        }

        // Gyms Test
        NetworkManager.shared.getGymNames { gyms in
            let image: UIImage! = UIImage(named: ImageNames.runningMan)
            let text = "Here is some sample text. This is a decent length string. Filler Text."
            self.testView = OnboardingView(image: image, text: text, gymNames: gyms.map { $0.name })
            self.view.addSubview(self.testView)

            self.rightButton = OnboardingArrowButton(arrowFacesRight: true)
            self.leftButton = OnboardingArrowButton(arrowFacesRight: false)

            self.setupConstraints()
        }
    }

    func setupConstraints() {
        testView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(500)
            make.width.equalTo(350)
        }

        rightButton.snp.makeConstraints { make in
            make.width.height.equalTo(35)
            make.leading.equalToSuperview().inset(30)
            make.top.equalTo(testView.snp.bottom).offset(20)
        }

        leftButton.snp.makeConstraints { make in
            make.width.height.equalTo(35)
            make.trailing.equalToSuperview().inset(30)
            make.top.equalTo(testView.snp.bottom).offset(20)
        }
    }
}
