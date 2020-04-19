//
//  SportsDetailPlayersCollectionViewCell.swift
//  Uplift
//
//  Created by Artesia Ko on 4/18/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import UIKit

class SportsDetailPlayersCollectionViewCell: UICollectionViewCell {
    private let divider = UIView()
    private let headerLabel = UILabel()
    private let caratImage = UIImageView()
    
    private var dropStatus: DropdownStatus = .closed
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
        setupConstraints()
    }

    func setupViews() {
        headerLabel.font = ._16MontserratBold
        headerLabel.textAlignment = .center
        headerLabel.numberOfLines = 0
        headerLabel.textColor = .primaryBlack
        addSubview(headerLabel)
        
        caratImage.image = UIImage(named: ImageNames.rightArrowSolid)
        caratImage.contentMode = .scaleAspectFill
        caratImage.clipsToBounds = true
        addSubview(caratImage)
        
        divider.backgroundColor = .gray01
        addSubview(divider)
        
    }
    
    func setupConstraints() {
        let headerLabelTopPadding = 24
        let headerCaratHorizontalPadding = 12
        headerLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(headerLabelTopPadding)
        }
        
        caratImage.snp.makeConstraints { make in
            make.centerY.equalTo(headerLabel)
            make.height.equalTo(5)
            make.width.equalTo(9)
            make.leading.equalTo(headerLabel.snp.trailing).offset(headerCaratHorizontalPadding)
        }
        
        divider.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    func configure(for post: Post, dropStatus: DropdownStatus) {
        headerLabel.text = "PLAYERS \(post.players)/10"
        self.dropStatus = dropStatus
        caratImage.image = dropStatus == .open ? UIImage(named: ImageNames.rightArrowSolid)
            : UIImage(named: ImageNames.downArrowSolid)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
