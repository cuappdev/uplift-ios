//
//  NoHabitsCell.swift
//  Uplift
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
        backgroundImage.image = UIImage(named: "selection-area")
        backgroundImage.clipsToBounds = false
        contentView.addSubview(backgroundImage)
        
        addHabitWidget = UIImageView()
        addHabitWidget.image = UIImage(named: ImageNames.lightAdd)
        contentView.addSubview(addHabitWidget)
        
        titleLabel = UILabel()
        titleLabel.text = "The first step is the hardest."
        titleLabel.textAlignment = .left
        titleLabel.clipsToBounds = false
        titleLabel.font = ._16MontserratMedium
        titleLabel.textColor = .upliftMediumGrey
        contentView.addSubview(titleLabel)
        
        setupConstraints()
    }
    
    // MARK: - CONSTRAINTS
    func setupConstraints() {
        let addHabitWidgetDiameter = 20
        let backgroundInset = 21
        let titleLabelHeight = 22
        
        backgroundImage.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().inset(backgroundInset)
            make.trailing.equalToSuperview().inset(backgroundInset).priority(.high)
        }
        
        addHabitWidget.snp.makeConstraints { make in
            make.width.height.equalTo(addHabitWidgetDiameter)
            make.leading.equalTo(backgroundImage).offset(15)
            make.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(addHabitWidget.snp.trailing).offset(8).priority(.high)
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(titleLabelHeight)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
