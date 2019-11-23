//
//  FavoriteGymCell.swift
//  Uplift
//
//  Created by Phillip OReggio on 3/5/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import UIKit

class FavoriteGymCell: UITableViewCell {

    // MARK: Private View Vars
    private var cellBackground = UIView()
    private var gymLabel = UILabel()
    private var favoritedBackground = UIView()
    private var favoritedIcon = UIImageView()

    private let checkSize: CGFloat = 24
    private let checkBorderWidth: CGFloat = 1
    private let leftPadding: CGFloat = 15
    private let rightPadding: CGFloat = 16

    private var usesStars = false
    private var updateAppearence: ((Bool) -> Void)?

    // MARK: Public View Vars
    var isOn = false

    // Reuse Identfier
    static let identifier = "favoritesTableView"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.contentView.backgroundColor = .white

        cellBackground.backgroundColor =  .primaryWhite
        cellBackground.layer.cornerRadius = 6
        cellBackground.layer.borderWidth = checkBorderWidth
        cellBackground.layer.borderColor = UIColor.gray01.cgColor
        cellBackground.layer.shadowOpacity = 0.125
        cellBackground.layer.shadowRadius = 6
        cellBackground.layer.shadowOffset = CGSize(width: 1, height: 3)

        contentView.addSubview(cellBackground)

        gymLabel.font = ._16MontserratMedium
        gymLabel.textColor = .upliftMediumGrey
        cellBackground.addSubview(gymLabel)

        favoritedBackground.tintColor = .primaryWhite
        favoritedBackground.layer.borderColor = UIColor.upliftMediumGrey.cgColor
        favoritedBackground.layer.borderWidth = 0
        favoritedBackground.layer.cornerRadius = checkSize / 2
        cellBackground.addSubview(favoritedBackground)

        favoritedIcon = UIImageView()
        favoritedIcon.contentMode = .scaleAspectFit
        favoritedBackground.addSubview(favoritedIcon)

        setUpConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(with gymName: String, displaysClasses: Bool) {
        usesStars = displaysClasses

        if usesStars {
            favoritedIcon.image = UIImage(named: ImageNames.blackStarOutline)
            updateAppearence = { isOn in
                self.gymLabel.textColor = isOn ? .primaryBlack : .upliftMediumGrey
                self.favoritedIcon.image = UIImage(named: isOn ? ImageNames.yellowStar : ImageNames.blackStarOutline)
            }
        } else {
            favoritedIcon.alpha = 0
            favoritedIcon.image = UIImage(named: ImageNames.checkedCircle)
            favoritedBackground.layer.borderWidth = 1
            updateAppearence = { (isOn) -> Void in
                self.gymLabel.textColor = isOn ? .primaryBlack : .upliftMediumGrey
                self.favoritedIcon.alpha = isOn ? 1 : 0
                self.favoritedBackground.layer.borderWidth = isOn ? 0 : self.checkBorderWidth
            }
        }

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

        favoritedBackground.snp.makeConstraints { (make) in
            make.size.equalTo(checkSize)
            make.trailing.equalToSuperview().inset(rightPadding)
            make.centerY.equalToSuperview()
        }

        favoritedIcon.snp.makeConstraints { (make) in
            make.size.equalTo(checkSize + 1)
            make.center.equalToSuperview()
        }
    }

    func toggleSelectedView(selected: Bool) {
        isOn = selected
        updateAppearence?(selected)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
