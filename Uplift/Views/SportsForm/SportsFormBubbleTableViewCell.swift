//
//  SportsFormBubbleTableViewCell.swift
//  Uplift
//
//  Created by Artesia Ko on 5/24/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import UIKit

class SportsFormBubbleTableViewCell: UITableViewCell {
    
    private let bubbleBorder = UIView()
    private let bubbleFill = UIView()
    private let label = UILabel()

    private let bubbleBorderSize = 18
    private let bubbleFillSize = 14
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.contentView.backgroundColor = .white
        
        bubbleBorder.backgroundColor = .white
        bubbleBorder.layer.borderColor = UIColor.primaryBlack.cgColor
        bubbleBorder.layer.cornerRadius = CGFloat(bubbleBorderSize / 2)
        bubbleBorder.layer.borderWidth = 0.3
        bubbleBorder.layer.masksToBounds = true
        contentView.addSubview(bubbleBorder)
        
        bubbleFill.backgroundColor = .primaryYellow
        bubbleFill.layer.cornerRadius = CGFloat(bubbleFillSize / 2)
        bubbleFill.layer.masksToBounds = true
        contentView.addSubview(bubbleFill)
        
        label.font = ._14MontserratLight
        label.textColor = .primaryBlack
        contentView.addSubview(label)

        setupConstraints()
    }
    
    func setupConstraints() {
        let bubbleLabelPadding = 18
        let horizontalPadding = 24
        
        bubbleBorder.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(horizontalPadding)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(bubbleBorderSize)
        }
        
        bubbleFill.snp.makeConstraints { make in
            make.centerY.centerX.equalTo(bubbleBorder)
            make.height.width.equalTo(bubbleFillSize)
        }
        
        label.snp.makeConstraints { make in
            make.leading.equalTo(bubbleBorder.snp.trailing).offset(bubbleLabelPadding)
            make.trailing.equalToSuperview().inset(horizontalPadding)
            make.centerY.equalTo(bubbleBorder)
        }
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(for item: BubbleItem) {
        label.text = item.title
        bubbleFill.isHidden = !item.isSelected
    }

}
