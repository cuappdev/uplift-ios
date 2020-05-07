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
    
    // Keep public to allow SportsDetailViewController to use same constraints for calculating cell height.
    public struct Constraints {
        static let caratImageHeight = 10
        static let caratImageWidth = 10
        static let dividerHeight = 1
        static let headerCaratHorizontalPadding = 12
        static let headerLabelHeight = 18
        static let headerPlayersVerticalPadding = 14
        static let horizontalPadding = 40
        static let verticalPadding = 24
    }
    
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
        headerLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(Constraints.verticalPadding)
            make.height.equalTo(Constraints.headerLabelHeight)
        }
        
        caratImage.snp.makeConstraints { make in
            make.centerY.equalTo(headerLabel)
            make.height.equalTo(Constraints.caratImageHeight)
            make.width.equalTo(Constraints.caratImageWidth)
            make.leading.equalTo(headerLabel.snp.trailing).offset(Constraints.headerCaratHorizontalPadding)
        }
        
        previewLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(Constraints.horizontalPadding)
            make.bottom.equalToSuperview().inset(Constraints.verticalPadding)
        }
        
        playersTextView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(Constraints.horizontalPadding)
            make.bottom.equalToSuperview().inset(Constraints.verticalPadding)
            make.top.equalTo(headerLabel.snp.bottom).offset(Constraints.headerPlayersVerticalPadding)
        }
        
        divider.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalTo(Constraints.dividerHeight)
        }
    }
    
    func getPlayersPreview(players: [User]) -> String {
        var count = players.count
        var previewString = ""
        for player in players {
            let playerName = player.givenName ?? player.name
            let constraintedWidth = self.frame.width - CGFloat(2 * Constraints.horizontalPadding)
            let resultingString = "\(previewString), \(playerName), +\(count - 1) more"
            let resultingHeight = resultingString.height(withConstrainedWidth: constraintedWidth, font: ._14MontserratLight ?? UIFont.systemFont(ofSize: 14))
            let currentHeight = previewString.height(withConstrainedWidth: constraintedWidth, font: ._14MontserratLight ?? UIFont.systemFont(ofSize: 14))
            if previewString == "" {
                previewString += "\(playerName)"
                count -= 1
            } else if resultingHeight <= currentHeight {
                previewString += ", \(playerName)"
                count -= 1
            } else {
                return "\(previewString), +\(count) more"
            }
        }
        return previewString == "" ? "Be the first to join the game." : previewString
    }
    
    func configure(for post: Post, dropStatus: DropdownStatus) {
        headerLabel.text = "\(ClientStrings.SportsDetail.players) \(post.players.count)/\(Post.maxPlayers)"
        self.dropStatus = dropStatus
        caratImage.image = dropStatus == .closed
            ? UIImage(named: ImageNames.rightArrowSolid)
            : UIImage(named: ImageNames.downArrowSolid)
        
        previewLabel.isHidden = dropStatus == .open
        previewLabel.text = getPlayersPreview(players: post.players)
        
        playersTextView.isHidden = dropStatus == .closed
        players = post.players
        playersTextView.text = post.getPlayersListString()

        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
