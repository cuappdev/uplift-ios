//
//  FilterViewController.swift
//  Fitness
//
//  Created by Joseph Fulgieri on 4/2/18.
//  Copyright © 2018 Keivan Shahida. All rights reserved.
//

import UIKit
import SnapKit
import WARangeSlider

class FilterViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    // MARK: - INITIALIZATION
    var scrollView: UIScrollView!
    var contentView: UIView!
    
    var collectionViewTitle: UILabel!
    var collectionView: UICollectionView!
    
    var fitnesscenterStarttimeDivider: UIView!
    var startTimeLabel: UILabel!
    var startTime: UILabel!
    var startTimeSlider: RangeSlider!
    var starttimeClasstypeDivider: UIView!
    
    var classTypeDropdown: FilterDropdownView!
    var classtypeInstructorDivider: UIView!
    
    var instructorDropDown: FilterDropdownView!
    var instructorDivider: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        //NAVIGATION BAR
        let titleView = UILabel()
        titleView.text = "Refine Search"
        titleView.font = ._14LatoBlack
        self.navigationItem.titleView = titleView
        
        let doneBarButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(done))
        doneBarButton.tintColor = .fitnessBlack
        self.navigationItem.rightBarButtonItem = doneBarButton
        
        let resetBarButton = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(reset))
        resetBarButton.tintColor = .fitnessBlack
        self.navigationItem.leftBarButtonItem = resetBarButton
        
        tabBarController!.tabBar.isHidden = true
        
        //SCROLL VIEW
        scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.isScrollEnabled = true
        scrollView.bounces = false
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height * 1.5)
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        contentView = UIView()
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints {make in
            make.top.equalTo(view.snp.top).offset(navigationController!.navigationBar.frame.height + UIApplication.shared.statusBarFrame.size.height)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.bottom.equalTo(view.snp.bottom)
        }
        
        //COLLECTION VIEW
        collectionViewTitle = UILabel()
        collectionViewTitle.font = ._12LatoBlack
        collectionViewTitle.textColor = .fitnessDarkGrey
        collectionViewTitle.text = "FITNESS CENTER"
        contentView.addSubview(collectionViewTitle)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0 )
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 0
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .fitnessLightGrey
        collectionView.isScrollEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.bounces = false
        collectionView.register(GymFilterCell.self , forCellWithReuseIdentifier: "gymFilterCell")
        contentView.addSubview(collectionView)
        
        //START TIME SLIDER SECTION
        fitnesscenterStarttimeDivider = UIView()
        fitnesscenterStarttimeDivider.backgroundColor = .fitnessLightGrey
        contentView.addSubview(fitnesscenterStarttimeDivider)
        
        startTimeLabel = UILabel()
        startTimeLabel.sizeToFit()
        startTimeLabel.font = ._12LatoBlack
        startTimeLabel.textColor = .fitnessDarkGrey
        startTimeLabel.text = "START TIME"
        contentView.addSubview(startTimeLabel)
        
        startTime = UILabel()
        startTime.sizeToFit()
        startTime.font = ._12LatoBlack
        startTime.textColor = .fitnessDarkGrey
        startTime.text = "6:00 AM - 10:00 PM"
        contentView.addSubview(startTime)
        
        startTimeSlider = RangeSlider(frame: .zero)
        startTimeSlider.minimumValue = 0.0
        startTimeSlider.maximumValue = 960
        startTimeSlider.lowerValue = 0.0
        startTimeSlider.upperValue = 960        //960 minutes btwn 6 am and 10 pm
        startTimeSlider.trackTintColor = .fitnessLightGrey
        startTimeSlider.trackHighlightTintColor = .fitnessYellow
        startTimeSlider.thumbBorderColor = .fitnessLightGrey
        startTimeSlider.addTarget(self, action: #selector(startTimeChanged),
                              for: .valueChanged)
        contentView.addSubview(startTimeSlider)
        
        starttimeClasstypeDivider = UIView()
        starttimeClasstypeDivider.backgroundColor = .fitnessLightGrey
        contentView.addSubview(starttimeClasstypeDivider)
        
        //CLASS TYPE SECTION
        classTypeDropdown = FilterDropdownView(frame: .zero)
        classTypeDropdown.titleLabel.text = "CLASS TYPE"
        classTypeDropdown.delegate = self
        contentView.addSubview(classTypeDropdown)
        
        classtypeInstructorDivider = UIView()
        classtypeInstructorDivider.backgroundColor = .fitnessLightGrey
        contentView.addSubview(classtypeInstructorDivider)
        
        //INSTRUCTOR SECTION
        instructorDropDown = FilterDropdownView(frame: .zero)
        instructorDropDown.titleLabel.text = "INSTRUCTOR"
        instructorDropDown.delegate = self
        contentView.addSubview(instructorDropDown)
        
        instructorDivider = UIView()
        instructorDivider.backgroundColor = .fitnessLightGrey
        contentView.addSubview(instructorDivider)
        
        setupConstraints()
    }
    
    // MARK: - CONSTRAINTS
    func setupConstraints() {
        //COLLECTION VIEW SECTION
        collectionViewTitle.snp.updateConstraints{make in
            make.left.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(20)
            make.bottom.equalTo(collectionViewTitle.snp.top).offset(15)
        }
        
        collectionView.snp.updateConstraints{make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview().offset(51)
            make.bottom.equalTo(collectionViewTitle.snp.bottom).offset(44)
        }
        
        //SLIDER SECTION
        fitnesscenterStarttimeDivider.snp.updateConstraints{make in
            make.top.equalTo(collectionView.snp.bottom).offset(16)
            make.bottom.equalTo(collectionView.snp.bottom).offset(17)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        startTimeLabel.snp.updateConstraints{make in
            make.left.equalToSuperview().offset(16)
            make.top.equalTo(fitnesscenterStarttimeDivider.snp.bottom).offset(20)
            make.bottom.equalTo(fitnesscenterStarttimeDivider.snp.bottom).offset(35)
        }
        
        startTime.snp.updateConstraints{make in
            make.right.equalToSuperview().offset(-22)
            make.top.equalTo(fitnesscenterStarttimeDivider.snp.bottom).offset(20)
            make.bottom.equalTo(fitnesscenterStarttimeDivider.snp.bottom).offset(36)
        }
        
        startTimeSlider.snp.updateConstraints{make in
            make.right.equalToSuperview().offset(-16)
            make.left.equalToSuperview().offset(16)
            make.top.equalTo(fitnesscenterStarttimeDivider.snp.bottom).offset(47)
            make.bottom.equalTo(fitnesscenterStarttimeDivider.snp.bottom).offset(71)
        }
        
        starttimeClasstypeDivider.snp.updateConstraints{make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.top.equalTo(fitnesscenterStarttimeDivider.snp.bottom).offset(90)
            make.bottom.equalTo(fitnesscenterStarttimeDivider.snp.bottom).offset(91)
        }
        
        //CLASS TYPE SECTION
        classTypeDropdown.snp.updateConstraints{make in
            make.top.equalTo(starttimeClasstypeDivider.snp.bottom)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            
            if (classTypeDropdown.isDropped == .up){
                make.bottom.equalTo(starttimeClasstypeDivider.snp.bottom).offset(55)
            }else if (classTypeDropdown.isDropped == .halfDropped){
                make.bottom.equalTo(starttimeClasstypeDivider.snp.bottom).offset(55 + 4*32)
            } else {
                make.bottom.equalTo(starttimeClasstypeDivider.snp.bottom).offset(55 + classTypeDropdown.cells.count*32)
            }
            
            classTypeDropdown.setupConstraints()
        }
        
        classtypeInstructorDivider.snp.updateConstraints{make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.top.equalTo(classTypeDropdown.snp.bottom)
            make.bottom.equalTo(classTypeDropdown.snp.bottom).offset(1)
        }
        
        //INSTRUCTOR SECTION
        instructorDropDown.snp.updateConstraints{make in
            make.top.equalTo(classtypeInstructorDivider.snp.bottom)
            make.right.equalToSuperview()
            make.left.equalToSuperview()
            
            if (instructorDropDown.isDropped == .up){
                make.bottom.equalTo(classtypeInstructorDivider.snp.bottom).offset(55)
            }else if (instructorDropDown.isDropped == .halfDropped){
                make.bottom.equalTo(classtypeInstructorDivider.snp.bottom).offset(55 + 4*32)
            } else {
                make.bottom.equalTo(classtypeInstructorDivider.snp.bottom).offset(55 + instructorDropDown.cells.count*32)
            }
            
            instructorDropDown.setupConstraints()
        }
        
        instructorDivider.snp.updateConstraints{make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.top.equalTo(instructorDropDown.snp.bottom)
            make.bottom.equalTo(instructorDropDown.snp.bottom).offset(1)
        }
    }
    
    //NAVIGATION BAR BUTTONS
    @objc func done(){
        navigationController?.popViewController(animated: true)
    }

    @objc func reset(){
        startTime.text = "6:00 AM - 10:00 PM"
        startTimeSlider.lowerValue = 0.0
        startTimeSlider.upperValue = 960.0
        print("reset!")
    }
    
    //SLIDER CHANGED
    @objc func startTimeChanged() {
        print("update time")
        let lowerSliderVal = startTimeSlider.lowerValue + 360
        let upperSliderVal = startTimeSlider.upperValue + 360
        
        var lowerHours = Int(lowerSliderVal/60)
        let lowerMinutes = Int(lowerSliderVal)%60
        var upperHours = Int(upperSliderVal/60)
        let upperMinutes = Int(upperSliderVal)%60
        
        if lowerHours > 12{
            upperHours -= 12
            lowerHours -= 12
            startTime.text = (String(lowerHours) + ":" + String(format: "%02d", lowerMinutes) + " PM - " + String(upperHours) + ":" + String(format: "%02d", upperMinutes) + " PM")
        }else if (upperHours < 12){
            startTime.text = (String(lowerHours) + ":" + String(format: "%02d", lowerMinutes) + " AM - " + String(upperHours) + ":" + String(format: "%02d", upperMinutes) + " AM")
        } else {
            upperHours -= 12
            startTime.text = (String(lowerHours) + ":" + String(format: "%02d", lowerMinutes) + " AM - " + String(upperHours) + ":" + String(format: "%02d", upperMinutes) + " PM")
        }
    }
    
    //COLLECTION VIEW METHODS
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gymFilterCell", for: indexPath) as! GymFilterCell
        
        switch indexPath.row {
        case 0:
            cell.gymName.text = "Teagle"
        case 1:
            cell.gymName.text = "Appel"
        case 2:
            cell.gymName.text = "Helen Newman"
        case 3:
            cell.gymName.text = "Noyes"
        default:
            cell.gymName.text = "Gates"
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var offset = CGFloat(0)
        if (view.frame.width > 360){
            offset = (view.frame.width - 360)/4
        }
        
        switch indexPath.row {
        case 0:
            return CGSize(width: 74 + offset, height: 28)
        case 1:
            return CGSize(width: 70 + offset, height: 28)
        case 2:
            return CGSize(width: 138 + offset, height: 28)
        case 3:
            return CGSize(width: 72 + offset, height: 28)
        default:
            return CGSize(width: 150 + offset, height: 28)
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
}
