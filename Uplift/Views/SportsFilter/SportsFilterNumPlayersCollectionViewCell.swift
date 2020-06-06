//
//  SportsFilterNumPlayersCollectionViewCell.swift
//  Uplift
//
//  Created by Cameron Hamidi on 5/16/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import SnapKit
import UIKit

class SportsFilterNumPlayersCollectionViewCell: SportsFilterCollectionViewCell, RangeSeekSliderDelegate {

    static let height: CGFloat = 103

    private let numPlayersLabel = UILabel()
    private let numPlayersSlider = RangeSeekSlider(frame: .zero)

    let maxPlayers = 10
    let minPlayers = 2

    override init(frame: CGRect) {
        super.init(frame: frame)

        titleLabel.text = ClientStrings.Filter.numPlayers

        numPlayersLabel.sizeToFit()
        numPlayersLabel.font = ._12MontserratBold
        numPlayersLabel.textColor = .gray04
        numPlayersLabel.text = "\(minPlayers) - \(maxPlayers)"
        contentView.addSubview(numPlayersLabel)

        numPlayersSlider.minValue = 2.0
        numPlayersSlider.maxValue = 10.0
        numPlayersSlider.selectedMinValue = 2.0
        numPlayersSlider.selectedMaxValue = 10.0
        numPlayersSlider.enableStep = true
        numPlayersSlider.delegate = self
        numPlayersSlider.step = 1.0
        numPlayersSlider.handleDiameter = 24.0
        numPlayersSlider.selectedHandleDiameterMultiplier = 1.0
        numPlayersSlider.lineHeight = 6.0
        numPlayersSlider.hideLabels = true
        numPlayersSlider.colorBetweenHandles = .primaryYellow
        numPlayersSlider.handleColor = .white
        numPlayersSlider.handleBorderWidth = 1.0
        numPlayersSlider.handleBorderColor = .gray01
        numPlayersSlider.handleShadowColor = .gray02
        numPlayersSlider.handleShadowOffset = CGSize(width: 0, height: 2)
        numPlayersSlider.handleShadowOpacity = 0.6
        numPlayersSlider.handleShadowRadius = 1.0
        numPlayersSlider.tintColor = .gray01
        contentView.addSubview(numPlayersSlider)

        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupConstraints() {
        let leadingOffset = 16
        let numPlayersLabelHeight = 16
        let numPlayersLabelTrailingOffset = -22
        let numPlayersSliderTopOffset = 12
        let numPlayersSliderTopOffsetHeight = 30

        numPlayersLabel.snp.remakeConstraints { make in
            make.trailing.equalToSuperview().offset(numPlayersLabelTrailingOffset)
            make.centerY.equalTo(titleLabel.snp.centerY)
        }

        numPlayersSlider.snp.remakeConstraints { make in
            make.trailing.equalToSuperview().offset(-leadingOffset)
            make.leading.equalToSuperview().offset(leadingOffset)
            make.top.equalTo(numPlayersLabel.snp.bottom).offset(numPlayersSliderTopOffset)
            make.height.equalTo(numPlayersSliderTopOffsetHeight)
        }
    }

}
