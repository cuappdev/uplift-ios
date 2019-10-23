//
//  NoFavoritesEmptyStateView.swift
//  Uplift
//
//  Created by Joseph Fulgieri on 10/13/18.
//  Copyright © 2018 Cornell AppDev. All rights reserved.
//

import UIKit

class NoFavoritesEmptyStateView: UIView {

    // MARK: - INITIALIZATION
    var emptyStateImageView: UIImageView!
    var emptyStateTitleLabel: UILabel!
    var findClassesButton: UIButton!

    var delegate: NavigationDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)

        // TITLE
        emptyStateTitleLabel = UILabel()
        emptyStateTitleLabel.text = ClientStrings.Favorites.noFavoritesText
        emptyStateTitleLabel.font = ._20MontserratBold
        emptyStateTitleLabel.textColor = .primaryBlack
        emptyStateTitleLabel.textAlignment = .center
        emptyStateTitleLabel.numberOfLines = 2
        addSubview(emptyStateTitleLabel)

        // IMAGE
        emptyStateImageView = UIImageView(image: UIImage(named: "bag"))
        addSubview(emptyStateImageView)

        // FIND CLASSES BUTTON
        findClassesButton = UIButton()
        findClassesButton.setTitle(ClientStrings.Favorites.browseClasses, for: .normal)
        findClassesButton.addTarget(self, action: #selector(findClasses), for: .touchUpInside)
        findClassesButton.titleLabel?.font = ._14MontserratBold
        findClassesButton.setTitleColor(UIColor.primaryBlack, for: .normal)

        findClassesButton.backgroundColor = .primaryYellow
        findClassesButton.layer.cornerRadius = 32
        findClassesButton.layer.shadowColor = UIColor.buttonShadow.cgColor
        findClassesButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        findClassesButton.layer.shadowRadius = 4.0
        findClassesButton.layer.shadowOpacity = 1.0
        addSubview(findClassesButton)

        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - CONSTRAINTS
    func setupConstraints() {
        emptyStateTitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.lessThanOrEqualToSuperview()
            make.top.equalToSuperview().offset(64)
            make.height.equalTo(emptyStateTitleLabel.intrinsicContentSize.height)
        }

        emptyStateImageView.snp.makeConstraints { make in
            make.top.equalTo(emptyStateTitleLabel.snp.bottom).offset(36)
            make.width.equalTo(109.0)
            make.height.equalTo(85.0)
            make.centerX.equalToSuperview()
        }

        findClassesButton.snp.makeConstraints { make in
            make.top.equalTo(emptyStateImageView.snp.bottom).offset(36)
            make.leading.equalToSuperview().offset(70)
            make.trailing.equalToSuperview().offset(-70)
            make.height.equalTo(64)
        }
    }

    @objc func findClasses() {
        delegate?.viewTodaysClasses()
    }
}
