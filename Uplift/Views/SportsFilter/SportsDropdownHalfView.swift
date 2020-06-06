//
//  SportsDropdownHalfView.swift
//  Uplift
//
//  Created by Cameron Hamidi on 6/3/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import SnapKit
import UIKit

class SportsDropdownHalfView: UIView {

    private let label = UILabel()

    let labelLeadingOffset = 16

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .clear

        label.font = ._12MontserratMedium
        label.textColor = UIColor.gray07.withAlphaComponent(0.8)
        label.textAlignment = .left
        addSubview(label)

        label.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(labelLeadingOffset)
            make.trailing.top.equalToSuperview()
        }

    }

    func setLabelText(to string: String) {
        label.text = string
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
