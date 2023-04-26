//
//  ActivityListItemCell.swift
//  Uplift
//
//  Created by Elvis Marcelo on 4/9/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import Foundation
import SnapKit
import UIKit

class ActivityListItemCell: ListItemCollectionViewCell<Activity> {

    // MARK: - Public static vars
    static let identifier = Identifiers.activitiesCell

    // MARK: - Private view vars
    private var activityImageView = UIImageView()
    private let activityLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
        setupConstraints()
    }

    // MARK: - Public configure
    override func configure(for sport: Activity) {
        super.configure(for: sport)

        activityLabel.text = sport.name
        activityImageView.image = sport.image
    }

    private func setupViews() {
        let imageViewOpacity: Float = 0.15
        let imageViewshadowRadius: CGFloat = 4

        activityImageView.layer.shadowColor = UIColor.black.cgColor
        activityImageView.layer.shadowOpacity = imageViewOpacity
        activityImageView.layer.shadowOffset = CGSize(width: 1, height: 2)
        activityImageView.layer.shadowRadius = imageViewshadowRadius
        activityImageView.contentMode = .scaleAspectFit
        contentView.addSubview(activityImageView)

        activityLabel.textAlignment = .center
        activityLabel.font = ._12MontserratMedium
        contentView.addSubview(activityLabel)
    }

    private func setupConstraints() {
        let labelPadding: CGFloat = 5
        let sportsImageViewPadding: CGFloat = 20
        let sportsImageViewWidthHeight: CGFloat = 70

        activityImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(sportsImageViewPadding)
            make.centerX.equalToSuperview()
            make.width.equalTo(sportsImageViewWidthHeight)
            make.height.equalTo(sportsImageViewWidthHeight)
        }

        activityLabel.snp.makeConstraints { make in
            make.top.equalTo(activityImageView.snp.bottom).offset(labelPadding)
            make.width.equalToSuperview()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

