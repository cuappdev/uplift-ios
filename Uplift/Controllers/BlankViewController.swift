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
        view.backgroundColor = .primaryWhite

        // Class Test
//        NetworkManager.shared.getClassNames { classes in
//            let image: UIImage! = UIImage(named: ImageNames.onboarding3)
//            let text = "Here is some sample text. This is a decent length string. Filler Text."
//            self.testView = OnboardingView(image: image, text: text, classNames: classes.map { $0 })
//            self.view.addSubview(self.testView)
//
//            self.rightButton = OnboardingArrowButton(arrowFacesRight: true)
//            self.rightButton.addTarget(self, action: #selector(self.buttonFunc), for: .touchDown)
//            self.view.addSubview(self.rightButton)
//
//            self.leftButton = OnboardingArrowButton(arrowFacesRight: false, changesColor: false)
//            self.leftButton.addTarget(self, action: #selector(self.buttonFunc), for: .touchDown)
//            self.view.addSubview(self.leftButton)
//
//            self.setupConstraints()
//        }

        // Gyms Test
        NetworkManager.shared.getGymNames { gyms in
            let image: UIImage! = UIImage(named: ImageNames.onboarding4)
            let text = "Here is some sample text. This is a decent length string. Filler Text."
            self.testView = OnboardingView(image: image, text: text, gymNames: gyms.map { $0.name })
            self.view.addSubview(self.testView)

            self.rightButton = OnboardingArrowButton(arrowFacesRight: true)
            self.view.addSubview(self.rightButton)

            self.leftButton = OnboardingArrowButton(arrowFacesRight: false, changesColor: false)
            self.view.addSubview(self.leftButton)

            self.setupConstraints()
        }
    }

    func setupConstraints() {
        testView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(40)
            make.centerX.equalToSuperview()
            make.height.equalTo(600)
            make.width.equalToSuperview()
        }

        leftButton.snp.makeConstraints { make in
            make.width.height.equalTo(35)
            make.leading.equalToSuperview().inset(30)
            make.bottom.equalToSuperview().inset(60)
        }

        rightButton.snp.makeConstraints { make in
            make.width.height.equalTo(35)
            make.trailing.equalToSuperview().inset(30)
            make.bottom.equalToSuperview().inset(60)
        }
    }

    @objc func buttonFunc(sender: UIButton) {
        if let arrow = sender as? OnboardingArrowButton {
            arrow.toggleState(on: false)
        }
    }
}
