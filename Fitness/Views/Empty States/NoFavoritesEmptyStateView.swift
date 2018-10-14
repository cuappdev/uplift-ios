//
//  NoFavoritesEmptyStateView.swift
//  Fitness
//
//  Created by Joseph Fulgieri on 10/13/18.
//  Copyright © 2018 Keivan Shahida. All rights reserved.
//

import UIKit

class NoFavoritesEmptyStateView: UIView {
    
    // MARK: - INITIALIZATION
    var emptyStateTitleLabel: UILabel!
    var emptyStateImageView: UIImageView!
    var emptyStateDescriptionLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        emptyStateTitleLabel = UILabel()
        emptyStateTitleLabel.text = "FIND YOUR\nFAVORITE NOW."
        emptyStateTitleLabel.font = ._20MontserratBold
        emptyStateTitleLabel.textColor = .fitnessBlack
        emptyStateTitleLabel.textAlignment = .center
        emptyStateTitleLabel.numberOfLines = 2
        addSubview(emptyStateTitleLabel)
        
        emptyStateImageView = UIImageView(image: UIImage(named: "bag"))
        addSubview(emptyStateImageView)
        
        emptyStateDescriptionLabel = UILabel()
        emptyStateDescriptionLabel.text = "Sit back and make yourself some tea"
        emptyStateDescriptionLabel.font = ._14MontserratRegular
        emptyStateDescriptionLabel.textColor = .fitnessBlack
        addSubview(emptyStateDescriptionLabel)
        
        emptyStateTitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.lessThanOrEqualToSuperview()
            make.top.equalToSuperview().offset(184)
            make.height.equalTo(emptyStateTitleLabel.intrinsicContentSize.height)
        }
        
        emptyStateImageView.snp.makeConstraints { make in
            make.top.equalTo(emptyStateTitleLabel.snp.bottom).offset(36)
            make.width.equalTo(109.0)
            make.height.equalTo(85.0)
            make.centerX.equalToSuperview()
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


