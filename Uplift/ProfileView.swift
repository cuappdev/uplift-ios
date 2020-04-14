//
//  ProfileView.swift
//  Uplift
//
//  Created by Cameron Hamidi on 3/1/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import SnapKit
import UIKit

class ProfileView: UIView {

    private let profilePicture = UIImageView(frame: .zero)
    private let nameLabel = UILabel()
    private let gamesPlayedLabel = UILabel()
    private let collectionView: UICollectionView!

    let profilePictureSize: CGFloat = 60

    var dismissClosure: (() -> ())!

    override init(frame: CGRect) {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 36, left: 0, bottom: 0, right: 0)
        
        collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)

        super.init(frame: frame)

        backgroundColor = .white

        let gesture = UISwipeGestureRecognizer(target: self, action: #selector(close))
        gesture.direction = .left
        addGestureRecognizer(gesture)

        profilePicture.image = UIImage(named: ImageNames.profilePicDemo)
        profilePicture.layer.cornerRadius = profilePictureSize
        addSubview(profilePicture)

        nameLabel.text = "Zain Khoja"
        nameLabel.font = ._24MontserratBold
        nameLabel.textAlignment = .center
        nameLabel.textColor = .black
        addSubview(nameLabel)

        gamesPlayedLabel.text = "27 games played"
        gamesPlayedLabel.font = ._14MontserratMedium
        gamesPlayedLabel.textAlignment = .center
        gamesPlayedLabel.textColor = .gray04
        addSubview(gamesPlayedLabel)

        collectionView.register(GamesListHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Identifiers.gamesListHeaderView)

        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func close() {
        if let dismiss = dismissClosure {
            dismiss()
        }
    }

    func setupConstraints() {
        let profilePictureTopOffset = 68
        let nameLabelTopOffset = 12
        let gamesPlayedLabelTopOffset = 4

        profilePicture.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(profilePictureTopOffset)
            make.height.width.equalTo(profilePictureSize)
        }

        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(profilePicture.snp.bottom).offset(nameLabelTopOffset)
            make.centerX.equalToSuperview()
        }

        gamesPlayedLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(gamesPlayedLabelTopOffset)
            make.centerX.equalToSuperview()
        }
    }

}
