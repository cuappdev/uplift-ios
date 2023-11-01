//
//  GymDetailHeaderView.swift
//  Uplift
//
//  Created by Yana Sang on 5/22/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import UIKit

protocol GymDetailHeaderViewDelegate: AnyObject {
    func gymDetailHeaderViewBackButtonTapped()
}

class GymDetailHeaderView: UICollectionReusableView {

    static let reuseId = "gymDetailHeaderViewIdentifier"

    // MARK: - Private view vars
    private let backButton = UIButton()
    private let closedLabel = UILabel()
    private let imageView = UIImageView()
    private let nameLabel = UILabel()

    // MARK: - Private data vars
    private weak var delegate: GymDetailHeaderViewDelegate?
    private var isOpen: Bool = true

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
        setupConstraints()
    }

    // MARK: - Public configure
    func configure(for delegate: GymDetailHeaderViewDelegate, for gym: Gym) {
        self.delegate = delegate
        isOpen = gym.isOpen()
        imageView.kf.setImage(with: gym.imageURL)
        nameLabel.text = gym.name.uppercased()

        setupConstraints()
    }

    // MARK: - CONSTRAINTS
    private func setupViews() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        addSubview(imageView)

        closedLabel.font = ._16MontserratMedium
        closedLabel.textColor = .primaryWhite
        closedLabel.textAlignment = .center
        closedLabel.backgroundColor = .primaryBlack
        closedLabel.text = ClientStrings.GymDetail.closedLabel

        nameLabel.font = ._36MontserratBold
        nameLabel.textAlignment = .center
        nameLabel.numberOfLines = 0
        nameLabel.textColor = .white
        addSubview(nameLabel)

        backButton.setImage(UIImage(named: ImageNames.backArrowLight), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        addSubview(backButton)
    }

    private func setupConstraints() {
        let backButtonLeftPadding = 20
        let backButtonTopPadding = 44
        let backButtonSize = CGSize(width: 24, height: 24)
        let closedLabelHeight = 60
        let horizontalPadding = 40

        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        nameLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(horizontalPadding)
            make.center.equalToSuperview()
        }

        backButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(backButtonLeftPadding)
            make.top.equalToSuperview().offset(backButtonTopPadding)
            make.size.equalTo(backButtonSize)
        }

        if !isOpen {
            addSubview(closedLabel)

            closedLabel.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview()
                make.height.equalTo(closedLabelHeight)
                make.bottom.equalTo(imageView)
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Targets
    @objc func backButtonTapped() {
        delegate?.gymDetailHeaderViewBackButtonTapped()
    }
}
