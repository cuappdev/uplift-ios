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

    // MARK: - Static vars
    static let height: CGFloat = 85.33
    static let heightShowingDayLabel: CGFloat = 108.0

    weak var gameStatusDelegate: GameStatusDelegate?

    // MARK: - Labels
    private let dayLabel = UILabel()
    private let detailLabel = UILabel()
    private let locationLabel = UILabel()
    private let playersLabel = UILabel()
    private let titleLabel = UILabel()

    // MARK: - Other Views
    private let containerView = UIView()
    private let playerIcon = UIImageView()
    private let statusButton = UIButton()

    // MARK: - Data
    private var status: GameStatus = .open
    private var id: Int = 0

    // MARK: - Constraints
    private let containerViewDayTopOffset: CGFloat = 8

    private var containerViewTopConstraint: Constraint?

    // TODO: add delegate for toggling game status

    // MARK: - Inits
    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.layer.shadowColor = UIColor.gray01.cgColor
        contentView.layer.shadowOffset = CGSize(width: 0.0, height: 11.0)
        contentView.layer.shadowRadius = 7.0
        contentView.layer.shadowOpacity = 0.50
        contentView.layer.masksToBounds = false

        containerView.layer.cornerRadius = 5
        containerView.layer.backgroundColor = UIColor.white.cgColor
        containerView.layer.borderColor = UIColor.gray01.cgColor
        containerView.layer.borderWidth = 0.5
        contentView.addSubview(containerView)

        dayLabel.font = ._12MontserratMedium
        dayLabel.textColor = .gray02
        contentView.addSubview(dayLabel)

        titleLabel.font = ._16MontserratMedium
        titleLabel.textColor = .primaryBlack
        containerView.addSubview(titleLabel)

        detailLabel.font = ._14MontserratRegular
        detailLabel.textColor = .primaryBlack
        containerView.addSubview(detailLabel)

        locationLabel.font = ._12MontserratMedium
        locationLabel.textColor = .gray05
        containerView.addSubview(locationLabel)

        playersLabel.font = ._12MontserratRegular
        playersLabel.textColor = .primaryBlack
        containerView.addSubview(playersLabel)

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

        dayLabel.snp.updateConstraints { make in
            make.leading.trailing.top.equalToSuperview()
        }

        containerView.snp.updateConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
        }

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
    func configure(for post: Post, showDayLabel: Bool = false) {
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
        dayLabel.text = post.getDay()
        titleLabel.text = post.title
        detailLabel.text = "\(post.type) · \(post.getTime())"
        locationLabel.text = post.location
        playersLabel.text = "\(post.players)/\(Post.maxPlayers)"

        statusButton.setTitle(status.rawValue, for: .normal)
        statusButton.backgroundColor = status == .open ? .clear : .primaryYellow

        if let statusLabel = statusButton.titleLabel {
            statusLabel.font = ._12MontserratBold
        }

        setupConstraints()

        if showDayLabel {
            dayLabel.isHidden = false
            containerViewTopConstraint?.uninstall()
            containerView.snp.makeConstraints { make in
                containerViewTopConstraint = make.top.equalTo(dayLabel.snp.bottom).offset(containerViewDayTopOffset).constraint
            }
        } else {
            dayLabel.isHidden = true
            containerViewTopConstraint?.uninstall()
            containerView.snp.makeConstraints { make in
                containerViewTopConstraint = make.top.equalTo(dayLabel.snp.top).constraint
            }
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
