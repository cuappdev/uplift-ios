//
//  GymListItemCell.swift
//  Uplift
//
//  Created by Joseph Fulgieri on 3/7/18.
//  Copyright © 2018 Uplift. All rights reserved.
//

import SnapKit
import UIKit

class GymListItemCell: ListItemCollectionViewCell<FitnessCenter> {

    // MARK: - Public static vars
    static let identifier = Identifiers.gymsCell

    // MARK: - Private view vars
    private let shadowView = UIView()
    private let backgroundImage = UIImageView()
    private let gymCellFooter = GymCellFooter()

    override init(frame: CGRect) {
        super.init(frame: frame)

        // BORDER
        shadowView.layer.cornerRadius = 12
        shadowView.layer.backgroundColor = UIColor.primaryWhite.cgColor
        shadowView.layer.borderColor = UIColor.gray01.cgColor
        shadowView.layer.borderWidth = 1.0
        shadowView.layer.masksToBounds = true

        // SHADOWING
        contentView.layer.shadowColor = UIColor(red: 0.15, green: 0.15, blue: 0.37, alpha: 0.1).cgColor
        contentView.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        contentView.layer.shadowRadius = 12.0
        contentView.layer.shadowOpacity = 1.0


        setupViews()
        setupConstraints()
    }

    // MARK: - Public configure
    override func configure(for fitnessCenter: FitnessCenter) {
        super.configure(for: fitnessCenter)

        gymCellFooter.configure(for: fitnessCenter)
        backgroundImage.kf.setImage(with: fitnessCenter.imageUrl)
    }

    private func setupViews() {
        contentView.addSubview(shadowView)

        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.clipsToBounds = true
        shadowView.addSubview(backgroundImage)

        shadowView.addSubview(gymCellFooter)
    }

    private func setupConstraints() {
        let footerHeight = 75

        shadowView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        backgroundImage.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalTo(gymCellFooter.snp.top)
        }

        gymCellFooter.snp.updateConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(footerHeight)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
