//
//  GymDetailHeaderView.swift
//  Fitness
//
//  Created by Yana Sang on 5/22/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import UIKit

class GymDetailHeaderView: UICollectionReusableView {

    // MARK: - Private view vars
    private let imageView = UIImageView()
    private let nameLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
        setupConstraints()
    }

    // MARK: - Public configure
    func configure(for gym: Gym) {
        imageView.kf.setImage(with: gym.imageURL)
        nameLabel.text = gym.name.uppercased()
    }

    // MARK: - CONSTRAINTS
    private func setupViews() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        addSubview(imageView)

        nameLabel.font = ._36MontserratBold
        nameLabel.textAlignment = .center
        nameLabel.numberOfLines = 0
        nameLabel.textColor = .white
        addSubview(nameLabel)
    }

    private func setupConstraints() {
        let horizontalPadding = 40
        let nameLabelBottomPadding = 136

        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        nameLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(horizontalPadding)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-nameLabelBottomPadding)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
