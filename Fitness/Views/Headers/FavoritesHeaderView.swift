//
//  FavoritesHeaderView.swift
//  Fitness
//
//  Created by Joseph Fulgieri on 4/15/18.
//  Copyright © 2018 Keivan Shahida. All rights reserved.
//

import UIKit
import SnapKit

class FavoritesHeaderView: UITableViewHeaderFooterView {

    // MARK: - INITIALIZAITON
    static let identifier =  Identifiers.favoritesHeaderView
    var quoteLabel: UILabel!
    var nextSessionsLabel: UILabel!

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        //BACKGROUND COLOR
        backgroundView = UIView(frame: frame)
        backgroundView?.backgroundColor = .white

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
            make.right.equalToSuperview().offset(-60)
            make.left.equalToSuperview().offset(60)
            make.top.equalToSuperview().offset(73)
        }

        nextSessionsLabel.snp.updateConstraints {make in
            make.top.equalTo(quoteLabel.snp.bottom).offset(52)
            make.bottom.equalTo(quoteLabel.snp.bottom).offset(67)
            make.centerX.equalToSuperview()
        }
    }
}
