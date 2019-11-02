//
//  AdditionalInfoView.swift
//  Uplift
//
//  Created by Phillip OReggio on 10/22/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import UIKit

/// Displays additional info from Facilities Query in GymDetailTimeInfoView
class AdditionalInfoView: UIView {

    private let displayText = UILabel()
    private let sidebarView = UIView()

    var text = "" {
        didSet {
            displayText.text = text
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .primaryLightYellow
        displayText.font = ._12MontserratLight
        displayText.textAlignment = .right
        addSubview(displayText)

        let cornerRadius: CGFloat = 2.0
        layer.cornerRadius = cornerRadius

        sidebar.backgroundColor = .primaryYellow
        addSubview(sidebar)

        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        let sidebarWidth = 1.0
        displayText.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.trailing.equalToSuperview().inset(2)
        }

        sidebar.snp.makeConstraints { make in
            make.width.equalTo(sidebarWidth)
            make.height.leading.equalToSuperview()
        }
    }

}
