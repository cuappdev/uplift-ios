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
    var cellBackground: UIView!
    var gymLabel: UILabel!
    var checkBackground: UIView!
    var checkImage: UIImageView!
    
    // Whether it is in a selected state
    var isOn = false
    
    // Padding and Sizing
    let checkSize: CGFloat = 24
    let checkBorderWidth: CGFloat = 1
    let leftPadding: CGFloat = 15
    let rightPadding: CGFloat = 16
    
    // Reuse Identfier
    static let reuseIdentifier = "gymsTableView"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.contentView.backgroundColor = .white
        
        cellBackground = UIView()
        cellBackground.backgroundColor =  .fitnessWhite
        cellBackground.layer.cornerRadius = 6
        cellBackground.layer.borderWidth = checkBorderWidth
        cellBackground.layer.borderColor = UIColor.fitnessLightGrey.cgColor
        // Shadow
        cellBackground.layer.shadowOpacity = 0.125
        cellBackground.layer.shadowRadius = 6
        cellBackground.layer.shadowOffset = CGSize(width: 1, height: 3)
        
        contentView.addSubview(cellBackground)
        
        gymLabel = UILabel()
        gymLabel.text = "A Gym"
        gymLabel.font = ._16MontserratMedium
        gymLabel.textColor = .fitnessMediumGrey
        cellBackground.addSubview(gymLabel)
        
        checkBackground = UIView()
        checkBackground.tintColor = .fitnessWhite
        checkBackground.layer.borderColor = UIColor.fitnessMediumGrey.cgColor
        checkBackground.layer.borderWidth = 1
        checkBackground.layer.cornerRadius = checkSize / 2
        cellBackground.addSubview(checkBackground)
        
        checkImage = UIImageView(image: UIImage(named: "green check"))
        checkImage.alpha = 0
        checkBackground.addSubview(checkImage)
        
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
        
        cellBackground.snp.makeConstraints { (make) in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        
        gymLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().inset(leftPadding)
            make.centerY.equalToSuperview()
        }
        
        checkBackground.snp.makeConstraints { (make) in
            make.size.equalTo(checkSize)
            make.trailing.equalToSuperview().inset(rightPadding)
            make.centerY.equalToSuperview()
        }
        
        checkImage.snp.makeConstraints { (make) in
            make.size.equalTo(checkSize + 1)
            make.center.equalToSuperview()
        }
    }

    func toggleSelectedView(selected: Bool) {
        isOn = selected
        if selected {
            gymLabel.textColor = .fitnessBlack
            checkImage.alpha = 1
            checkBackground.layer.borderWidth = 0
        } else {
            gymLabel.textColor = .fitnessMediumGrey
            checkImage.alpha = 0
            checkBackground.layer.borderWidth = checkBorderWidth
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
