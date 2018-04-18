//
//  GymDetailViewController.swift
//  Fitness
//
//  Created by Joseph Fulgieri on 4/18/18.
//  Copyright © 2018 Keivan Shahida. All rights reserved.
//

import UIKit
import SnapKit

class GymDetailViewController: UIViewController {

    //MARK: - INITIALIZATION
    var scrollView: UIScrollView!
    var contentView: UIView!
    
    var backButton: UIButton!
    var starButton: UIButton!
    var gymImageView: UIImageView!
    var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.isScrollEnabled = true
        scrollView.bounces = false
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height * 2)
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        contentView = UIView()
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.right.equalTo(view)
        }
        
        //HEADER
        gymImageView = UIImageView(image: #imageLiteral(resourceName: "Noyes"))
        gymImageView.contentMode = UIViewContentMode.scaleAspectFill
        gymImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(gymImageView)
        
        backButton = UIButton()
        backButton.setImage(#imageLiteral(resourceName: "back-arrow"), for: .normal)
        backButton.sizeToFit()
        contentView.addSubview(backButton)
        
        starButton = UIButton()
        starButton.setImage(#imageLiteral(resourceName: "white-star"), for: .normal)
        starButton.sizeToFit()
        contentView.addSubview(starButton)
        
        titleLabel = UILabel()
        titleLabel.font = ._48Bebas
        titleLabel.textAlignment = .center
        titleLabel.sizeToFit()
        titleLabel.textColor = .white
        titleLabel.text = "NOYES"
        contentView.addSubview(titleLabel)
        
        
        
        setupConstraints()
    }
    
    //MARK: - CONSTRAINTS
    func setupConstraints() {
        gymImageView.snp.updateConstraints{make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(-20)
            make.height.equalTo(360)
        }
        
        backButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(16)
            make.width.equalTo(23)
            make.height.equalTo(19)
        }
        
        starButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-21)
            make.top.equalToSuperview().offset(14)
            make.width.equalTo(23)
            make.height.equalTo(22)
        }
        
        titleLabel.snp.updateConstraints{make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(134)
            make.height.equalTo(57)
        }
    }
}
