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
    
    var titleLabel: UILabel!
    var locationLabel: UILabel!
    
    var classImageView: UIImageView!
    var imageFilterView: UIView!

    var monthLabel: UILabel!
    var dayLabel: UILabel!
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
    
    //MARK: - INITIALIZATION
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.isScrollEnabled = true
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height * 2)
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        contentView = UIView()
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.top.equalTo(scrollView)
            make.left.right.equalTo(view)
        }
        
        //HEADER
        classImageView = UIImageView(image: #imageLiteral(resourceName: "running-sample"))
        classImageView.contentMode = UIViewContentMode.scaleAspectFill
        contentView.addSubview(classImageView)
        
        imageFilterView = UIView()
        imageFilterView.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.5)
        contentView.addSubview(imageFilterView)
        
        titleLabel = UILabel()
        titleLabel.text = "Urban H.I.I.T"
        titleLabel.font = UIFont(name: "Futura-HeavyOblique", size: 48)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        titleLabel.sizeToFit()
        contentView.addSubview(titleLabel)
        
        locationLabel = UILabel()
        locationLabel.text = "HELEN NEWMAN HALL"
        locationLabel.font = ._16SFLight
        locationLabel.textAlignment = .center
        locationLabel.textColor = .white
        locationLabel.sizeToFit()
        contentView.addSubview(locationLabel)
        
        //DATE
        monthLabel = UILabel()
        monthLabel.text = "FEBRUARY 28"
        monthLabel.font = ._18SFBold
        monthLabel.textAlignment = .center
        monthLabel.textColor = .fitnessBlack
        monthLabel.sizeToFit()
        contentView.addSubview(monthLabel)
        
        dayLabel = UILabel()
        dayLabel.text = "Wednesday"
        dayLabel.font = ._14SFLight
        dayLabel.textAlignment = .center
        dayLabel.textColor = .fitnessBlack
        dayLabel.sizeToFit()
        contentView.addSubview(dayLabel)
        
        timeLabel = UILabel()
        timeLabel.text = "10:30 AM - 11:30 AM"
        timeLabel.font = ._14SFRegular
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
        functionLabel.font = ._16SFBold
        functionLabel.textAlignment = .center
        functionLabel.textColor = .fitnessBlack
        functionLabel.sizeToFit()
        contentView.addSubview(functionLabel)
        
        functionDescriptionLabel = UILabel(frame: CGRect(x: 10, y: 511, width: 100, height: 19))
        functionDescriptionLabel.text = "Strength, Core, Cardio"
        functionDescriptionLabel.font = ._14SFRegular
        functionDescriptionLabel.textAlignment = .center
        functionDescriptionLabel.textColor = .fitnessBlack
        functionDescriptionLabel.sizeToFit()
        contentView.addSubview(functionDescriptionLabel)
        
        functionDivider = UIView()
        functionDivider.backgroundColor = .fitnessLightGrey
        contentView.addSubview(functionDivider)
        
        //DESCRIPTION
        descriptionTextView = UITextView()
        descriptionTextView.text = "HIGH INTENSITY INTERVAL training (HIIT) has the fitness industry buzzing because of its potential to torch maximum calories in a minimum amount of time. The idea is that you do short periods of all-out work followed by short periods of active rest to make the body work harder. HIGH INTENSITY INTERVAL training (HIIT) has the fitness industry buzzing because of its potential to torch maximum calories in a minimum amount of time. The idea is that you do short periods of all-out work followed by short periods of active rest to make the body work harder. HIGH INTENSITY INTERVAL training (HIIT) has the fitness industry buzzing because of its potential to torch maximum calories in a minimum amount of time. The idea is that you do short periods of all-out work followed by short periods of active rest to make the body work harder. HIGH INTENSITY INTERVAL training (HIIT) has the fitness industry buzzing because of its potential to torch maximum calories in a minimum amount of time. The idea is that you do short periods of all-out work followed by short periods of active rest to make the body work harder. HIGH INTENSITY INTERVAL training (HIIT) has the fitness industry buzzing because of its potential to torch maximum calories in a minimum amount of time. The idea is that you do short periods of all-out work followed by short periods of active rest to make the body work harder. "
        descriptionTextView.font = ._14SFRegular
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
            make.top.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(320)
        }
        
        imageFilterView.snp.makeConstraints { make in
            make.edges.equalTo(classImageView)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalToSuperview().offset(126)
            make.right.equalToSuperview()
            make.height.equalTo(58)
        }
        
        locationLabel.snp.makeConstraints { make in
                make.left.equalToSuperview()
                make.top.equalTo(titleLabel.snp.bottom)
                make.right.equalToSuperview()
                make.height.equalTo(19)
        }
        
        //DATE
        monthLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(classImageView.snp.bottom).offset(22)
            make.right.equalToSuperview()
            make.height.equalTo(21)
        }
        
        dayLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(monthLabel.snp.bottom)
            make.right.equalToSuperview()
            make.height.equalTo(16)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(dayLabel.snp.bottom)
            make.right.equalToSuperview()
            make.height.equalTo(16)
        }
        
        //CALENDAR
        addToCalendarButton.snp.makeConstraints { make in
            make.height.equalTo(23)
            make.width.equalTo(23)
            make.centerX.equalToSuperview()
            make.top.equalTo(timeLabel.snp.bottom).offset(17)
        }
        
        addToCalendarLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(addToCalendarButton.snp.bottom).offset(5)
            make.right.equalToSuperview()
            make.height.equalTo(10)
        }
        
        dateDivider.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.top.equalTo(addToCalendarLabel.snp.bottom).offset(15)
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
            make.top.equalTo(functionLabel.snp.bottom).offset(7)
            make.right.equalToSuperview()
            make.height.equalTo(16)
        }
        
        functionDivider.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.top.equalTo(functionDescriptionLabel.snp.bottom).offset(20)
        }
        
        //DESCRIPTION
        
        descriptionTextView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(48)
            make.right.equalToSuperview().offset(-48)
            make.top.equalTo(functionDivider.snp.bottom).offset(20)
        }
    }
}
