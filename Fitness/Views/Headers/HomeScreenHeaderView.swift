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

    var welcomeMessage: UILabel!
    
    
    // MARK: - INITIALIZATION
    
    init(reuseIdentifier: String?, name: String!) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        backgroundView = UIView(frame: frame)
        backgroundView?.backgroundColor = .white
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 20
        
        welcomeMessage = UILabel()
        welcomeMessage.font = UIFont.boldSystemFont(ofSize: 24)
        welcomeMessage.lineBreakMode = .byWordWrapping
        welcomeMessage.numberOfLines = 0
        welcomeMessage.text = "Good Afternoon, " + name + "!"
        addSubview(welcomeMessage)
        
        
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
            //make.right.equalToSuperview().offset(-82)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
