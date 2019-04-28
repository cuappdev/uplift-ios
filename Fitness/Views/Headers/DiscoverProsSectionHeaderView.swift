//
//  DiscoverProsSectionHeaderView.swift
//  Fitness
//
//  Created by Cameron Hamidi on 4/22/19.
//  Copyright © 2019 Keivan Shahida. All rights reserved.
//

import UIKit

class DiscoverProsSectionHeaderView: UICollectionReusableView {
    
    // MARK: - INITIALIZATION
    static let identifier = Identifiers.DiscoverProsSectionHeaderView
    var titleLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.clear
        
        titleLabel = UILabel()
        titleLabel.font = ._14MontserratBold
        titleLabel.textColor = .fitnessDarkGrey
        addSubview(titleLabel)
        
        // MARK: - CONSTRAINTS
        titleLabel.snp.updateConstraints {make in
            make.leading.equalTo(16)
            make.top.equalToSuperview()
            make.height.equalTo(titleLabel.intrinsicContentSize.height)
        }
    }
    
    func setTitle(title: String) {
        titleLabel.text = title
        
        titleLabel.snp.updateConstraints { make in
            make.height.equalTo(titleLabel.intrinsicContentSize.height)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
