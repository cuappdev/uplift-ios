//
//  SportsDetailDiscussionCollectionViewCell.swift
//  Uplift
//
//  Created by Artesia Ko on 4/18/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import UIKit

class SportsDetailDiscussionCollectionViewCell: UICollectionViewCell {
    
    private let headerLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        headerLabel.text = ClientStrings.SportsDetail.discussionSection
        headerLabel.font = ._16MontserratBold
        headerLabel.textAlignment = .center
        headerLabel.numberOfLines = 0
        headerLabel.textColor = .primaryBlack
        contentView.addSubview(headerLabel)
    }
    
    func setupConstraints() {
        let headerLabelTopPadding = 24
        
        headerLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(headerLabelTopPadding)
        }
    }
    
    func configure(for post: Post) {
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
