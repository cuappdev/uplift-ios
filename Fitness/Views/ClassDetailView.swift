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
    var dateTextView: UITextView!
    var calendarImageView: UIImageView!
    var addToCalButton: UIButton!
    var functionLabel: UILabel!
    var functionDescriptionLabel: UILabel!
    var descriptionTextView: UITextView!
    
    var scrollView: UIScrollView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        scrollView = UIScrollView(frame: frame)
        scrollView.showsVerticalScrollIndicator = true
        scrollView.contentSize = CGSize(width: frame.width, height: 700)
        scrollView.showsVerticalScrollIndicator = false
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
        
        dateTextView = UITextView(frame: CGRect(x: 0, y: 342, width: 280, height: 500))
        /*let attributedString = NSMutableAttributedString(string: "February 28\nWednesday\n10: 30 AM - 11: 30 AM", attributes: [
            .font: UIFont(name: "SanFranciscoDisplay-Regular", size: 14.0)!,
            .foregroundColor: UIColor(white: 43.0 / 255.0, alpha: 1.0),
            .kern: 0.52
            ])
        attributedString.addAttribute(.font, value: UIFont(name: "SanFranciscoDisplay-Bold", size: 18.0)!, range: NSRange(location: 0, length: 11))
        attributedString.addAttribute(.font, value: UIFont(name: "SanFranciscoDisplay-Light", size: 14.0)!, range: NSRange(location: 12, length: 9))*/
        dateTextView.text = """
        February 28
        Wednesday
        10: 30 AM - 11: 30 AM
        """
        dateTextView.font = UIFont(name: "SanFranciscoDisplay-Regular", size: 14)
        dateTextView.textAlignment = .center
        dateTextView.isEditable = false
        dateTextView.sizeToFit()
        dateTextView.center.x = center.x
        scrollView.addSubview(dateTextView)
        
        calendarImageView = UIImageView(frame: CGRect(x: 10, y: 412, width: 23, height: 21))
        calendarImageView.image = UIImage()
        calendarImageView.center.x = center.x
        scrollView.addSubview(calendarImageView)
        
        addToCalButton = UIButton(frame: CGRect(x: 10, y: 438, width: 74, height: 10))
        addToCalButton.titleLabel?.text = "ADD TO CALENDAR"
        addToCalButton.titleLabel?.font = UIFont(name: "SanFranciscoDisplay-Bold", size: 8)
        addToCalButton.center.x = center.x
        scrollView.addSubview(addToCalButton)
        
        functionLabel = UILabel(frame: CGRect(x: 10, y: 485, width: 100, height: 19))
        functionLabel.text = "FUNCITON"
        functionLabel.font = UIFont(name: "SanFranciscoDisplay-Bold", size: 16)
        functionLabel.sizeToFit()
        functionLabel.center.x = center.x
        scrollView.addSubview(functionLabel)
        
        functionDescriptionLabel = UILabel(frame: CGRect(x: 10, y: 511, width: 100, height: 19))
        functionDescriptionLabel.text = "Strength, Core, Cardio"
        functionDescriptionLabel.font = UIFont(name: "SanFranciscoDisplay-Regular", size: 14)
        functionDescriptionLabel.sizeToFit()
        functionDescriptionLabel.center.x = center.x
        scrollView.addSubview(functionDescriptionLabel)
        
        descriptionTextView = UITextView(frame: CGRect(x: 0, y: 568, width: 280, height: 500))
        descriptionTextView.text = "HIGH INTENSITY INTERVAL training (HIIT) has the fitness industry buzzing because of its potential to torch maximum calories in a minimum amount of time. The idea is that you do short periods of all-out work followed by short periods of active rest to make the body work harder."
        descriptionTextView.font = UIFont(name: "SanFranciscoDisplay-Regular", size: 14)
        descriptionTextView.isEditable = false
        descriptionTextView.textAlignment = .center
        descriptionTextView.sizeToFit()
        descriptionTextView.center.x = center.x
        scrollView.addSubview(descriptionTextView)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
