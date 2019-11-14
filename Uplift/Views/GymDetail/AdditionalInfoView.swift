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

    private let infoLabel = UILabel()
    private let sidebarView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        infoLabel.backgroundColor = UIColor(red: 0.973, green: 0.906, blue: 0.11, alpha: 0.2)
        infoLabel.font = ._12MontserratLight
        infoLabel.textAlignment = .center
        infoLabel.layer.cornerRadius = 2.0
        infoLabel.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        infoLabel.clipsToBounds = true
        addSubview(infoLabel)

        sidebarView.backgroundColor = .primaryYellow
        addSubview(sidebarView)

        setupConstraints()
    }

    func configure(for text: String) {
        infoLabel.text = text

        let inset: CGFloat = 3.0
        infoLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(sidebarView.snp.trailing)
            make.width.equalTo(infoLabel.intrinsicContentSize.width + inset * 2)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        let sidebarWidth = 1.75

        sidebarView.snp.makeConstraints { make in
            make.width.equalTo(sidebarWidth)
            make.height.centerY.leading.equalToSuperview()
        }
    }

}
