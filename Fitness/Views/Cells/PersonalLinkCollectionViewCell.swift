//
//  PersonalLinkCollectionViewCell.swift
//  Fitness
//
//  Created by Cameron Hamidi on 3/2/19.
//  Copyright © 2019 Keivan Shahida. All rights reserved.
//

import UIKit
import SnapKit

class PersonalLinkCollectionViewCell: UICollectionViewCell {
    static let identifier = Identifiers.personalSiteCell
    var siteImageView: UIImageView!
    var site: PersonalLinkObject!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        siteImageView = UIImageView()
        siteImageView.contentMode = .scaleAspectFill
        contentView.addSubview(siteImageView)
        
        setupConstraints()
    }
    
    func configure(for site: PersonalLinkObject) {
        self.site = site
        print(siteImageView.image == nil)
        switch site.site {
        case PersonalLink.facebook: siteImageView.image = #imageLiteral(resourceName: "Facebook.png")
        case PersonalLink.linkedin: siteImageView.image = #imageLiteral(resourceName: "Linkedin.png")
        case PersonalLink.instagram: siteImageView.image = #imageLiteral(resourceName: "Insta.png")
        case PersonalLink.twitter: siteImageView.image = #imageLiteral(resourceName: "Rectangle.png")
        case PersonalLink.other: siteImageView.image = #imageLiteral(resourceName: "Web.png")
        }
    }
    
    func setupConstraints() {
        siteImageView.snp.updateConstraints {make in
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
