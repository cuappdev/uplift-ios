//
//  SportsFilterStartTimeCollectionViewCell.swift
//  Uplift
//
//  Created by Cameron Hamidi on 5/6/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import UIKit

class SportsFilterStartTimeCollectionViewCell: SportsFilterCollectionViewCell {

    private let startTimeTitleLabel = UILabel()
    private let startTimeLabel = UILabel()
    private let startTimeSlider = RangeSeekSlider(frame: .zero)

    var endTime = "10:00PM"
    var startTime = "6:00AM"
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        startTimeTitleLabel.sizeToFit()
        startTimeTitleLabel.font = ._12MontserratBold
        startTimeTitleLabel.textColor = .gray04
        startTimeTitleLabel.text = ClientStrings.Filter.startTime
        contentView.addSubview(startTimeTitleLabel)

        startTimeLabel.sizeToFit()
        startTimeLabel.font = ._12MontserratBold
        startTimeLabel.textColor = .gray04
        startTimeLabel.text = startTime + " - " + endTime
        contentView.addSubview(startTimeLabel)

        startTimeSlider.minValue = 0.0 //15 minute intervals
        startTimeSlider.maxValue = 960.0
        startTimeSlider.selectedMinValue = 0.0
        startTimeSlider.selectedMaxValue = 960.0
        startTimeSlider.enableStep = true
        startTimeSlider.delegate = self
        startTimeSlider.step = 15.0
        startTimeSlider.handleDiameter = 24.0
        startTimeSlider.selectedHandleDiameterMultiplier = 1.0
        startTimeSlider.lineHeight = 6.0
        startTimeSlider.hideLabels = true
        startTimeSlider.colorBetweenHandles = .primaryYellow
        startTimeSlider.handleColor = .white
        startTimeSlider.handleBorderWidth = 1.0
        startTimeSlider.handleBorderColor = .gray01
        startTimeSlider.handleShadowColor = .gray02
        startTimeSlider.handleShadowOffset = CGSize(width: 0, height: 2)
        startTimeSlider.handleShadowOpacity = 0.6
        startTimeSlider.handleShadowRadius = 1.0
        startTimeSlider.tintColor = .gray01
        contentView.addSubview(startTimeSlider)

        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupConstraints() {
        let labelTopOffset = 20
        let startTimeLabelTrailingOffset = -22
        let startTimeSliderHeight = 30
        let startTimeSliderLeadingTrailingOffset = 16
        let startTimeSlidertopOffset = 12
        let startTimeTitleLabelLeadingOffset = 16

        startTimeTitleLabel.snp.remakeConstraints { make in
            make.leading.equalToSuperview().offset(startTimeTitleLabelLeadingOffset)
            make.top.equalTo(contentView.snp.top).offset(labelTopOffset)
        }

        startTimeLabel.snp.remakeConstraints { make in
            make.trailing.equalToSuperview().offset(startTimeLabelTrailingOffset)
            make.top.equalTo(contentView.snp.top).offset(labelTopOffset)
        }

        startTimeSlider.snp.remakeConstraints { make in
            make.trailing.equalToSuperview().offset(-startTimeSliderLeadingTrailingOffset)
            make.leading.equalToSuperview().offset(startTimeSliderLeadingTrailingOffset)
            make.top.equalTo(startTimeLabel.snp.bottom).offset(startTimeSlidertopOffset)
            make.height.equalTo(startTimeSliderHeight)
        }
    }

}

extension SportsFilterStartTimeCollectionViewCell: RangeSeekSliderDelegate {

}
