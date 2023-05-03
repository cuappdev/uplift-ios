//
//  ActivityTableViewCell.swift
//  Uplift
//
//  Created by Elvis Marcelo on 4/26/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import UIKit

class ActivityCollectionViewCell: UICollectionViewCell {

    private var activity: Activity!
    private let iconImageView = UIImageView()
    private let iconLabel = UILabel()
    private let starButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
        setupConstraints()
    }

    func configure(for activity: Activity) {
        iconImageView.image = activity.image
        iconLabel.text = activity.name
        self.activity = activity
    }

    private func setupViews() {
        contentView.addSubview(iconImageView)

        iconLabel.font = ._16MontserratBold
        contentView.addSubview(iconLabel)

        contentView.layer.cornerRadius = 15
        contentView.backgroundColor = .white
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.layer.shadowRadius = 4
        contentView.layer.shadowOpacity = 0.2

        starButton.setBackgroundImage(UIImage(named: ImageNames.starOutlineDark), for: .normal)
        starButton.addTarget(self, action: #selector(favorited), for: .touchUpInside)
        contentView.addSubview(starButton)
    }

    private func setupConstraints() {
        let starPadding = 17
        let imageDimensions = 30
        let labelPadding = 12

        iconImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(starPadding)
            make.centerY.equalToSuperview()
            make.height.equalTo(imageDimensions)
            make.width.equalTo(imageDimensions)
        }

        iconLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconImageView.snp.trailing).offset(labelPadding)
            make.centerY.equalToSuperview()
        }

        starButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-starPadding)
            make.centerY.equalToSuperview()
        }
    }

    @objc func favorited(sender: UIButton) {
        if activity.isFavorite {
            sender.setBackgroundImage(UIImage(named: ImageNames.starOutlineDark), for: .normal)
        } else {
            sender.setBackgroundImage(UIImage(named: ImageNames.starFilledInDark), for: .normal)
        }
        activity.isFavorite.toggle()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
