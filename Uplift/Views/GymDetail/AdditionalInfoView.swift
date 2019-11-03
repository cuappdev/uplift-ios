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

    private let displayTextView = UILabel()
    private let sidebarView = UIView()

    var text = "" {
        didSet {
            displayTextView.text = text
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .primaryLightYellow
        displayTextView.font = ._12MontserratLight
        displayTextView.textAlignment = .right
        addSubview(displayTextView)

        let cornerRadius: CGFloat = 2.0
        layer.cornerRadius = cornerRadius

        sidebarView.backgroundColor = .primaryYellow
        addSubview(sidebarView)

        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        let sidebarWidth = 1.0
        let inset = 2.0

        displayTextView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.trailing.equalToSuperview().inset(inset)
        }

        sidebarView.snp.makeConstraints { make in
            make.width.equalTo(sidebarWidth)
            make.height.leading.equalToSuperview()
        }
    }

}
