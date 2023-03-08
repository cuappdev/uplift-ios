//
//  TodaysClassesHeaderView.swift
//  Uplift
//
//  Created by Joseph Fulgieri on 10/26/18.
//  Copyright © 2018 Uplift. All rights reserved.
//

import Crashlytics
import UIKit

protocol NavigationDelegate {
    func viewTodaysClasses()
}

class HomeSectionHeaderView: UICollectionReusableView {

    // MARK: - INITIALIZATION
    static let identifier = Identifiers.homeSectionHeaderView
    static let height: CGFloat = 32
    
    private var titleLabel: UILabel!
    private var navigationButton: UIButton!

    private var buttonCompletion: (() -> Void)? = nil

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = UIColor.clear

        titleLabel = UILabel()
        titleLabel.font = ._14MontserratBold
        titleLabel.textColor = .gray04
        titleLabel.text = ""
        addSubview(titleLabel)

        navigationButton = UIButton()
        navigationButton.setTitleColor(.gray04, for: .normal)
        navigationButton.contentHorizontalAlignment = .right
        navigationButton.titleLabel?.font = ._14LatoBlack
        navigationButton.addTarget(self, action: #selector(viewAll), for: .touchUpInside)
        addSubview(navigationButton)

        setupConstraints()
    }

    // MARK: - CONSTRAINTS
    private func setupConstraints() {
        let leadingInset = 16
        let navigationButtonHeight = 20
        let titleLabelHeight = 20
        let trailingInset = 16
        
        titleLabel.snp.updateConstraints { make in
            make.leading.equalToSuperview().inset(leadingInset)
            make.trailing.equalToSuperview().inset(trailingInset)
            make.centerY.equalToSuperview()
            make.height.equalTo(titleLabelHeight)
        }

        navigationButton.snp.updateConstraints { make in
            make.trailing.equalToSuperview().inset(trailingInset)
            make.bottom.equalTo(titleLabel)
            make.height.equalTo(navigationButtonHeight)
            make.width.equalTo(0)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String, buttonTitle: String?, completion: @escaping (() -> Void) ) {
        titleLabel.text = title
        if let buttonTitle = buttonTitle {
            navigationButton.isHidden = false
            navigationButton.setTitle(buttonTitle, for: .normal)
            
            navigationButton.snp.updateConstraints { make in
                make.width.equalTo(navigationButton.intrinsicContentSize.width)
            }
        } else {
            navigationButton.isHidden = true
        }

        buttonCompletion = completion
    }

    @objc private func viewAll() {
        // MARK: - Fabric
        Answers.logCustomEvent(withName: "Found Info on Homepage", customAttributes: [
            "Section": "\(HomeViewController.SectionType.todaysClasses.rawValue)/viewAll"
            ])

        buttonCompletion?()
    }
}
