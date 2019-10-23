//
//  AdditionalInfoView.swift
//  Uplift
//
//  Created by Phillip OReggio on 10/22/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import UIKit
/// Displays additional info from Facilities Query in GymDetailTimeInfoView
class AdditionalInfoView: UILabel {

    private var sidebar: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .primaryLightYellow
        font = ._12MontserratLight
        textAlignment = .right
        sidebar = UIView()
        sidebar.backgroundColor = .primaryYellow
        addSubview(sidebar)
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        let sidebarWidth = 1.0
        sidebar.snp.makeConstraints { make in
            make.width.equalTo(sidebarWidth)
            make.height.leading.equalToSuperview()
        }
    }

    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 2)
        super.drawText(in: rect.inset(by: insets))
    }
}
