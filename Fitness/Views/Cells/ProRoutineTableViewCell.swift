//
//  ProRoutineTableViewCell.swift
//  Fitness
//
//  Created by Cameron Hamidi on 3/14/19.
//  Copyright © 2019 Keivan Shahida. All rights reserved.
//

import UIKit
import SnapKit

class ProRoutineTableViewCell: UITableViewCell {
    static let identifier = Identifiers.proRoutineCell
    
    var routine: ProRoutineType!
    
    var shadowView: UIView!
    var headerView: UIView!
    var titleLabel: UILabel!
    var routineTypeImage: UIImageView!
    var routineTypeLabel: UILabel!
    var addButton: UIButton!
    var stepsTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        headerView = UIView()
        headerView.backgroundColor = .white
        headerView.layer.cornerRadius = 6
        headerView.layer.shadowColor = UIColor.black.cgColor
        headerView.layer.shadowOpacity = 0.3
        headerView.layer.shadowRadius = 6.0
        headerView.layer.shadowOffset = CGSize(width: 0, height: 2)

        contentView.addSubview(headerView)
        
        titleLabel = UILabel()
        titleLabel.textColor = .black
        titleLabel.font = ._14MontserratBold
        titleLabel.textAlignment = .left
        titleLabel.sizeToFit()
        headerView.addSubview(titleLabel)
        
        routineTypeImage = UIImageView()
        routineTypeImage.contentMode = .scaleAspectFit
        routineTypeImage.clipsToBounds = true
        headerView.addSubview(routineTypeImage)
        
        routineTypeLabel = UILabel()
        routineTypeLabel.textColor = UIColor.colorFromCode(0xBABABA)
        routineTypeLabel.font = ._11MontserratRegular
        routineTypeLabel.textAlignment = .center
        routineTypeLabel.sizeToFit()
        headerView.addSubview(routineTypeLabel)
        
        addButton = UIButton()
        addButton.setBackgroundImage(#imageLiteral(resourceName: "Oval 2.png"), for: .normal)
        headerView.addSubview(addButton)
        
        stepsTextView = UITextView()
        stepsTextView.textColor = UIColor.colorFromCode(0x222222)
        stepsTextView.font = ._12MontserratRegular
        stepsTextView.sizeToFit()
        stepsTextView.isScrollEnabled = false
        stepsTextView.textAlignment = .left
        stepsTextView.isSelectable = false
        contentView.addSubview(stepsTextView)
    }
    
    override func updateConstraints() {
        headerView.snp.makeConstraints{make in
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.top.equalToSuperview().offset(3)
        }
        
        titleLabel.snp.makeConstraints{make in
            make.leading.equalToSuperview().offset(13)
            make.top.equalToSuperview().offset(14)
            make.trailing.equalToSuperview().offset(-14)
        }
        
        routineTypeImage.snp.makeConstraints{make in
            make.height.width.equalTo(10)
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.leading.equalTo(titleLabel)
        }
        
        routineTypeLabel.snp.makeConstraints{make in
            make.leading.equalTo(routineTypeImage.snp.trailing).offset(5)
            make.centerY.equalTo(routineTypeImage)
            make.bottom.equalToSuperview().offset(-15)
        }
        
        addButton.snp.makeConstraints{make in
            make.height.width.equalTo(24)
            make.trailing.equalToSuperview().offset(-13)
            make.centerY.equalToSuperview()
        }
        
        stepsTextView.snp.makeConstraints{make in
            make.leading.equalToSuperview().offset(13)
            make.trailing.equalToSuperview().offset(-13)
            make.top.equalTo(headerView.snp.bottom).offset(17)
            make.bottom.equalToSuperview()
        }
        
        super.updateConstraints()
    }
    
    func configure(for routine: ProRoutine) {
        titleLabel.text = routine.title
        switch routine.routineType {
        case .cardio:
            routineTypeImage.image = #imageLiteral(resourceName: "Oval.png")
            routineTypeLabel.text = "Cardio"
        case .mindfullness:
            routineTypeImage.image = #imageLiteral(resourceName: "Oval.png")
            routineTypeLabel.text = "Mindfulness"
        case .strength:
            routineTypeImage.image = #imageLiteral(resourceName: "Oval.png")
            routineTypeLabel.text = "Strength"
        case .other:
            routineTypeImage.image = #imageLiteral(resourceName: "Oval.png")
            routineTypeLabel.text = "Other"
        }
        var stepsText = ""
//        for i in 1...routine.steps.count {
//            stepsText += "\(i). \(routine.steps[i-1])\n"
//        }
        stepsTextView.text = stepsText
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
