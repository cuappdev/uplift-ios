//
//  DropdownFooterView.swift
//  Uplift
//
//  Created by Joseph Fulgieri on 4/15/18.
//  Copyright © 2018 Uplift. All rights reserved.
//

import SnapKit
import UIKit

class DropdownFooterView: UIView {

    // MARK: - INITIALIZATION
    static let identifier = Identifiers.dropdownFooterView
    var showHideLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        isUserInteractionEnabled = true
        
        showHideLabel = UILabel()
        showHideLabel.font = ._12MontserratMedium
        showHideLabel.sizeToFit()
        showHideLabel.textColor = .gray02
        addSubview(showHideLabel)
        setupConstraints()
    }

    func setupConstraints() {
        showHideLabel.snp.updateConstraints { make in
            make.bottom.equalToSuperview().offset(-16)
            make.left.equalToSuperview().offset(16)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
