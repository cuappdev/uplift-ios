//
//  SportListItemCell.swift
//  Uplift
//
//  Created by Elvis Marcelo on 4/9/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import Foundation

import SnapKit
import UIKit

class SportListItemCell: ListItemCollectionViewCell<Sport> {

    // MARK: - Public static vars
    static let identifier = Identifiers.sportsCell

    // MARK: - Private view vars
    private var sportsImageView = UIImageView()
    private let sportsLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.layer.masksToBounds = false
        contentView.clipsToBounds = true

        setupViews()
        setupConstraints()
    }

    // MARK: - Public configure
    override func configure(for sport: Sport) {
        super.configure(for: sport)

        sportsLabel.text = sport.name
        sportsImageView.image = sport.image
    }

    private func setupViews() {
        let imageViewOpacity: Float = 0.5
        let imageViewshadowRadius: CGFloat = 0.25

        sportsImageView.layer.shadowColor = UIColor.black.cgColor
        sportsImageView.layer.shadowOpacity = imageViewOpacity
        sportsImageView.layer.shadowOffset = CGSize(width: 1, height: 2)
        sportsImageView.layer.shadowRadius = imageViewshadowRadius
        sportsImageView.contentMode = .scaleAspectFit
        sportsImageView.clipsToBounds = true
        contentView.addSubview(sportsImageView)

        sportsLabel.textAlignment = .center
        sportsLabel.font = ._12MontserratMedium
        contentView.addSubview(sportsLabel)
    }

    private func setupConstraints() {
        let labelPadding: CGFloat = 5
        let sportsImageViewPadding: CGFloat = 15

        sportsImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(sportsImageViewPadding)
            make.centerX.equalToSuperview()
        }

        sportsLabel.snp.makeConstraints { make in
            make.top.equalTo(sportsImageView.snp.bottom).offset(labelPadding)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

