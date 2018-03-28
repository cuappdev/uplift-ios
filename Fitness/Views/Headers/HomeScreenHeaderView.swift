//
//  HomeScreenHeaderView.swift
//  Fitness
//
//  Created by Joseph Fulgieri on 3/18/18.
//  Copyright © 2018 Keivan Shahida. All rights reserved.
//

import UIKit
import SnapKit

class HomeScreenHeaderView: UITableViewHeaderFooterView {

    // MARK: - INITIALIZATION
    var welcomeMessage: UILabel!
    var subHeader: HomeSectionHeaderView!
    
    init(reuseIdentifier: String?, name: String!) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        //BACKGROUND COLOR
        backgroundView = UIView(frame: frame)
        backgroundView?.backgroundColor = .white
        
        //SHADOWING
        let shadowView = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: 100))
        /*shadowView.layer.shadowPath = UIBezierPath(rect: shadowView.bounds).cgPath
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOffset = CGSize(width: 0.0, height: 15.0)
        shadowView.layer.shadowRadius = 5.0
        shadowView.layer.shadowOpacity = 0.3
        shadowView.layer.masksToBounds = false
        */
        //let shadowFrame = UIEdgeInsetsInsetRect(contentView.frame, UIEdgeInsetsMake(0, 0, 9, 0))
        
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.3
        contentView.layer.shadowRadius = 5.0
        contentView.layer.masksToBounds = false
        contentView.layer.shadowOffset = CGSize(width: 0.0, height: 15.0)
        let shadowFrame = UIEdgeInsetsInsetRect(shadowView.frame, UIEdgeInsetsMake(0, 0, 0, 0))
        contentView.layer.shadowPath = UIBezierPath(roundedRect: shadowFrame, cornerRadius: 5).cgPath
        //contentView.addSubview(shadowView)
        
        //WELCOME MESSAGE
        welcomeMessage = UILabel()
        welcomeMessage.font = UIFont.boldSystemFont(ofSize: 24)
        welcomeMessage.lineBreakMode = .byWordWrapping
        welcomeMessage.numberOfLines = 0
        welcomeMessage.text = "Good Afternoon, " + name + "!"
        addSubview(welcomeMessage)
        
        //FIRST SECTION'S HEADER
        subHeader = HomeSectionHeaderView(frame: CGRect())
        addSubview(subHeader)
        
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LAYOUT
    func setupLayout() {
        
        welcomeMessage.snp.updateConstraints { make in
            make.height.equalTo(26)
            make.left.equalToSuperview().offset(24)
            make.bottom.equalToSuperview().offset(-75)
        }
        
        subHeader.snp.updateConstraints{make in
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(100)
        }
    }
}
