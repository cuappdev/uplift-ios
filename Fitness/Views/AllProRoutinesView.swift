//
//  AllProRoutinesView.swift
//  Fitness
//
//  Created by Cameron Hamidi on 3/21/19.
//  Copyright © 2019 Keivan Shahida. All rights reserved.
//

import UIKit

class AllProRoutinesView: UIView {

    let interViewSpacing = 16
    var routines: [ProRoutine]!
    var routineViews: [ProRoutineView] = []
    
    init(routines: [ProRoutine]) {
        super.init(frame: .zero)
        
        self.routines = routines
        routines.forEach { routine in
            var newRoutineView = ProRoutineView(routine: routine)
            routineViews.append(newRoutineView)
            self.addSubview(newRoutineView)
        }
        
        if routineViews.count > 0 {
            setupConstraints()
        }
    }
    
    func setupConstraints() {
        let firstView = routineViews[0]
        firstView.snp.makeConstraints{ make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        var previousView = firstView
        var lastView: ProRoutineView!
        if routineViews.count != 1 {
            for i in 1..<routineViews.count - 1 { // Looping from 1 instead of 0 here because by this point constraints are already set for the first routineView
                let curView = routineViews[i]
                curView.snp.makeConstraints{ make in
                    make.leading.trailing.equalToSuperview()
                    make.top.equalTo(previousView.snp.bottom).offset(interViewSpacing)
                }
                previousView = curView
            }
            lastView = routineViews.last
            lastView.snp.makeConstraints{ make in
                make.leading.trailing.bottom.equalToSuperview()
                make.top.equalTo(previousView.snp.bottom).offset(interViewSpacing)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
