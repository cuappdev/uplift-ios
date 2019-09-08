//
//  ProCell.swift
//  Uplift
//
//  Created by Cameron Hamidi on 4/22/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import UIKit
import SnapKit

class ProListItemCell: ListItemCollectionViewCell<ProBio> {
    
    // MARK: - Public static vars
    static let identifier = Identifiers.proCell

    // MARK: - Private view vars
    private let imageView = UIImageView()
    private let nameLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.layer.cornerRadius = contentView.frame.height / 16
        contentView.clipsToBounds = true

        setupViews()
        setupConstraints()
    }

    // MARK: - Overrides
    override func configure(for item: ProBio) {
        imageView.image = item.secondaryProfilePic
        nameLabel.text = item.name
    }
    
    // MARK: - Private helpers
    private func setupViews() {
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        contentView.addSubview(imageView)

        nameLabel.font = ._20MontserratBold
        nameLabel.textColor = .white
        nameLabel.layer.shadowRadius = 2
        nameLabel.layer.shadowOpacity = 1.0
        nameLabel.layer.shadowOffset = CGSize(width: 4, height: 4)
        nameLabel.layer.shadowColor = UIColor.black.cgColor
        nameLabel.sizeToFit()
        nameLabel.textAlignment = .center
        nameLabel.numberOfLines = 0
        contentView.addSubview(nameLabel)
    }

    private func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        nameLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
