//
//  SportsDetailHeaderView.swift
//  Uplift
//
//  Created by Artesia Ko on 4/18/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import UIKit

protocol SportsDetailHeaderViewDelegate: class {
    func sportsDetailHeaderViewBackButtonTapped()
}

class SportsDetailHeaderView: UICollectionReusableView {
    
    private let backButton = UIButton()
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let locationLabel = UILabel()
    private let typeLabel = UILabel()
    private let nameLabel = UILabel()
    
    private weak var delegate: SportsDetailHeaderViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
        setupConstraints()
    }
    
    func configure(for delegate: SportsDetailHeaderViewDelegate, for post: Post) {
        self.delegate = delegate
        
        titleLabel.text = post.title.uppercased()
        locationLabel.text = post.location
        typeLabel.text = post.type.uppercased()
        nameLabel.text = "Created by: TODO"
    }
    
    private func setupViews() {
        imageView.backgroundColor = .blue
        imageView.image = UIImage() // TODO: load image.
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        addSubview(imageView)
        
        titleLabel.font = ._32Bebas
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.textColor = .white
        addSubview(titleLabel)
        
        locationLabel.font = ._14MontserratRegular
        locationLabel.textAlignment = .center
        locationLabel.numberOfLines = 0
        locationLabel.textColor = .white
        addSubview(locationLabel)
        
        typeLabel.font = ._16MontserratBold
        typeLabel.textAlignment = .center
        typeLabel.numberOfLines = 0
        typeLabel.textColor = .white
        addSubview(typeLabel)
        
        nameLabel.font = ._12MontserratMedium
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
        let titleLocationPadding = 16
        let locationTypePadding = 24
        let namePadding = 28
        let horizontalPadding = 40
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(horizontalPadding)
            make.bottom.equalToSuperview().inset(namePadding)
        }
        
        typeLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(horizontalPadding)
            make.bottom.equalTo(nameLabel.snp.top).offset(-namePadding)
        }
        
        locationLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(horizontalPadding)
            make.bottom.equalTo(typeLabel.snp.top).offset(-locationTypePadding)
            
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(horizontalPadding)
            make.bottom.equalTo(locationLabel.snp.top).offset(-titleLocationPadding)
        }
        
        backButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(backButtonLeftPadding)
            make.top.equalToSuperview().offset(backButtonTopPadding)
            make.size.equalTo(backButtonSize)
        }
        
    }
    
    @objc func backButtonTapped() {
        delegate?.sportsDetailHeaderViewBackButtonTapped()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
