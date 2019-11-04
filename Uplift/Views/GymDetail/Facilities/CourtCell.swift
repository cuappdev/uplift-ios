//
//  CourtCell.swift
//  Uplift
//
//  Created by Phillip OReggio on 11/3/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import UIKit

class CourtCell: UICollectionViewCell {

    private let nameLabel = UILabel()
    private let courtImageView = UIImageView()
    private let infoLabel = UILabel()

    private let sportAttributes: [NSAttributedString.Key: Any]
    private let timeAttributes: [NSAttributedString.Key: Any]

    override init(frame: CGRect) {
        // Paragraph Styles
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 4
        style.alignment = .center
        sportAttributes = [
            .font: UIFont._14MontserratBold as Any,
            .paragraphStyle: style,
            .foregroundColor: UIColor.primaryBlack
        ]
        timeAttributes = [
            .font: UIFont._12MontserratMedium as Any,
            .paragraphStyle: style,
            .foregroundColor: UIColor.primaryBlack
        ]
        super.init(frame: frame)

        // Views
        nameLabel.font = ._14MontserratSemiBold
        courtImageView.image = UIImage(named: "testImage")
        addSubview(nameLabel)
        addSubview(courtImageView)
        addSubview(infoLabel)

        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        let imageOffset = 9
        let imageSize = CGSize(width: 124, height: 164)

        nameLabel.snp.makeConstraints { make in
            make.top.centerX.equalToSuperview()
        }

        courtImageView.snp.makeConstraints { make in
            make.size.equalTo(imageSize)
            make.top.equalTo(nameLabel).offset(imageOffset)
        }

        infoLabel.snp.makeConstraints { make in
            make.center.equalTo(courtImageView)
        }
    }

    func configure(name: String, sport: String, time: String) {
        nameLabel.text = name
        let text = NSMutableAttributedString(string: sport, attributes: sportAttributes)
        text.append(NSMutableAttributedString(string: time, attributes: timeAttributes))
        infoLabel.attributedText = text
    }
}
