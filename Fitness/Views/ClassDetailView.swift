//
//  ClassDetailView.swift
//  Fitness
//
//  Created by eoin on 3/4/18.
//  Copyright © 2018 Keivan Shahida. All rights reserved.
//

import UIKit

class ClassDetailView: UIView {
    
    var titleLabel: UILabel!
    var subtitleLabel: UILabel!
    var titleImage: UIImage?
    var titleImageView: UIImageView!
    var descriptionTextView: UITextView!
    
    var scrollView: UIScrollView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        scrollView = UIScrollView(frame: frame)
        scrollView.showsVerticalScrollIndicator = true
        scrollView.contentSize = CGSize(width: frame.width, height: 700)
        addSubview(scrollView)

        titleLabel = UILabel(frame: CGRect(x: 10, y: 126, width: 10, height: 58))
        titleLabel.text = "Urban H.I.I.T"
        titleLabel.font = UIFont(name: "FuturaBT-BoldItalic", size: 48)
        titleLabel.sizeToFit()
        titleLabel.center.x = center.x
        scrollView.addSubview(titleLabel)
        
        subtitleLabel = UILabel(frame: CGRect(x: 10, y: 188, width: 10, height: 10))
        subtitleLabel.text = "Helen Newman Hall"
        subtitleLabel.font = UIFont(name: "SanFranciscoDisplay-Light", size: 16)
        subtitleLabel.sizeToFit()
        subtitleLabel.center.x = center.x
        scrollView.addSubview(subtitleLabel)
        
        titleImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.width, height: 320))
        titleImageView.image = titleImage
        scrollView.addSubview(titleImageView)
        
        descriptionTextView = UITextView(frame: CGRect(x: 0, y: 515, width: 280, height: 500))
        descriptionTextView.text = "HIGH INTENSITY INTERVAL training (HIIT) has the fitness industry buzzing because of its potential to torch maximum calories in a minimum amount of time. The idea is that you do short periods of all-out work followed by short periods of active rest to make the body work harder."
        descriptionTextView.font = UIFont(name: "SanFranciscoDisplay-Regular", size: 14)
        //descriptionTextView.font?.lineHeight = 18
        descriptionTextView.isEditable = false
        descriptionTextView.sizeToFit()
        descriptionTextView.center.x = center.x        
        scrollView.addSubview(descriptionTextView)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
