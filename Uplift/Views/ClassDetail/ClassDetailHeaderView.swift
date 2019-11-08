//
//  ClassDetailHeaderView.swift
//  Uplift
//
//  Created by Kevin Chan on 5/18/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import UIKit

protocol ClassDetailHeaderViewDelegate: class {
    func classDetailHeaderViewFavoriteButtonTapped()
    func classDetailHeaderViewBackButtonPressed()
    func classDetailHeaderViewLocationSelected()
    func classDetailHeaderViewInstructorSelected()
    func classDetailHeaderViewShareButtonTapped()
}

class ClassDetailHeaderView: UICollectionReusableView {

    // MARK: - Private view vars
    private let backButton = UIButton()
    private let imageView = UIImageView()
    private let imageFilterView = UIView()
    private let semicircleImageView = UIImageView(image: UIImage(named: ImageNames.semicircle))
    private let titleLabel = UILabel()
    private let locationButton = UIButton()
    private let instructorButton = UIButton()
    private let durationLabel = UILabel()
    private let favoriteButton = UIButton()
    private let shareButton = UIButton()

    // MARK: - Private data vars
    private weak var delegate: ClassDetailHeaderViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
        setupConstraints()
    }

    // MARK: - Public configure
    func configure(for delegate: ClassDetailHeaderViewDelegate, gymClassInstance: GymClassInstance) {
        self.delegate = delegate
        imageView.kf.setImage(with: gymClassInstance.imageURL)
        titleLabel.text = gymClassInstance.className.uppercased()
        locationButton.setTitle(gymClassInstance.location, for: .normal)
        instructorButton.setTitle(gymClassInstance.instructor.uppercased(), for: .normal)
        durationLabel.text = String(Int(gymClassInstance.duration) / 60) + ClientStrings.ClassDetail.durationMin
    }
    
    func selectFavoriteButton() {
        favoriteButton.isSelected = true
    }
    
    func deselectFavoriteButton() {
        favoriteButton.isSelected = false
    }

    // MARK: - Targets
    @objc func back() {
        delegate?.classDetailHeaderViewBackButtonPressed()
    }
    
    @objc func locationSelected() {
        delegate?.classDetailHeaderViewLocationSelected()
    }

    @objc func instructorSelected() {
        delegate?.classDetailHeaderViewInstructorSelected()
    }
    
    @objc func favoriteButtonTapped() {
        delegate?.classDetailHeaderViewFavoriteButtonTapped()
    }
    
    @objc func share() {
        delegate?.classDetailHeaderViewShareButtonTapped()
    }

    // MARK: - CONSTRAINTS
    private func setupViews() {
        backButton.setImage(UIImage(named: ImageNames.lightBackArrow), for: .normal)
        backButton.sizeToFit()
        backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        addSubview(backButton)
        
        favoriteButton.setImage(UIImage(named: ImageNames.whiteStarOutline), for: .normal)
        favoriteButton.setImage(UIImage(named: ImageNames.yellowWhiteStar), for: .selected)
        favoriteButton.sizeToFit()
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        addSubview(favoriteButton)

        shareButton.setImage(UIImage(named: ImageNames.lightShare), for: .normal)
        shareButton.sizeToFit()
        shareButton.addTarget(self, action: #selector(self.share), for: .touchUpInside)
        addSubview(shareButton)
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        addSubview(imageView)

        imageFilterView.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.6)
        addSubview(imageFilterView)

        semicircleImageView.contentMode = UIView.ContentMode.scaleAspectFit
        semicircleImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(semicircleImageView)

        titleLabel.font = ._48Bebas
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.textColor = .primaryWhite
        addSubview(titleLabel)

        locationButton.setTitleColor(.primaryWhite, for: .normal)
        locationButton.titleLabel?.font = ._14MontserratRegular
        locationButton.titleLabel?.textAlignment = .center
        locationButton.addTarget(self, action: #selector(locationSelected), for: .touchUpInside)
        addSubview(locationButton)

        instructorButton.titleLabel?.font = ._16MontserratBold
        instructorButton.titleLabel?.textAlignment = .center
        instructorButton.setTitleColor(.primaryWhite, for: .normal)
        instructorButton.addTarget(self, action: #selector(instructorSelected), for: .touchUpInside)
        addSubview(instructorButton)

        durationLabel.font = ._14MontserratBold
        durationLabel.textAlignment = .center
        durationLabel.textColor = .primaryBlack
        addSubview(durationLabel)
        
        bringSubviewToFront(backButton)
        bringSubviewToFront(favoriteButton)
        bringSubviewToFront(shareButton)
    }

    private func setupConstraints() {
        let durationLabelBottomPadding = 5
        let durationLabelSize = CGSize(width: 52, height: 18)
        let instructorButtonHeight = 21
        let instructorButtonTopPadding = 20
        let locationButtonHeight = 16
        let semicircleImageViewSize = CGSize(width: 100, height: 50)
        let titleLabelHorizontalPadding = 40
        let backButtonLeftPadding = 20
        let backButtonSize = CGSize(width: 24, height: 24)
        let backButtonTopPadding = 36
        let favoriteButtonRightPadding = 20
        let favoriteButtonSize = CGSize(width: 23, height: 23)
        let shareButtonRightPadding = 14
        let shareButtonSize = CGSize(width: 24, height: 24)

        backButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(backButtonLeftPadding)
            make.top.equalTo(self.snp.top).offset(backButtonTopPadding)
            make.size.equalTo(backButtonSize)
        }
        
        favoriteButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-favoriteButtonRightPadding)
            make.top.equalTo(backButton.snp.top)
            make.size.equalTo(favoriteButtonSize)
        }

        shareButton.snp.makeConstraints { make in
            make.trailing.equalTo(favoriteButton.snp.leading).offset(-shareButtonRightPadding)
            make.top.equalTo(favoriteButton.snp.top)
            make.size.equalTo(shareButtonSize)
        }
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        imageFilterView.snp.makeConstraints { make in
            make.edges.equalTo(imageView)
        }

        semicircleImageView.snp.makeConstraints { make in
            make.bottom.equalTo(imageView.snp.bottom)
            make.centerX.equalToSuperview()
            make.size.equalTo(semicircleImageViewSize)
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(titleLabelHorizontalPadding)
            make.center.equalToSuperview()
        }

        locationButton.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom)
            make.trailing.equalToSuperview()
            make.height.equalTo(locationButtonHeight)
        }

        instructorButton.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(locationButton.snp.bottom).offset(instructorButtonTopPadding)
            make.trailing.equalToSuperview()
            make.height.equalTo(instructorButtonHeight)
        }

        durationLabel.snp.makeConstraints { make in
            make.bottom.equalTo(imageView.snp.bottom).offset(-durationLabelBottomPadding)
            make.centerX.equalToSuperview()
            make.size.equalTo(durationLabelSize)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
