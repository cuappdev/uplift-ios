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
        case PersonalLink.SiteType.facebook: siteImageView.image = #imageLiteral(resourceName: "Facebook.png")
        case PersonalLink.SiteType.instagram: siteImageView.image = #imageLiteral(resourceName: "Insta.png")
        case PersonalLink.SiteType.linkedin: siteImageView.image = #imageLiteral(resourceName: "Linkedin.png")
        case PersonalLink.SiteType.other: siteImageView.image = #imageLiteral(resourceName: "Web.png")
        case PersonalLink.SiteType.twitter: siteImageView.image = #imageLiteral(resourceName: "Rectangle.png")
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
