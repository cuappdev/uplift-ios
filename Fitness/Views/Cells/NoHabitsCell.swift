//
//  NoHabitsCell.swift
//  Fitness
//
//  Created by Joseph Fulgieri on 4/24/19.
//  Copyright © 2019 Uplift. All rights reserved.
//

import SnapKit
import UIKit

class NoHabitsCell: UICollectionViewCell {
    
    // MARK: - INITIALIZATION
    static let identifier = Identifiers.noHabitsCell
    
    private var addHabitWidget: UIImageView!
    private var backgroundImage: UIImageView!
    private var titleLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundImage = UIImageView()
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        backgroundImage.image = UIImage(named: "selection-area")
        backgroundImage.clipsToBounds = false
        contentView.addSubview(backgroundImage)
        
        addHabitWidget = UIImageView()
        addHabitWidget.image = UIImage(named: "add-habit")
        contentView.addSubview(addHabitWidget)
        
        titleLabel = UILabel()
        titleLabel.text = "The first step is the hardest."
        titleLabel.textAlignment = .left
        titleLabel.clipsToBounds = false
        titleLabel.font = ._16MontserratMedium
        titleLabel.textColor = .fitnessMediumGrey
        contentView.addSubview(titleLabel)
        
        setupConstraints()
    }
    
    // MARK: - CONSTRAINTS
    func setupConstraints() {
        backgroundImage.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(21)
            make.trailing.equalToSuperview().offset(-21)
        }
        
        addHabitWidget.snp.makeConstraints { make in
            make.width.height.equalTo(20)
            make.leading.equalTo(backgroundImage).offset(15)
            make.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(addHabitWidget.snp.trailing).offset(8).priority(.high)
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(22)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
