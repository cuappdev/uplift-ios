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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Class Test
        NetworkManager.shared.getAllClassNames { classes in
            let image = UIImage(named: ImageConstants.court)
            let text = "Here is some sample text. This is a decent length string. Filler Text."
            self.testView = OnboardingView(image: image, text: text, classNames: classes)
            self.view.addSubview(self.testView)
            setUpConstraints()
        }

        // Gyms Test
        NetworkManager.shared.getAllGymNames { classes in
            let image = UIImage(named: ImageConstants.court)
            let text = "Here is some sample text. This is a decent length string. Filler Text."
            self.testView = OnboardingView(image: image, text: text, classNames: classes)
            self.view.addSubview(self.testView)
            setUpConstraints()
        }
    }

    func setupConstraints() {
        testView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(500)
            make.width.equalTo(350)
        }
    }
}
