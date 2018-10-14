//
//  DropdownFooterView.swift
//  Fitness
//
//  Created by Joseph Fulgieri on 4/15/18.
//  Copyright © 2018 Uplift. All rights reserved.
//

import UIKit
import SnapKit

class DropdownFooterView: UITableViewHeaderFooterView {

    // MARK: - INITIALIZATION
    static let identifier = Identifiers.dropdownFooterView
    var showHideLabel: UILabel!

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        layer.backgroundColor = UIColor.white.cgColor

        showHideLabel = UILabel()
        showHideLabel.font = ._12MontserratMedium
        showHideLabel.sizeToFit()
        showHideLabel.textColor = UIColor(red: 165/255, green: 165/255, blue: 165/255, alpha: 1.0)
        contentView.addSubview(showHideLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - CONSTRAINTS
    override open func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
    }

    func setupConstraints() {
        showHideLabel.snp.updateConstraints {make in
            make.bottom.equalToSuperview().offset(-16)
            make.left.equalToSuperview().offset(16)
        }
    }
}
