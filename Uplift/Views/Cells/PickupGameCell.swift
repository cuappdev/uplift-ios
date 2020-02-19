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
    private let locationLabel = UILabel()
    private let playersLabel = UILabel()
    private let titleLabel = UILabel()
    private let detailLabel = UILabel()
    
    // MARK: - Other Views
    private let statusButton = UIButton()
    private let playerIcon = UIImageView()
    
    // MARK: - Data
    private var status: GameStatus = .open
    
    // TODO: add delegate for toggling game status
    
    enum GameStatus {
        case created
        case joined
        case open
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
        let smallPadding = 6
        let mediumPadding = 12
        let largePadding = 16
        
        titleLabel.snp.updateConstraints { make in
            make.top.equalToSuperview().offset(largePadding)
            make.leading.trailing.equalToSuperview().offset(mediumPadding)
        }
        
        statusButton.snp.updateConstraints { make in
            make.trailing.equalToSuperview().offset(mediumPadding)
            make.centerY.equalToSuperview()
            make.height.equalTo(24)
            switch status {
            case .created:
                make.width.equalTo(75)
            case .joined:
                make.width.equalTo(65)
            case .open:
                make.width.equalTo(48)
            }
        }
        
        playersLabel.snp.updateConstraints { make in
            make.bottom.trailing.equalToSuperview().offset(mediumPadding)
        }
        
        playerIcon.snp.updateConstraints { make in
            make.centerY.equalTo(playersLabel)
            make.trailing.equalTo(playersLabel.snp.leading).offset(smallPadding)
            make.height.equalTo(12)
            make.width.equalTo(8)
        }
        
        detailLabel.snp.updateConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.equalToSuperview().offset(mediumPadding)
            make.trailing.equalTo(statusButton.snp.leading).offset(mediumPadding)
        }
        
        locationLabel.snp.updateConstraints { make in
            make.bottom.equalToSuperview().offset(largePadding)
            make.leading.equalToSuperview().offset(mediumPadding)
            make.trailing.equalTo(playerIcon.snp.leading).offset(mediumPadding)
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
