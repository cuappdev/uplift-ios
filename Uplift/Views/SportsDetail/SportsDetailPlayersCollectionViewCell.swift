//
//  SportsDetailPlayersCollectionViewCell.swift
//  Uplift
//
//  Created by Artesia Ko on 4/18/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import UIKit

class SportsDetailPlayersCollectionViewCell: UICollectionViewCell {
    
    private let caratImage = UIImageView()
    private let divider = UIView()
    private let headerLabel = UILabel()
    private let previewLabel = UILabel()
    private let playersTextView = UITextView()
    
    private var players: [User] = []
    private var dropStatus: DropdownStatus = .closed
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
        setupConstraints()
    }

    func setupViews() {
        headerLabel.font = ._16MontserratBold
        headerLabel.textAlignment = .center
        headerLabel.numberOfLines = 0
        headerLabel.textColor = .primaryBlack
        contentView.addSubview(headerLabel)
        
        caratImage.image = UIImage(named: ImageNames.rightArrowSolid)
        caratImage.contentMode = .scaleAspectFit
        caratImage.clipsToBounds = true
        contentView.addSubview(caratImage)
        
        previewLabel.font = ._14MontserratLight
        previewLabel.textAlignment = .center
        previewLabel.numberOfLines = 0
        previewLabel.textColor = .primaryBlack
        contentView.addSubview(previewLabel)
        
        playersTextView.isEditable = false
        playersTextView.textAlignment = .center
        playersTextView.font = ._14MontserratLight
        playersTextView.textColor = .primaryBlack
        playersTextView.isScrollEnabled = false
        contentView.addSubview(playersTextView)
        
        divider.backgroundColor = .gray01
        contentView.addSubview(divider)
    }
    
    func setupConstraints() {
        let caratImageHeight = 10
        let caratImageWidth = 10
        let headerCaratHorizontalPadding = 12
        let headerPlayersVerticalPadding = 14
        let horizontalPadding = 40
        let verticalPadding = 24
        
        headerLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(verticalPadding)
        }
        
        caratImage.snp.makeConstraints { make in
            make.centerY.equalTo(headerLabel)
            make.height.equalTo(caratImageHeight)
            make.width.equalTo(caratImageWidth)
            make.leading.equalTo(headerLabel.snp.trailing).offset(headerCaratHorizontalPadding)
        }
        
        previewLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(horizontalPadding)
            make.bottom.equalToSuperview().inset(verticalPadding)
        }
        
        playersTextView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(horizontalPadding)
            make.bottom.equalToSuperview().inset(verticalPadding)
            make.top.equalTo(headerLabel.snp.bottom).offset(headerPlayersVerticalPadding)
        }
        
        divider.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    func configure(for post: Post, dropStatus: DropdownStatus) {
        headerLabel.text = "PLAYERS \(post.players)/10"
        self.dropStatus = dropStatus
        caratImage.image = dropStatus == .closed
            ? UIImage(named: ImageNames.rightArrowSolid)
            : UIImage(named: ImageNames.downArrowSolid)
        previewLabel.isHidden = dropStatus == .open
        // TODO: Add player names to post and rewrite preview label.
        players = [User(id: "p1", name: "Zain Khoja", netId: "znksomething"),
        User(id: "p2", name: "Amanda He", netId: "noidea"),
        User(id: "p3", name: "Yi Hsin Wei", netId: "y???")]
        previewLabel.text = "Zain, Amanda, Yi Hsin, Yanlam, +5 more"
        
        playersTextView.isHidden = dropStatus == .closed
        playersTextView.text = players.reduce("", { (result: String, p: User) -> String in
            return result + p.name + "\n"
        })

        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
