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
    
    weak var gameStatusDelegate: GameStatusDelegate?
    
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
    private var id: Int = 0
    
    // TODO: add delegate for toggling game status
   
    // MARK: - Inits
    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.layer.cornerRadius = 5
        contentView.layer.backgroundColor = UIColor.white.cgColor
        contentView.layer.borderColor = UIColor.gray01.cgColor
        contentView.layer.borderWidth = 0.5

        contentView.layer.shadowColor = UIColor.gray01.cgColor
        contentView.layer.shadowOffset = CGSize(width: 0.0, height: 11.0)
        contentView.layer.shadowRadius = 7.0
        contentView.layer.shadowOpacity = 0.50
        contentView.layer.masksToBounds = false
        
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
        
        playerIcon.image = UIImage(named: ImageNames.personIcon)
        playerIcon.contentMode = .scaleAspectFit
        contentView.addSubview(playerIcon)
        
        setupConstraints()
    }

    @objc func toggleStatus() {
        // TODO: toggle game status
        switch status {
        case .joined:
            gameStatusDelegate?.didChangeStatus(id: id, status: .open)
        case .open:
            gameStatusDelegate?.didChangeStatus(id: id, status: .joined)
        case .created:
            return
        }
    }

    private func setupConstraints() {
        let largePadding = 16
        let mediumPadding = 12
        let smallPadding = 6
        
        let playerIconHeight = 12
        let playerIconWidth = 12
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
            make.trailing.equalTo(playersLabel.snp.leading).offset(-smallPadding)
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
    func configure(post: Post) {
        // Configure data.
        id = post.id
        switch post.gameStatus {
        case "CREATED":
            status = .created
        case "JOINED":
            status = .joined
        default:
            status = .open
        }
        
        // Configure views.
        titleLabel.text = post.title
        detailLabel.text = "\(post.type) · \(post.time)"
        locationLabel.text = post.location
        playersLabel.text = "\(post.players)/10"

        statusButton.setTitle(status.rawValue, for: .normal)
        statusButton.backgroundColor = status == .open ? .clear : .primaryYellow
        
        if let statusLabel = statusButton.titleLabel {
            statusLabel.font = ._12MontserratBold
        }
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
