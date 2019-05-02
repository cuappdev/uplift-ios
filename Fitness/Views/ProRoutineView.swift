//
//  ProRoutineView.swift
//  Fitness
//
//  Created by Cameron Hamidi on 3/21/19.
//  Copyright © 2019 Keivan Shahida. All rights reserved.
//

import UIKit

class ProRoutineView: UIView {
    enum ConstraintConstants {
        static let outerSpacing = 16
        static let textViewSpacing = 13
    }
    
    private var addButton: UIButton!
    private var containerView: UIView!
    private var routine: ProRoutine!
    private var routineTypeImage: UIImageView!
    private var routineTypeLabel: UILabel!
    private var stepsTextView: UITextView!
    private var titleLabel: UILabel!
    
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
        // Commenting out the add button until more functionality to save and display favourited routines is implemented
        
        stepsTextView = UITextView()
        stepsTextView.textColor = UIColor.fitnessBlack
        stepsTextView.font = ._14MontserratLight
        stepsTextView.isScrollEnabled = false
        stepsTextView.textAlignment = .left
        stepsTextView.isSelectable = false
        stepsTextView.text = routine.text
        stepsTextView.sizeToFit()
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 5
        let attributes = [NSAttributedString.Key.paragraphStyle : style, NSAttributedString.Key.font : UIFont._14MontserratLight]
        stepsTextView.attributedText = NSAttributedString(string: routine.text, attributes: attributes)
        
        self.addSubview(stepsTextView)
        
        addRoundedCorners(radius: 5)
        applySketchShadow(color: UIColor.fitnessGreen, alpha: 0.03, y: 11, blur: 14, spread: -10)
        
    }
    
    func addRoundedCorners(radius: CGFloat) {
        layer.cornerRadius = radius
        layer.masksToBounds = false
        layer.borderColor = UIColor.fitnessMutedGreen.cgColor
        layer.borderWidth = 1
    }
    
    func applySketchShadow(color: UIColor = .black, alpha: Float = 0.5, x: CGFloat = 0, y: CGFloat = 2,
                           blur: CGFloat = 4, spread: CGFloat = 0)
    {
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = alpha
        layer.shadowOffset = CGSize(width: x, height: y)
        layer.shadowRadius = blur / 2.0
        if spread == 0 {
            layer.shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            layer.shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
    
    override func updateConstraints() {
        let iconRoutineLabelSpacing = 8
        let iconSize = 15
        let titleIconSpacing = 3
        
        titleLabel.snp.makeConstraints{ make in
            make.leading.equalToSuperview().offset(ConstraintConstants.outerSpacing)
            make.top.equalToSuperview().offset(ConstraintConstants.outerSpacing)
            make.trailing.equalToSuperview().offset(-ConstraintConstants.outerSpacing)
        }
        
        routineTypeImage.snp.makeConstraints{ make in
            make.height.width.equalTo(iconSize)
            make.top.equalTo(titleLabel.snp.bottom).offset(titleIconSpacing)
            make.leading.equalTo(titleLabel)
        }
        
        routineTypeLabel.snp.makeConstraints{ make in
            make.leading.equalTo(routineTypeImage.snp.trailing).offset(iconRoutineLabelSpacing)
            make.centerY.equalTo(routineTypeImage)
        }
        
        // Temporarily commenting out this code until we have a way to display favourited Routines and the addButton is added back in
//        addButton.snp.makeConstraints{ make in
//            make.height.width.equalTo(24)
//            make.trailing.equalToSuperview().offset(-16)
//            make.centerY.equalTo(titleLabel.snp.centerY)
//        }
        
        stepsTextView.snp.makeConstraints{ make in
            make.leading.equalToSuperview().offset(ConstraintConstants.textViewSpacing)
            make.trailing.equalToSuperview().offset(-ConstraintConstants.textViewSpacing)
            make.top.equalTo(routineTypeImage.snp.bottom).offset(ConstraintConstants.outerSpacing)
            make.bottom.equalToSuperview().offset(-ConstraintConstants.outerSpacing)
        }
        
        super.updateConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
