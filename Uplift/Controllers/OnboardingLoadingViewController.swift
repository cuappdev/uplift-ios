//
//  OnboardingLoadingViewController.swift
//  Uplift
//
//  Created by Phillip OReggio on 12/11/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import UIKit

class OnboardingLoadingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .primaryWhite

        let logo = UIImageView(image: UIImage(named: ImageNames.splashImage))
        logo.contentMode = .scaleAspectFit
        view.addSubview(logo)

        logo.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(CGSize(width: 122, height: 122))
        }
    }

}
