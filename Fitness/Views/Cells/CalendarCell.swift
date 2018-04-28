//
//  CalendarCell.swift
//  Fitness
//
//  Created by Keivan Shahida on 3/26/18.
//  Copyright © 2018 Keivan Shahida. All rights reserved.
//

import UIKit

class CalendarCell: UICollectionViewCell {
    
    var dateLabel: UILabel!
    var dayOfWeekLabel: UILabel!
    var shapeLayer: CAShapeLayer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: 27,y: 74), radius: CGFloat(12), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
        
        shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        layer.addSublayer(shapeLayer)
        
        dateLabel = UILabel()
        dateLabel.text = "15"
        dateLabel.font = ._12MontserratRegular
        dateLabel.textAlignment = .center
        dateLabel.textColor = .fitnessBlack
        dateLabel.sizeToFit()
        addSubview(dateLabel)
        
        dayOfWeekLabel = UILabel()
        dayOfWeekLabel.text = "Th"
        dayOfWeekLabel.font = ._12MontserratRegular
        dayOfWeekLabel.textAlignment = .center
        dayOfWeekLabel.textColor = .fitnessDarkGrey
        dayOfWeekLabel.sizeToFit()
        addSubview(dayOfWeekLabel)
        
        setConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setConstraints(){
        
        dateLabel.snp.makeConstraints{ make in
            make.centerX.equalToSuperview()
            make.top.equalTo(dayOfWeekLabel.snp.bottom).offset(12)
        }
        
        dayOfWeekLabel.snp.makeConstraints{ make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(40)
        }
    }
}
