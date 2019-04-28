//
//  AllProRoutinesView.swift
//  Fitness
//
//  Created by Cameron Hamidi on 3/21/19.
//  Copyright © 2019 Keivan Shahida. All rights reserved.
//

import UIKit

extension UIView {
    func addRoundedCornersAndShadows(radius: CGFloat) {
        layer.cornerRadius = radius
        layer.masksToBounds = false
    }
}

extension CALayer {
    func applySketchShadow(color: UIColor = .black, alpha: Float = 0.5, x: CGFloat = 0, y: CGFloat = 2, blur: CGFloat = 4, spread: CGFloat = 0)
    {
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
        if spread == 0 {
            shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
}

class AllProRoutinesView: UIView {

    var routines: [ProRoutine]!
    var routineViews: [ProRoutineView] = []
    
    init(routines: [ProRoutine]) {
        super.init(frame: .zero)
        
        self.routines = routines
        for routine in routines {
            var newRoutineView = ProRoutineView(routine: routine)
            newRoutineView.addRoundedCornersAndShadows(radius: 5)
            newRoutineView.layer.applySketchShadow()
            routineViews.append(newRoutineView)
            self.addSubview(newRoutineView)
        }
        
        if routineViews.count > 0{
            setupConstraints()
        }
    }
    
    func setupConstraints() {
        var firstView = routineViews[0]
        firstView.snp.makeConstraints{make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        var previousView = firstView
        var lastView: ProRoutineView!
        if routineViews.count == 1 {
            return
        } else {
            for i in 1..<routineViews.count - 1 {
                var curView = routineViews[i]
                curView.snp.makeConstraints{make in
                    make.leading.trailing.equalToSuperview()
//                    make.leading.equalToSuperview().offset(34)
//                    make.trailing.equalToSuperview().offset(-34)
                    make.top.equalTo(previousView.snp.bottom).offset(16)
                }
                previousView = curView
            }
            lastView = routineViews.last
        }
        
        lastView.snp.makeConstraints{make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(previousView.snp.bottom).offset(16)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
