//
//  ActivitesScreenHeaderView.swift
//  Uplift
//
//  Created by Elvis Marcelo on 4/27/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import SnapKit
import UIKit

class ActivitesScreenHeaderView: UIView {

    private var welcomeMessage: UILabel!
    private var didSetupShadow = false

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .white

        welcomeMessage = UILabel()
        welcomeMessage.font = ._24MontserratBold
        welcomeMessage.textColor = .primaryBlack
        welcomeMessage.lineBreakMode = .byWordWrapping
        welcomeMessage.numberOfLines = 0
        welcomeMessage.text = "Activities"
        addSubview(welcomeMessage)

        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LAYOUT
    private func setupLayout() {
        welcomeMessage.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(20)
            make.leading.equalTo(24)
            make.trailing.lessThanOrEqualToSuperview().inset(24)
        }
    }
}

