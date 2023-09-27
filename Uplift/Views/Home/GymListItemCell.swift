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
    private let backgroundImage = UIImageView()
    private let gymCellFooter = GymCellFooter()

    override init(frame: CGRect) {
        super.init(frame: frame)

        // BORDER
        contentView.layer.cornerRadius = 5
        contentView.layer.backgroundColor = UIColor.primaryWhite.cgColor
        contentView.layer.borderColor = UIColor.gray01.cgColor
        contentView.layer.borderWidth = 1.0

        // SHADOWING
        contentView.layer.shadowColor = UIColor(red: 0.15, green: 0.15, blue: 0.37, alpha: 0.1).cgColor
        contentView.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        contentView.layer.shadowRadius = 10.0
        contentView.layer.shadowOpacity = 1.0
        contentView.layer.masksToBounds = false
        contentView.clipsToBounds = true

        setupViews()
        setupConstraints()
    }

    // MARK: - Public configure
    override func configure(for fitnessCenter: FitnessCenter) {
        super.configure(for: fitnessCenter)

        gymCellFooter.configure(for: fitnessCenter)
        backgroundImage.kf.setImage(with: fitnessCenter.imageUrl)
        print("fitnessCenterImage: \(fitnessCenter.imageUrl)")
    }

    private func setupViews() {
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.clipsToBounds = true
        contentView.addSubview(backgroundImage)

        contentView.addSubview(gymCellFooter)
    }

    private func setupConstraints() {
        let footerHeight = 75

        backgroundImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
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
