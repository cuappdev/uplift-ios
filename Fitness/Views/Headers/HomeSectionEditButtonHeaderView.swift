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

class HomeSectionEditButtonHeaderView: UICollectionReusableView {

    // MARK: - INITIALIZATION
    static let identifier = Identifiers.homeSectionEditButtonHeaderView
    var titleLabel: UILabel!
    var viewAllButton: UIButton!
//    var delegate: NavigationDelegate?
    var buttonCompletion: () -> Void = {}

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = UIColor.clear

        titleLabel = UILabel()
        titleLabel.font = ._14MontserratBold
        titleLabel.textColor = .fitnessDarkGrey
        titleLabel.text = ""
        addSubview(titleLabel)

        viewAllButton = UIButton()
        viewAllButton.setTitleColor(.fitnessDarkGrey, for: .normal)
        viewAllButton.contentHorizontalAlignment = .right
        viewAllButton.titleLabel?.font = ._14LatoBlack
        viewAllButton.addTarget(self, action: #selector(viewAll), for: .touchUpInside)
        addSubview(viewAllButton)

        // MARK: - CONSTRAINTS
        titleLabel.snp.updateConstraints { make in
            make.leading.equalTo(16)
            make.top.trailing.equalToSuperview()
            make.height.equalTo(20)
        }

        viewAllButton.snp.updateConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.width.equalTo(60)
            make.bottom.equalTo(titleLabel)
            make.height.equalTo(titleLabel)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String, buttonTitle: String, completion: @escaping (() -> Void) ) {
        titleLabel.text = title
        viewAllButton.setTitle(buttonTitle, for: .normal)
        buttonCompletion = completion
    }

    @objc func viewAll() {
        // MARK: - Fabric
        Answers.logCustomEvent(withName: "Found Info on Homepage", customAttributes: [
            "Section": "\(SectionType.todaysClasses.rawValue)/viewAll"
            ])

        buttonCompletion()
    }
}
