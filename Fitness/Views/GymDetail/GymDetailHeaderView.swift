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
    private let closedLabel = UILabel()
    private let imageView = UIImageView()
    private let nameLabel = UILabel()

    // MARK: - Private data vars
    private var isOpen: Bool = true

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
        setupConstraints()
    }

    // MARK: - Public configure
    func configure(for gym: Gym) {
        self.isOpen = gym.isOpen
        imageView.kf.setImage(with: gym.imageURL)
        nameLabel.text = gym.name.uppercased()
        
        setupConstraints()
    }

    // MARK: - CONSTRAINTS
    private func setupViews() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        addSubview(imageView)

        closedLabel.font = ._16MontserratSemiBold
        closedLabel.textColor = .white
        closedLabel.textAlignment = .center
        closedLabel.backgroundColor = .fitnessBlack
        closedLabel.text = "CLOSED"

        nameLabel.font = ._36MontserratBold
        nameLabel.textAlignment = .center
        nameLabel.numberOfLines = 0
        nameLabel.textColor = .white
        addSubview(nameLabel)
    }

    private func setupConstraints() {
        let closedLabelHeight = 60
        let horizontalPadding = 40

        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        nameLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(horizontalPadding)
            make.center.equalToSuperview()
        }

        if !isOpen {
            addSubview(closedLabel)

            closedLabel.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview()
                make.height.equalTo(closedLabelHeight)
                make.bottom.equalTo(imageView)
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
