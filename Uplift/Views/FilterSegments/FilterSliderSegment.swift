//
//  LabeledRangeSeekSlider.swift
//  Uplift
//
//  Created by Artesia Ko on 3/11/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import SnapKit
import UIKit

class FilterSliderSegment: UIView, RangeSeekSliderDelegate {

    var label: UILabel!
    var slider: RangeSeekSlider!
    var titleLabel: UILabel!
    var endRange = ""
    var startRange = ""
    var divider: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel = UILabel()
        titleLabel.sizeToFit()
        titleLabel.font = ._12MontserratBold
        titleLabel.textColor = .gray04
        titleLabel.text = ClientStrings.Filter.startTime
        self.addSubview(titleLabel)

        label = UILabel()
        label.sizeToFit()
        label.font = ._12MontserratBold
        label.textColor = .gray04
        label.text = startRange + " - " + endRange
        self.addSubview(label)

        slider = RangeSeekSlider(frame: .zero)
        slider.minValue = 0.0 //15 minute intervals
        slider.maxValue = 960.0
        slider.selectedMinValue = 0.0
        slider.selectedMaxValue = 960.0
        slider.enableStep = true
        slider.delegate = self
        slider.step = 15.0
        slider.handleDiameter = 24.0
        slider.selectedHandleDiameterMultiplier = 1.0
        slider.lineHeight = 6.0
        slider.hideLabels = true

        slider.colorBetweenHandles = .primaryYellow
        slider.handleColor = .white
        slider.handleBorderWidth = 1.0
        slider.handleBorderColor = .gray01
        slider.handleShadowColor = .gray02
        slider.handleShadowOffset = CGSize(width: 0, height: 2)
        slider.handleShadowOpacity = 0.6
        slider.handleShadowRadius = 1.0
        slider.tintColor = .gray01
        self.addSubview(slider)

        divider = UIView()
        divider.backgroundColor = .gray01
        self.addSubview(divider)
        
    }
    
    // MARK: - CONSTRAINTS
    func setupConstraints() {

        titleLabel.snp.remakeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(20)
        }

        label.snp.remakeConstraints { make in
            make.trailing.equalToSuperview().offset(-22)
            make.centerY.equalTo(titleLabel)
        }

        slider.snp.remakeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(label.snp.bottom).offset(12)
            make.height.equalTo(30)
        }

        divider.snp.remakeConstraints { make in
            make.width.centerX.equalToSuperview()
            make.top.equalTo(slider.snp.bottom).offset(90)
            make.height.equalTo(1)
        }
    }
    
    func getSelectedMinValue() -> CGFloat {
        return slider.selectedMinValue
    }
    
    func getSelectedMaxValue() -> CGFloat {
        return slider.selectedMaxValue
    }
    
    func setLabelText(text: String) {
        label.text = text
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
