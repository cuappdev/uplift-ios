//
//  CapacityView.swift
//  Uplift
//
//  Created by alden lamp on 10/22/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

// TODO: - Merge with Elvis's capacity View

import Foundation
import UIKit

class CapacityView: UIView {

    let centerLabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = ._20MontserratBold
        return label
    }()

    private let trackLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = UIColor.gray01.cgColor
        layer.strokeEnd = 1.0
        return layer
    }()

    private let progressLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.clear.cgColor
        layer.lineCap = .round
        return layer
    }()

    init (width: CGFloat, lineWidth: CGFloat) {
        super.init(frame: .zero)

        let center = CGPoint(x: width/2, y: width/2)
        let radius = width/2 - lineWidth
        let circularPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: CGFloat(-0.5 * .pi), endAngle: CGFloat(1.5 * .pi), clockwise: true)

        trackLayer.path = circularPath.cgPath
        trackLayer.lineWidth = lineWidth

        progressLayer.path = circularPath.cgPath
        progressLayer.lineWidth = lineWidth

        layer.addSublayer(trackLayer)
        layer.addSublayer(progressLayer)
        self.addSubview(centerLabel)
        setupConstraints()
    }

    func setupConstraints() {
        centerLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }

    func configure(percent: Double, progressColor: UIColor) {
        progressLayer.strokeEnd = percent
        progressLayer.strokeColor = progressColor.cgColor
        centerLabel.text = String.getFromPercent(value: percent)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
