//
//  NoResultsEmptyStateView.swift
//  Uplift
//
//  Created by Joseph Fulgieri on 10/30/18.
//  Copyright © 2018 Cornell AppDev. All rights reserved.
//

import UIKit

class NoResultsEmptyStateView: UIView {

    // MARK: - INITIALIZATION
    var emptyStateImage: UIImageView!

    var emptyStateMessageLabel: UILabel!
    var emptyStateTitleLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)

        // IMAGE
        emptyStateImage = UIImageView(image: UIImage(named: "handgrip"))
        addSubview(emptyStateImage)
        
        // TITLE
        emptyStateTitleLabel = UILabel()
        emptyStateTitleLabel.text = ClientStrings.Filter.noResultsLabel
        emptyStateTitleLabel.font = ._24MontserratBold
        emptyStateTitleLabel.textColor = .primaryBlack
        emptyStateTitleLabel.textAlignment = .center
        addSubview(emptyStateTitleLabel)

        // MESSAGE
        emptyStateMessageLabel = UILabel()
        emptyStateMessageLabel.text = ClientStrings.Filter.noResultsDescription
        emptyStateMessageLabel.font = ._14MontserratRegular
        emptyStateMessageLabel.textColor = .primaryBlack
        emptyStateMessageLabel.textAlignment = .center
        addSubview(emptyStateMessageLabel)
        
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - CONSTRAINTS
    func setupConstraints() {
        emptyStateImage.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(128)
            make.width.height.equalTo(80)
            make.centerX.equalToSuperview()
        }

        emptyStateTitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.lessThanOrEqualToSuperview()
            make.top.equalTo(emptyStateImage.snp.bottom).offset(24)
            make.height.equalTo(emptyStateTitleLabel.intrinsicContentSize.height)
        }

        emptyStateMessageLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.lessThanOrEqualToSuperview()
            make.top.equalTo(emptyStateTitleLabel.snp.bottom).offset(8)
            make.height.equalTo(emptyStateTitleLabel.intrinsicContentSize.height)
        }
    }
}
