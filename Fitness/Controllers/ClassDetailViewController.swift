//
//  ClassDetailView.swift
//  Fitness
//
//  Created by eoin on 3/4/18.
//  Copyright © 2018 Keivan Shahida. All rights reserved.
//

import UIKit
import SnapKit

class ClassDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - INITIALIZATION
    var gymClassInstance: GymClassInstance!
    
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
    var date: Date!
    
    var addToCalendarButton: UIButton!
    var addToCalendarLabel: UILabel!

    var functionLabel: UILabel!
    var functionDescriptionLabel: UILabel!
    
    var descriptionTextView: UITextView!
    
    var dateDivider: UIView!
    var functionDivider: UIView!
    
    var scrollView: UIScrollView!
    var contentView: UIView!
    
    var nextSessionsLabel: UILabel!
    var tableView: UITableView!
    var nextSessions = [GymClassInstance]()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        durationLabel = UILabel()
        locationLabel = UILabel()
        dateLabel = UILabel()
        timeLabel = UILabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController!.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        var upcomingInstanceIds: [Int] = []
        
        for gymClassId in gymClassInstance.classDescription.gymClasses {
            AppDelegate.networkManager.getGymClass(gymClassId: gymClassId) { gymClass in
                
                for instanceId in gymClass.gymClassInstances{
                    if(!upcomingInstanceIds.contains(instanceId)){
                        upcomingInstanceIds.append(instanceId)
                    }
                }
                self.getUpcomingInstances(upcomingInstanceIds: upcomingInstanceIds)
            }
        }
        
        scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.isScrollEnabled = true
        scrollView.bounces = false
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height * 2.1)
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        contentView = UIView()
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.top.equalToSuperview()
            make.bottom.equalTo(view.snp.bottom)
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
        titleLabel.text = gymClassInstance.classDescription.name
        titleLabel.font = ._48Bebas
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        titleLabel.sizeToFit()
        contentView.addSubview(titleLabel)
        
        locationLabel.font = ._14MontserratLight
        locationLabel.textAlignment = .center
        locationLabel.textColor = .white
        locationLabel.sizeToFit()
        contentView.addSubview(locationLabel)
        
        instructorLabel = UILabel()
        instructorLabel.text = gymClassInstance.instructor.name
        instructorLabel.font = ._18Bebas
        instructorLabel.textAlignment = .center
        instructorLabel.textColor = .white
        instructorLabel.sizeToFit()
        contentView.addSubview(instructorLabel)
        
        durationLabel.font = ._18Bebas
        durationLabel.textAlignment = .center
        durationLabel.textColor = .fitnessBlack
        durationLabel.sizeToFit()
        contentView.addSubview(durationLabel)
        
        backButton = UIButton()
        backButton.setImage(#imageLiteral(resourceName: "back-arrow"), for: .normal)
        backButton.sizeToFit()
        backButton.addTarget(self, action: #selector(self.back), for: .touchUpInside)
        contentView.addSubview(backButton)
        
        starButton = UIButton()
        starButton.setImage(#imageLiteral(resourceName: "white-star"), for: .normal)
        starButton.sizeToFit()
        starButton.addTarget(self, action: #selector(self.favorite), for: .touchUpInside)
        contentView.addSubview(starButton)
        
        //DATE
        dateLabel.font = ._16MontserratLight
        dateLabel.textAlignment = .center
        dateLabel.textColor = .fitnessBlack
        dateLabel.sizeToFit()
        contentView.addSubview(dateLabel)
        
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
        descriptionTextView.text = gymClassInstance.classDescription.description
        descriptionTextView.font = ._14MontserratLight
        descriptionTextView.isEditable = false
        descriptionTextView.textAlignment = .center
        descriptionTextView.sizeToFit()
        descriptionTextView.isScrollEnabled = false
        contentView.addSubview(descriptionTextView)
        
        //NEXT SESSIONS
        nextSessionsLabel = UILabel()
        nextSessionsLabel.font = ._12LatoBlack
        nextSessionsLabel.textColor = .fitnessDarkGrey
        nextSessionsLabel.text = "NEXT SESSIONS"
        nextSessionsLabel.textAlignment = .center
        nextSessionsLabel.sizeToFit()
        contentView.addSubview(nextSessionsLabel)
        
        tableView = UITableView(frame: .zero, style: .grouped)
        tableView.separatorStyle = .none
        tableView.bounces = false
        tableView.showsVerticalScrollIndicator = false
        tableView.isScrollEnabled = false
        tableView.backgroundColor = .white
        tableView.clipsToBounds = false
        
        tableView.register(ClassListCell.self, forCellReuseIdentifier: "classListCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        contentView.addSubview(tableView)
        
        setupConstraints()
    }

    func getUpcomingInstances(upcomingInstanceIds: [Int]) {
        for instanceId in upcomingInstanceIds{
            AppDelegate.networkManager.getGymClassInstance(gymClassInstanceId: instanceId) { (gymClassInstance) in
                self.nextSessions.append(gymClassInstance)
                
            }
            
        }
        
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
        
        //NEXT SESSIONS
        nextSessionsLabel.snp.updateConstraints{make in
            make.centerX.equalToSuperview()
            make.top.equalTo(descriptionTextView.snp.bottom).offset(64)
            make.height.equalTo(15)
        }
        
        tableView.snp.updateConstraints{make in
            make.left.right.equalToSuperview()
            make.top.equalTo(nextSessionsLabel.snp.bottom).offset(32)
            make.height.equalTo(tableView.numberOfRows(inSection: 0) * 112)
        }
        
        var height = 764 + descriptionTextView.frame.height + 111
        height += CGFloat(tableView.numberOfRows(inSection: 0)*112 + 110)
        scrollView.contentSize = CGSize(width: view.frame.width, height: CGFloat(height))
    }
    
    //MARK: - BUTTON METHODS
    @objc func back() {
        navigationController!.popViewController(animated: true)
    }
    
    @objc func favorite(){
        print("favorite")
    }
    
    //MARK: - TABLE VIEW METHODS
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5    //temporary
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "classListCell", for: indexPath) as! ClassListCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 112
    }
}
