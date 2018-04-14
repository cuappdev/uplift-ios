//
//  FavoritesViewController.swift
//  Fitness
//
//  Created by Joseph Fulgieri on 4/13/18.
//  Copyright © 2018 Keivan Shahida. All rights reserved.
//

import UIKit
import SnapKit

class FavoritesViewController: UIViewController {

    //MARK: - INITIALIZATION
    var titleLabel: UILabel!
    var shadowView: UIView!
    
    var quoteLabel: UILabel!
    var nextSessionsLabel: UILabel!
    
    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        titleLabel = UILabel()
        titleLabel.font = ._24MontserratBold
        titleLabel.textColor = .fitnessBlack
        titleLabel.text = "Favorites"
        view.addSubview(titleLabel)
        
        shadowView = UIView()
        shadowView.layer.shadowColor = UIColor.fitnessBlack.cgColor
        shadowView.layer.shadowOffset = CGSize(width: 0.0, height: 15.0)
        shadowView.layer.shadowRadius = 5.0
        shadowView.layer.shadowOpacity = 0.1
        shadowView.layer.masksToBounds = false
        shadowView.layer.shadowPath = UIBezierPath(rect: shadowView.frame).cgPath
        view.addSubview(shadowView)
        
        quoteLabel = UILabel()
        quoteLabel.font = ._32Bebas
        quoteLabel.textColor = .fitnessBlack
        quoteLabel.textAlignment = .center
        quoteLabel.lineBreakMode = .byWordWrapping
        quoteLabel.numberOfLines = 0
        quoteLabel.text = "NOTHING CAN STOP YOU BUT YOURSELF."
        view.addSubview(quoteLabel)
        
        nextSessionsLabel = UILabel()
        nextSessionsLabel.font = ._12LatoBlack
        nextSessionsLabel.textColor = .fitnessDarkGrey
        nextSessionsLabel.textAlignment = .center
        nextSessionsLabel.text = "COMING UP NEXT"
        view.addSubview(nextSessionsLabel)
        
        setupConstraints()
    }
    
    //MARK: - CONSTRAINTS
    func setupConstraints() {
        titleLabel.snp.updateConstraints{make in
            make.left.equalToSuperview().offset(24)
            make.top.equalToSuperview().offset(74)
            make.bottom.equalTo(titleLabel.snp.top).offset(26)
        }
        
        shadowView.snp.updateConstraints{make in
            make.right.equalToSuperview()
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalTo(shadowView.snp.top).offset(120)
        }
        
        quoteLabel.snp.updateConstraints{make in
            make.right.equalToSuperview().offset(-60)
            make.left.equalToSuperview().offset(60)
            make.top.equalTo(shadowView.snp.bottom).offset(73)
        }
        
        nextSessionsLabel.snp.updateConstraints{make in
            make.top.equalTo(quoteLabel.snp.bottom).offset(52)
            make.bottom.equalTo(quoteLabel.snp.bottom).offset(67)
            make.centerX.equalToSuperview()
        }
    }
}
