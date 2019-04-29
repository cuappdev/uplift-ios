//
//  FavoritesHeaderView.swift
//  Fitness
//
//  Created by Joseph Fulgieri on 4/15/18.
//  Copyright © 2018 Uplift. All rights reserved.
//

import SnapKit
import UIKit

class FavoritesHeaderView: UICollectionReusableView {

    // MARK: - INITIALIZAITON
    static let identifier =  Identifiers.favoritesHeaderView
    var nextSessionsLabel: UILabel!
    var quoteLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)

        //BACKGROUND COLOR
        backgroundColor = .white

        //QUOTE LABEL
        quoteLabel = UILabel()
        quoteLabel.font = ._32Bebas
        quoteLabel.textColor = .fitnessBlack
        quoteLabel.textAlignment = .center
        quoteLabel.lineBreakMode = .byWordWrapping
        quoteLabel.numberOfLines = 0
        quoteLabel.text = "NOTHING CAN STOP YOU BUT YOURSELF."
        addSubview(quoteLabel)

        //SESSIONS LABEL
        nextSessionsLabel = UILabel()
        nextSessionsLabel.font = ._12LatoBlack
        nextSessionsLabel.textColor = .fitnessDarkGrey
        nextSessionsLabel.textAlignment = .center
        nextSessionsLabel.text = "COMING UP NEXT"
        addSubview(nextSessionsLabel)

        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - CONSTRAINTS
    func setupConstraints() {
        quoteLabel.snp.updateConstraints {make in
            make.trailing.equalToSuperview().offset(-30)
            make.leading.equalToSuperview().offset(30)
            make.top.equalToSuperview().offset(64)
        }

        nextSessionsLabel.snp.updateConstraints {make in
            make.top.equalTo(quoteLabel.snp.bottom).offset(62)
            make.centerX.equalToSuperview()
            make.width.lessThanOrEqualToSuperview().offset(40)
            make.height.equalTo(18)
        }
    }
}
