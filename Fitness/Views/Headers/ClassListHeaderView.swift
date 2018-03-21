//
//  ClassListHeaderView.swift
//  Fitness
//
//  Created by Keivan Shahida on 3/21/18.
//  Copyright © 2018 Keivan Shahida. All rights reserved.
//

import UIKit
import SnapKit

class ClassListHeaderView: UITableViewHeaderFooterView {

    // MARK: - INITIALIZATION
    var currentDateLabel: UILabel!
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        layer.backgroundColor = UIColor.white.cgColor
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LAYOUT
    override func layoutSubviews() {

        currentDateLabel = UILabel()
        currentDateLabel.text = "TODAY"
        currentDateLabel.font = ._14MontserratMedium
        currentDateLabel.textAlignment = .center
        currentDateLabel.textColor = .fitnessDarkGrey
        currentDateLabel.sizeToFit()
        addSubview(currentDateLabel)
        
        setConstraints()
    }
    
    // MARK: - CONSTRAINTS
    func setConstraints(){
        currentDateLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-32)
            make.height.equalTo(15)
        }
    }
}
