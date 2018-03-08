//
//  ClassDetailView.swift
//  Fitness
//
//  Created by eoin on 3/4/18.
//  Copyright © 2018 Keivan Shahida. All rights reserved.
//

import UIKit
import SnapKit

class ClassDetailView: UIView {
    
    var titleLabel: UILabel!
    var subtitleLabel: UILabel!
    var titleImage: UIImage!
    var titleImageView: UIImageView!
    var dateTextView: UITextView!
    var calendarImageView: UIImageView!
    var addToCalButton: UIButton!
    var functionLabel: UILabel!
    var functionDescriptionLabel: UILabel!
    var descriptionTextView: UITextView!
    var line1: UIView!
    var line2: UIView!
    
    
    var scrollView: UIScrollView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        scrollView = UIScrollView(frame: frame)
        scrollView.showsVerticalScrollIndicator = true
        scrollView.contentSize = CGSize(width: frame.width, height: 700)
        scrollView.showsVerticalScrollIndicator = false
        addSubview(scrollView)
        
        titleImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.width, height: 320))
        titleImage = #imageLiteral(resourceName: "running-sample")
        titleImageView.image = titleImage
        scrollView.addSubview(titleImageView)
        
        titleLabel = UILabel(frame: CGRect(x: 10, y: 126, width: 10, height: 58))
        titleLabel.text = "Urban H.I.I.T "
        titleLabel.font = UIFont(name: "Futura-HeavyOblique", size: 48)
        titleLabel.textColor = .white
        titleLabel.sizeToFit()
        titleLabel.center.x = center.x
        scrollView.addSubview(titleLabel)
        
        subtitleLabel = UILabel(frame: CGRect(x: 10, y: 188, width: 10, height: 10))
        subtitleLabel.text = "Helen Newman Hall"
        subtitleLabel.font = UIFont(name: "SFProDisplay-Light", size: 16)
        subtitleLabel.textColor = .white
        subtitleLabel.sizeToFit()
        subtitleLabel.center.x = center.x
        scrollView.addSubview(subtitleLabel)
        
        let attributedString = NSMutableAttributedString(string: "February 28\nWednesday\n10: 30 AM - 11: 30 AM", attributes: [
            .font: UIFont(name: "SFProDisplay-Regular", size: 14.0)!,
            .foregroundColor: UIColor(white: 43.0 / 255.0, alpha: 1.0),
            .kern: 0.52
            ])
        attributedString.addAttribute(.font, value: UIFont(name: "SFProDisplay-Bold", size: 18.0)!, range: NSRange(location: 0, length: 11))
        attributedString.addAttribute(.font, value: UIFont(name: "SFProDisplay-Light", size: 14.0)!, range: NSRange(location: 12, length: 9))
        
        dateTextView = UITextView(frame: CGRect(x: 0, y: 342, width: 280, height: 500))
        dateTextView.text = attributedString.string
        dateTextView.font = UIFont(name: "SFProDisplay-Regular", size: 14)
        dateTextView.textAlignment = .center
        dateTextView.isEditable = false
        dateTextView.sizeToFit()
        dateTextView.isScrollEnabled = false
        dateTextView.center.x = center.x
        scrollView.addSubview(dateTextView)
        
        calendarImageView = UIImageView(frame: CGRect(x: 10, y: 412, width: 23, height: 21))
        calendarImageView.image = #imageLiteral(resourceName: "calendar-icon")
        calendarImageView.center.x = center.x
        scrollView.addSubview(calendarImageView)
        
        addToCalButton = UIButton(frame: CGRect(x: 10, y: 438, width: 74, height: 10))
        addToCalButton.titleLabel?.text = "ADD TO CALENDAR"
        addToCalButton.titleLabel?.font = UIFont(name: "SFProDisplay-Bold", size: 8)
        addToCalButton.sizeToFit()
        addToCalButton.backgroundColor = .red
        addToCalButton.titleLabel?.textColor = .black
        addToCalButton.center.x = center.x
        scrollView.addSubview(addToCalButton)
        
        functionLabel = UILabel(frame: CGRect(x: 10, y: 485, width: 100, height: 19))
        functionLabel.text = "FUNCITON"
        functionLabel.font = UIFont(name: "SFProDisplay-Bold", size: 16)
        functionLabel.sizeToFit()
        functionLabel.center.x = center.x
        scrollView.addSubview(functionLabel)
        
        functionDescriptionLabel = UILabel(frame: CGRect(x: 10, y: 511, width: 100, height: 19))
        functionDescriptionLabel.text = "Strength, Core, Cardio"
        functionDescriptionLabel.font = UIFont(name: "SFProDisplay-Regular", size: 14)
        functionDescriptionLabel.sizeToFit()
        functionDescriptionLabel.center.x = center.x
        scrollView.addSubview(functionDescriptionLabel)
        
        descriptionTextView = UITextView(frame: CGRect(x: 0, y: 568, width: 280, height: 500))
        descriptionTextView.text = "HIGH INTENSITY INTERVAL training (HIIT) has the fitness industry buzzing because of its potential to torch maximum calories in a minimum amount of time. The idea is that you do short periods of all-out work followed by short periods of active rest to make the body work harder. HIGH INTENSITY INTERVAL training (HIIT) has the fitness industry buzzing because of its potential to torch maximum calories in a minimum amount of time. The idea is that you do short periods of all-out work followed by short periods of active rest to make the body work harder. HIGH INTENSITY INTERVAL training (HIIT) has the fitness industry buzzing because of its potential to torch maximum calories in a minimum amount of time. The idea is that you do short periods of all-out work followed by short periods of active rest to make the body work harder. HIGH INTENSITY INTERVAL training (HIIT) has the fitness industry buzzing because of its potential to torch maximum calories in a minimum amount of time. The idea is that you do short periods of all-out work followed by short periods of active rest to make the body work harder. HIGH INTENSITY INTERVAL training (HIIT) has the fitness industry buzzing because of its potential to torch maximum calories in a minimum amount of time. The idea is that you do short periods of all-out work followed by short periods of active rest to make the body work harder. "
        descriptionTextView.font = UIFont(name: "SFProDisplay-Regular", size: 14)
        descriptionTextView.isEditable = false
        descriptionTextView.textAlignment = .center
        descriptionTextView.sizeToFit()
        descriptionTextView.isScrollEnabled = false
        descriptionTextView.center.x = center.x
        scrollView.addSubview(descriptionTextView)
        
        line1 = UIView(frame: CGRect(x: 2, y: 463, width: 320, height: 2))
        line1.center.x = center.x
        line1.backgroundColor = .gray
        scrollView.addSubview(line1)
        
        line2 = UIView(frame: CGRect(x: 2, y: 547, width: 320, height: 2))
        line2.center.x = center.x
        line2.backgroundColor = .gray
        scrollView.addSubview(line2)
        
        scrollView.contentSize = CGSize(width: frame.width, height: descriptionTextView.frame.maxY)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
