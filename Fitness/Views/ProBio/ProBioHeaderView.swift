//
//  ProBioHeaderView.swift
//  Fitness
//
//  Created by Yana Sang on 5/19/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import UIKit

class ProBioHeaderView: UICollectionReusableView {

    // MARK: - Private view vars
    private let imageView = UIImageView()
    private let nameLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
        setupConstraints()
    }

    // MARK: - Public configure
    func configure(for pro: ProBio) {
        if let profilePic = pro.profilePic {
            imageView.image = profilePic
        }
        nameLabel.text = pro.name.uppercased()
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
        let horizontalPadding = 15
        let nameLabelBottomPadding = 64

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
