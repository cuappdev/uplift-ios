//
//  CircularProgressView.swift
//  Uplift
//
//  Created by elvis on 10/18/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class CircularProgressView: UIView {

    private var progressLayer = CAShapeLayer()
    private var trackLayer = CAShapeLayer()

    private var progressColor: UIColor!
    private var width: CGFloat!

    init(progressColor: UIColor, width: CGFloat) {
        super.init(frame: .zero)

        self.progressColor = progressColor
        self.width = width

        createCircularPath()
    }

    private func createCircularPath() {
        self.layer.cornerRadius = width!/2
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: width/2, y: width/2) , radius: (width - 1.5)/2, startAngle: CGFloat(-0.5 * .pi), endAngle: CGFloat(2.0 * .pi), clockwise: true)

        trackLayer.path = circularPath.cgPath
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.strokeColor = UIColor.gray.cgColor
        trackLayer.lineWidth = 5
        trackLayer.strokeEnd = 1.0
        layer.addSublayer(trackLayer)

        progressLayer.path = circularPath.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = progressColor?.cgColor
        progressLayer.lineWidth = 5
        progressLayer.strokeEnd = 0.5
        layer.addSublayer(progressLayer)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
