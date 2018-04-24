//
//  ClassDetailView.swift
//  Fitness
//
//  Created by eoin on 3/4/18.
//  Copyright © 2018 Keivan Shahida. All rights reserved.
//

import UIKit
import SnapKit

class ClassDetailViewController: UIViewController {
    
    //MARK: - INITIALIZATION
    var titleLabel: UILabel!
    var locationLabel: UILabel!
    var instructorLabel: UILabel!
    var durationLabel: UILabel!

    var classImageView: UIImageView!
    var imageFilterView: UIView!
    var semicircleView: UIImageView!
    
    var backButton: UIButton!
    var starButton: UIButton!

    var dateLabel: UILabel!
    var timeLabel: UILabel!
    
    var addToCalendarButton: UIButton!
    var addToCalendarLabel: UILabel!

    var functionLabel: UILabel!
    var functionDescriptionLabel: UILabel!
    
    var descriptionTextView: UITextView!
    
    var dateDivider: UIView!
    var functionDivider: UIView!
    
    var scrollView: UIScrollView!
    var contentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.isScrollEnabled = true
        scrollView.bounces = false
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height * 1.9)
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
        classImageView = UIImageView(image: #imageLiteral(resourceName: "running-sample"))
        classImageView.contentMode = UIViewContentMode.scaleAspectFill
        classImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(classImageView)
        
        imageFilterView = UIView()
        imageFilterView.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.6)
        contentView.addSubview(imageFilterView)
        
        semicircleView = UIImageView(image: #imageLiteral(resourceName: "semicircle"))
        semicircleView.contentMode = UIViewContentMode.scaleAspectFit
        semicircleView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(semicircleView)
        
        titleLabel = UILabel()
        titleLabel.text = "MUSCLE PUMP"
        titleLabel.font = ._48Bebas
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        titleLabel.sizeToFit()
        contentView.addSubview(titleLabel)
        
        locationLabel = UILabel()
        locationLabel.text = "Helen Newman Hall Dance Studio"
        locationLabel.font = ._14MontserratLight
        locationLabel.textAlignment = .center
        locationLabel.textColor = .white
        locationLabel.sizeToFit()
        contentView.addSubview(locationLabel)
        
        instructorLabel = UILabel()
        instructorLabel.text = "DEBBIE"
        instructorLabel.font = ._18Bebas
        instructorLabel.textAlignment = .center
        instructorLabel.textColor = .white
        instructorLabel.sizeToFit()
        contentView.addSubview(instructorLabel)
        
        durationLabel = UILabel()
        durationLabel.text = "45 min"
        durationLabel.font = ._18Bebas
        durationLabel.textAlignment = .center
        durationLabel.textColor = .fitnessBlack
        durationLabel.sizeToFit()
        contentView.addSubview(durationLabel)
        
        backButton = UIButton()
        backButton.setImage(#imageLiteral(resourceName: "back-arrow"), for: .normal)
        backButton.sizeToFit()
        contentView.addSubview(backButton)
        
        starButton = UIButton()
        starButton.setImage(#imageLiteral(resourceName: "white-star"), for: .normal)
        starButton.sizeToFit()
        contentView.addSubview(starButton)
        
        //DATE
        dateLabel = UILabel()
        dateLabel.text = "Wednesday, March 15"
        dateLabel.font = ._16MontserratLight
        dateLabel.textAlignment = .center
        dateLabel.textColor = .fitnessBlack
        dateLabel.sizeToFit()
        contentView.addSubview(dateLabel)
        
        timeLabel = UILabel()
        timeLabel.text = "12:15PM - 1:00PM"
        timeLabel.font = ._16MontserratMedium
        timeLabel.textAlignment = .center
        timeLabel.textColor = .fitnessBlack
        timeLabel.sizeToFit()
        contentView.addSubview(timeLabel)
        
        //CALENDAR
        addToCalendarButton = UIButton()
        addToCalendarButton.setImage(#imageLiteral(resourceName: "calendar-icon"), for: .normal) //temp
        addToCalendarButton.sizeToFit()
        contentView.addSubview(addToCalendarButton)
        
        addToCalendarLabel = UILabel()
        addToCalendarLabel.text = "ADD TO CALENDAR"
        addToCalendarLabel.font = ._8SFBold
        addToCalendarLabel.textAlignment = .center
        addToCalendarLabel.textColor = .fitnessBlack
        addToCalendarLabel.sizeToFit()
        contentView.addSubview(addToCalendarLabel)
        
        dateDivider = UIView()
        dateDivider.backgroundColor = .fitnessLightGrey
        contentView.addSubview(dateDivider)
        
        //FUNCTION
        functionLabel = UILabel()
        functionLabel.text = "FUNCTION"
        functionLabel.font = ._16MontserratMedium
        functionLabel.textAlignment = .center
        functionLabel.textColor = .fitnessBlack
        functionLabel.sizeToFit()
        contentView.addSubview(functionLabel)
        
        functionDescriptionLabel = UILabel(frame: CGRect(x: 10, y: 511, width: 100, height: 19))
        functionDescriptionLabel.text = "Core  · Overall Fitness · Stability"
        functionDescriptionLabel.font = ._14MontserratLight
        functionDescriptionLabel.textAlignment = .center
        functionDescriptionLabel.textColor = .fitnessBlack
        functionDescriptionLabel.sizeToFit()
        contentView.addSubview(functionDescriptionLabel)
        
        functionDivider = UIView()
        functionDivider.backgroundColor = .fitnessLightGrey
        contentView.addSubview(functionDivider)
        
        //DESCRIPTION
        descriptionTextView = UITextView()
        descriptionTextView.text = "Put a little muscle into your workout and join us for a class designed to build muscle endurance with low to medium weights and high repetitions. A variety of equipment and strength training techniques will be used in this class. There is no cardio portion in these sessions. Footwear that is appropriate for movement is required for this class. "
        descriptionTextView.font = ._14MontserratLight
        descriptionTextView.isEditable = false
        descriptionTextView.textAlignment = .center
        descriptionTextView.sizeToFit()
        descriptionTextView.isScrollEnabled = false
        contentView.addSubview(descriptionTextView)
        
        setupConstraints()
    }

    
    //MARK: - CONSTRAINTS
    func setupConstraints(){
        //HEADER
        classImageView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalToSuperview().offset(-30)
            make.right.equalToSuperview()
            make.height.equalTo(360)
        }
        
        imageFilterView.snp.makeConstraints { make in
            make.edges.equalTo(classImageView)
        }
        
        semicircleView.snp.makeConstraints { make in
            make.bottom.equalTo(classImageView.snp.bottom)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(100)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalToSuperview().offset(126)
            make.right.equalToSuperview()
            make.height.equalTo(57)
        }
        
        locationLabel.snp.makeConstraints { make in
                make.left.equalToSuperview()
                make.top.equalTo(titleLabel.snp.bottom)
                make.right.equalToSuperview()
                make.height.equalTo(16)
        }
        
        instructorLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(locationLabel.snp.bottom).offset(20)
            make.right.equalToSuperview()
            make.height.equalTo(21)
        }
        
        durationLabel.snp.makeConstraints { make in
            make.bottom.equalTo(classImageView.snp.bottom).offset(-5)
            make.centerX.equalToSuperview()
            make.width.equalTo(50)
            make.height.equalTo(21)
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
        
        //DATE
        dateLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(classImageView.snp.bottom).offset(40)
            make.right.equalToSuperview()
            make.height.equalTo(19)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(dateLabel.snp.bottom).offset(8)
            make.right.equalToSuperview()
            make.height.equalTo(19)
        }
        
        //CALENDAR
        addToCalendarButton.snp.makeConstraints { make in
            make.height.equalTo(23)
            make.width.equalTo(23)
            make.centerX.equalToSuperview()
            make.top.equalTo(timeLabel.snp.bottom).offset(26)
        }
        
        addToCalendarLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(addToCalendarButton.snp.bottom).offset(5)
            make.right.equalToSuperview()
            make.height.equalTo(10)
        }
        
        dateDivider.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(addToCalendarLabel.snp.bottom).offset(36)
        }
        
        //FUNCTION
        functionLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(dateDivider.snp.bottom).offset(20)
            make.right.equalToSuperview()
            make.height.equalTo(19)
        }
        
        functionDescriptionLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(functionLabel.snp.bottom).offset(12)
            make.right.equalToSuperview()
            make.height.equalTo(20)
        }
        
        functionDivider.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(functionDescriptionLabel.snp.bottom).offset(32)
        }
        
        //DESCRIPTION
        descriptionTextView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().offset(-40)
            make.top.equalTo(functionDivider.snp.bottom).offset(36)
        }
    }
}
