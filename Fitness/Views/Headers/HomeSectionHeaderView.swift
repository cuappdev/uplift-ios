//
//  TodaysClassesHeaderView.swift
//  Fitness
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
    static let height = CGFloat(32)
    
    private var titleLabel: UILabel!
    private var navigationButton: UIButton!

    private var buttonCompletion: (() -> Void)? = nil

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = UIColor.clear

        titleLabel = UILabel()
        titleLabel.font = ._14MontserratBold
        titleLabel.textColor = .fitnessDarkGrey
        titleLabel.text = ""
        addSubview(titleLabel)

        navigationButton = UIButton()
        navigationButton.setTitleColor(.fitnessDarkGrey, for: .normal)
        navigationButton.contentHorizontalAlignment = .right
        navigationButton.titleLabel?.font = ._14LatoBlack
        navigationButton.addTarget(self, action: #selector(viewAll), for: .touchUpInside)
        addSubview(navigationButton)

        // MARK: - CONSTRAINTS
        titleLabel.snp.updateConstraints { make in
            make.leading.equalTo(16)
            make.top.trailing.equalToSuperview()
            make.height.equalTo(20)
        }

        navigationButton.snp.updateConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.width.equalTo(60)
            make.bottom.equalTo(titleLabel)
            make.height.equalTo(titleLabel)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String, buttonTitle: String?, completion: (() -> Void)? ) {
        titleLabel.text = title
        if let buttonTitle = buttonTitle {
            navigationButton.isHidden = false
            navigationButton.setTitle(buttonTitle, for: .normal)
        } else {
            navigationButton.isHidden = true
        }
        
        buttonCompletion = completion
    }

    @objc private func viewAll() {
        // MARK: - Fabric
        Answers.logCustomEvent(withName: "Found Info on Homepage", customAttributes: [
            "Section": "\(SectionType.todaysClasses.rawValue)/viewAll"
            ])

        buttonCompletion?()
    }
}
