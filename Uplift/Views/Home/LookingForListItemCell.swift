//
//  CategoryListItemCell.swift
//  Uplift
//
//  Created by Cameron Hamidi on 9/10/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import SnapKit
import UIKit

class LookingForListItemCell: ListItemCollectionViewCell<Tag> {
    
    // MARK: - Public static vars
    static let identifier = Identifiers.categoryCell
    
    // MARK: - INITIALIZATION
    private var image: UIImageView!
    private var title: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = frame.height/32
        clipsToBounds = true
        
        // IMAGE
        image = UIImageView()
        contentView.addSubview(image)
        
        // TITLE
        title = UILabel()
        title.font = ._16MontserratSemiBold
        title.textColor = .white
        contentView.addSubview(title)
        
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configure(for tag: Tag) {
        super.configure(for: tag)
        
        title.text = tag.name
        let url = URL(string: tag.imageURL)
        image.kf.setImage(with: url)
    }
    
    // MARK: - CONSTRAINTS
    func setupConstraints() {
        image.snp.updateConstraints { make in
            make.size.equalToSuperview()
            make.center.equalToSuperview()
        }
        
        title.snp.updateConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
}

