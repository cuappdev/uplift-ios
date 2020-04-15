//
//  GamesListHeaderView.swift
//  Uplift
//
//  Created by Cameron Hamidi on 3/11/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import SnapKit
import UIKit

enum GamesListHeaderSections {
    case joinedGames
    case myGames
    case pastGames
}

class GamesListHeaderView: UICollectionReusableView {

    static let height: CGFloat = 65.0

    let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .clear

        label.textAlignment = .center
        label.textColor = .black
        label.font = ._24BebasBold
        addSubview(label)

        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(for section: GamesListHeaderSections) {
        var title = ""
        switch section {
        case .joinedGames:
            title = "Joined Games"
        case .myGames:
            title = "My Games"
        case .pastGames:
            title = "Past Games"
        }
        label.text = title
    }

    func setupConstraints() {
        label.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
        }
    }

}
