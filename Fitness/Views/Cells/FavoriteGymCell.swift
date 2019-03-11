//
//  FavoriteGymCell.swift
//  Fitness
//
//  Created by Phillip OReggio on 3/5/19.
//  Copyright © 2019 Keivan Shahida. All rights reserved.
//

import UIKit

class FavoriteGymCell: UITableViewCell {
    
    
    // MARK: Initialization
    var gymLabel: UILabel!
    var checkedSymbol: UIView!
    
    // Padding
    let leftPadding: CGFloat = 15
    let rightPadding: CGFloat = 16
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.contentView.backgroundColor = .white
        
        // SHADOWING
        contentView.layer.shadowColor = UIColor.fitnessBlack.cgColor
        contentView.layer.shadowOffset = CGSize(width: 0.0, height: 15.0)
        contentView.layer.shadowRadius = 5.0
        contentView.layer.shadowOpacity = 0.1
        contentView.layer.masksToBounds = false
        let shadowFrame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 9, right: -3))
        contentView.layer.shadowPath = UIBezierPath(roundedRect: shadowFrame, cornerRadius: 5).cgPath
        // Corner Radius
        contentView.layer.cornerRadius = 6
        
        gymLabel = UILabel()
        gymLabel.text = "A Gym"
        gymLabel.font = ._16MontserratMedium
        gymLabel.textColor = .fitnessMediumGrey
        contentView.addSubview(gymLabel)
        
        checkedSymbol = UIView()
        checkedSymbol.tintColor = .fitnessWhite
        checkedSymbol.layer.borderColor = UIColor.fitnessMediumGrey.cgColor
        checkedSymbol.layer.borderWidth = 1
        checkedSymbol.layer.cornerRadius = 25
        contentView.addSubview(checkedSymbol)
        
        setUpConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(with gymName: String) {
        gymLabel.text = gymName
    }
    
    func setUpConstraints() {
        gymLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().inset(leftPadding)
            make.centerY.equalToSuperview()
        }
        
        checkedSymbol.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().inset(rightPadding)
            make.centerY.equalToSuperview()
        }
    }
    
    func toggleSelectedView(selected: Bool) {
        if selected {
            gymLabel.textColor = .fitnessBlack
            checkedSymbol.tintColor = .fitnessGreen
            
        } else {
            
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
