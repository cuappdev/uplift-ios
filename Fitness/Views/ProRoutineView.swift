//
//  ProRoutineView.swift
//  Fitness
//
//  Created by Cameron Hamidi on 3/21/19.
//  Copyright © 2019 Keivan Shahida. All rights reserved.
//

import UIKit

class ProRoutineView: UIView {

    var routine: ProRoutine!
    
    var containerView: UIView!
//    var headerView: UIView!
    var titleLabel: UILabel!
    var routineTypeImage: UIImageView!
    var routineTypeLabel: UILabel!
    var addButton: UIButton!
    var stepsTextView: UITextView!
    
    init(routine: ProRoutine) {
        super.init(frame: .zero)
        
        self.backgroundColor = .white
        
        titleLabel = UILabel()
        titleLabel.textColor = .black
        titleLabel.font = ._16MontserratMedium
        titleLabel.textAlignment = .left
        titleLabel.text = routine.title
        titleLabel.sizeToFit()
        self.addSubview(titleLabel)
        
        routineTypeImage = UIImageView()
        routineTypeImage.contentMode = .scaleAspectFit
        routineTypeImage.clipsToBounds = true
        self.addSubview(routineTypeImage)
        
        routineTypeLabel = UILabel()
        routineTypeLabel.textColor = UIColor.colorFromCode(0x555555)
        routineTypeLabel.font = ._12MontserratRegular
        routineTypeLabel.textAlignment = .center
        routineTypeLabel.sizeToFit()
        self.addSubview(routineTypeLabel)
        
        switch routine.routineType {
        case .cardio:
            routineTypeImage.image = #imageLiteral(resourceName: "small cardio icon.png")
            routineTypeLabel.text = "Cardio"
        case .mindfullness:
            routineTypeImage.image = #imageLiteral(resourceName: "smaller mindfulness icon.png")
            routineTypeLabel.text = "Mindfulness"
        case .strength:
            routineTypeImage.image = #imageLiteral(resourceName: "small strength icon.png")
            routineTypeLabel.text = "Strength"
        case .other:
            routineTypeImage.image = #imageLiteral(resourceName: "smaller mindfulness icon.png")
            routineTypeLabel.text = "Other"
        }
        
        addButton = UIButton()
        addButton.setBackgroundImage(#imageLiteral(resourceName: "add habit.png"), for: .normal)
//        self.addSubview(addButton)
        //Commenting out the add button until more functionality to save and display favourited routines is implemented
        
        stepsTextView = UITextView()
        stepsTextView.textColor = UIColor.colorFromCode(0x222222)
        stepsTextView.font = ._14MontserratRegular
        stepsTextView.isScrollEnabled = false
        stepsTextView.textAlignment = .left
        stepsTextView.isSelectable = false
        stepsTextView.text = routine.text
        stepsTextView.sizeToFit()
        self.addSubview(stepsTextView)
        
    }
    
    override func updateConstraints() {
//        headerView.snp.makeConstraints{make in
//            make.leading.equalToSuperview().offset(10)
//            make.trailing.equalToSuperview().offset(-10)
//            make.top.equalToSuperview().offset(3)
//        }
        
//        containerView.snp.makeConstraints{make in
//            make.leading.trailing.top.bottom.equalToSuperview()
//        }
        
        titleLabel.snp.makeConstraints{make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(16)
//            make.trailing.equalTo(addButton.snp.leading).offset(-16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        routineTypeImage.snp.makeConstraints{make in
            make.height.width.equalTo(15)
            make.top.equalTo(titleLabel.snp.bottom).offset(3)
            make.leading.equalTo(titleLabel)
        }
        
        routineTypeLabel.snp.makeConstraints{make in
            make.leading.equalTo(routineTypeImage.snp.trailing).offset(8)
            make.centerY.equalTo(routineTypeImage)
        }
        
//        addButton.snp.makeConstraints{make in
//            make.height.width.equalTo(24)
//            make.trailing.equalToSuperview().offset(-16)
//            make.centerY.equalTo(titleLabel.snp.centerY)
//        }
        
        stepsTextView.snp.makeConstraints{make in
            make.leading.equalToSuperview().offset(13)
            make.trailing.equalToSuperview().offset(-13)
            make.top.equalTo(routineTypeLabel.snp.bottom).offset(10)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        super.updateConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
