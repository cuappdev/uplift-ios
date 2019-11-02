//
//  PersonalLinkCollectionViewCell.swift
//  Uplift
//
//  Created by Cameron Hamidi on 3/2/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import UIKit
import SnapKit

class PersonalLinkCollectionViewCell: UICollectionViewCell {
    static let identifier = Identifiers.personalSiteCell
    var siteImageView: UIImageView!

    override init(frame: CGRect) {
        super.init(frame: frame)

        siteImageView = UIImageView()
        siteImageView.contentMode = .scaleAspectFill
        contentView.addSubview(siteImageView)

        setupConstraints()
    }
    
    func configure(for site: PersonalLink) {
        switch site.site {
        case PersonalLink.SiteType.facebook: siteImageView.image = UIImage(named: "facebook")
        case PersonalLink.SiteType.instagram: siteImageView.image = UIImage(named: "instagram")
        case PersonalLink.SiteType.linkedin: siteImageView.image = UIImage(named: "linkedin")
        case PersonalLink.SiteType.other: siteImageView.image = UIImage(named: "web")
        case PersonalLink.SiteType.twitter: siteImageView.image = UIImage(named: "Rectangle.png")
        }
    }

    func setupConstraints() {
        siteImageView.snp.updateConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalToSuperview()
            make.width.equalToSuperview()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
