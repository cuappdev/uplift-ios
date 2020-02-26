//
//  PickupGameCell.swift
//  Uplift
//
//  Created by Artesia Ko on 2/19/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import SnapKit
import UIKit

class PickupGameCell: UICollectionViewCell {
    
    // MARK: - Labels
    private let detailLabel = UILabel()
    private let locationLabel = UILabel()
    private let playersLabel = UILabel()
    private let titleLabel = UILabel()
    
    // MARK: - Other Views
    private let playerIcon = UIImageView()
    private let statusButton = UIButton()
    
    // MARK: - Data
    private var status: GameStatus = .open
    
    // TODO: add delegate for toggling game status
    
    enum GameStatus: String {
        case created = "CREATED"
        case joined = "JOINED"
        case open = "OPEN"
    }
   
    // MARK: - Inits
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleLabel.font = ._16MontserratMedium
        titleLabel.textColor = .primaryBlack
        contentView.addSubview(titleLabel)
        
        detailLabel.font = ._14MontserratRegular
        detailLabel.textColor = .primaryBlack
        contentView.addSubview(detailLabel)
        
        locationLabel.font = ._12MontserratMedium
        locationLabel.textColor = .gray05
        contentView.addSubview(locationLabel)
        
        playersLabel.font = ._12MontserratRegular
        playersLabel.textColor = .primaryBlack
        contentView.addSubview(playersLabel)
        
        statusButton.layer.borderColor = UIColor.primaryBlack.cgColor
        statusButton.layer.borderWidth = 1
        statusButton.layer.cornerRadius = 12
        statusButton.layer.masksToBounds = true
        statusButton.setTitleColor(.primaryBlack, for: .normal)
        statusButton.addTarget(self, action: #selector(toggleStatus), for: .touchUpInside)
        contentView.addSubview(statusButton)
        
        playerIcon.image = UIImage(named: "TODO")
        contentView.addSubview(playerIcon)
        
        setupConstraints()
    }
    
    @objc func toggleStatus() {
        // TODO: toggle game status
    }

    private func setupConstraints() {
        let largePadding = 16
        let mediumPadding = 12
        let smallPadding = 6
        
        let playerIconHeight = 12
        let playerIconWidth = 8
        let statusButtonHeight = 24
        let statusButtonWidth = status == .created ? 75 : status == .joined ? 65 : 48
        
        titleLabel.snp.updateConstraints { make in
            make.top.equalToSuperview().inset(largePadding)
            make.leading.trailing.equalToSuperview().inset(mediumPadding)
        }
        
        statusButton.snp.updateConstraints { make in
            make.trailing.equalToSuperview().inset(mediumPadding)
            make.centerY.equalToSuperview()
            make.height.equalTo(statusButtonHeight)
            make.width.equalTo(statusButtonWidth)
        }
        
        playersLabel.snp.updateConstraints { make in
            make.bottom.trailing.equalToSuperview().inset(mediumPadding)
        }
        
        playerIcon.snp.updateConstraints { make in
            make.centerY.equalTo(playersLabel)
            make.trailing.equalTo(playersLabel.snp.leading).inset(smallPadding)
            make.height.equalTo(playerIconHeight)
            make.width.equalTo(playerIconWidth)
        }
        
        detailLabel.snp.updateConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.equalToSuperview().inset(mediumPadding)
            make.trailing.equalTo(statusButton.snp.leading).inset(mediumPadding)
        }
        
        locationLabel.snp.updateConstraints { make in
            make.bottom.equalToSuperview().inset(largePadding)
            make.leading.equalToSuperview().inset(mediumPadding)
            make.trailing.equalTo(playerIcon.snp.leading).inset(mediumPadding)
        }
    }

    // MARK: - Functionality
    func configure(title: String, type: String, time: String, location: String, players: Int, gameStatus: GameStatus) {
        status = gameStatus
        titleLabel.text = title
        detailLabel.text = "\(type) · \(time)"
        locationLabel.text = location
        playersLabel.text = "\(players)/10"
        
        switch gameStatus {
        case .created:
            statusButton.setTitle("MY GAME", for: .normal)
            statusButton.backgroundColor = .primaryYellow
        case .joined:
            statusButton.setTitle("JOINED", for: .normal)
            statusButton.backgroundColor = .primaryYellow
        case .open:
            statusButton.setTitle("JOIN", for: .normal)
            statusButton.backgroundColor = .clear
        }
        
        if let statusLabel = statusButton.titleLabel {
            statusLabel.font = ._12MontserratBold
        }
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
