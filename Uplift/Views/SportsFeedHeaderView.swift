//
//  SportsFeedHeaderView.swift
//  Uplift
//
//  Created by Cameron Hamidi on 2/16/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import SnapKit
import UIKit

class SportsFeedHeaderView: UIView {

    private let addButton = UIButton()
    private let profilePicButton = UIButton()
    private let profilePicSize: CGFloat = 36
    private let titleLabel = UILabel()
    
    var profilePicPressed: (() -> ())!

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .white

        profilePicButton.setImage(UIImage(named: ImageNames.profilePicDemo), for: .normal)
        profilePicButton.layer.cornerRadius = profilePicSize / 2.0
        profilePicButton.addTarget(self, action: #selector(profileButtonPressed), for: .touchUpInside)
        addSubview(profilePicButton)

        titleLabel.text = "Sports"
        titleLabel.font = ._24MontserratBold
        titleLabel.textColor = .black
        titleLabel.textAlignment = .left
        addSubview(titleLabel)

        addButton.setImage(UIImage(named: ImageNames.addSports), for: .normal)
        addSubview(addButton)

        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func profileButtonPressed() {
        if let profileClosure = profilePicPressed {
            profileClosure()
        }
    }

    // MARK: - LAYOUT
    func setupConstraints() {
        let addButtonSize = 20
        let addButtonTrailingOffset = -18
        let profilePicBottomOffset = -16
        let profilePicLeadingOffset = 16
        let titleLabelLeadingOffset = 12

        profilePicButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(profilePicLeadingOffset)
            make.bottom.equalToSuperview().offset(profilePicBottomOffset)
            make.height.width.equalTo(profilePicSize)
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(profilePicButton.snp.trailing).offset(titleLabelLeadingOffset)
            make.centerY.equalTo(profilePicButton.snp.centerY)
        }

        addButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(addButtonTrailingOffset)
            make.height.width.equalTo(addButtonSize)
            make.centerY.equalTo(profilePicButton.snp.centerY)
        }
    }
}
