//
//  TodaysClassesHeaderView.swift
//  Fitness
//
//  Created by Joseph Fulgieri on 10/26/18.
//  Copyright © 2018 Uplift. All rights reserved.
//

import UIKit

protocol NavigationDelegate {
    func changeTab(index: Int)
}

class TodaysClassesHeaderView: UICollectionReusableView {

    // MARK: - INITIALIZATION
    static let identifier = Identifiers.todaysClassesHeaderView
    var titleLabel: UILabel!
    var viewAllButton: UIButton!
    var delegate: NavigationDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = UIColor.clear

        titleLabel = UILabel()
        titleLabel.font = ._14MontserratBold
        titleLabel.textColor = .fitnessDarkGrey
        titleLabel.text = "TODAY'S CLASSES"
        addSubview(titleLabel)

        viewAllButton = UIButton()
        viewAllButton.setTitle("view all", for: .normal)
        viewAllButton.setTitleColor(.fitnessDarkGrey, for: .normal)
        viewAllButton.titleLabel?.font = ._12LatoBlack
        viewAllButton.addTarget(self, action: #selector(viewAll), for: .touchUpInside)
        addSubview(viewAllButton)

        // MARK: - CONSTRAINTS
        titleLabel.snp.updateConstraints {make in
            make.leading.equalTo(16)
            make.top.trailing.equalToSuperview()
            make.height.equalTo(titleLabel.intrinsicContentSize.height)
        }

        viewAllButton.snp.updateConstraints { make in
            make.trailing.equalToSuperview()
            make.width.equalTo(60)
            make.bottom.equalTo(titleLabel)
            make.height.equalTo(titleLabel)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func viewAll() {
        guard let navigationDelegate = delegate else { return }
        navigationDelegate.changeTab(index: 1)
    }
}
