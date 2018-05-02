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

enum Dropped {
    case up, half, down
}

struct DropdownData {
    var dropStatus: Dropped!
    var titles: [String]!
    var ids: [Int]!
    var completed: Bool!
}

class FilterViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource {

    // MARK: - INITIALIZATION
    var scrollView: UIScrollView!
    var contentView: UIView!

    var collectionViewTitle: UILabel!
    var gymCollectionView: UICollectionView!
    var gyms: [Gym]!
    var selectedGyms: [Int]!

    var fitnessCenterStartTimeDivider: UIView!
    var startTimeTitleLabel: UILabel!
    var startTimeLabel: UILabel!
    var startTimeSlider: RangeSlider!
    var startTimeClassTypeDivider: UIView!
    var startTime: String!
    var endTime: String!

    var classTypeDropdown: UITableView!
    var classTypeDropdownData: DropdownData!
    var classTypeInstructorDivider: UIView!
    var selectedClasses: [Int]!

    var instructorDropdown: UITableView!
    var instructorDropdownData: DropdownData!
    var instructorDivider: UIView!
    var selectedInstructors: [Int]!

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

        //SCROLL VIEW
        scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.isScrollEnabled = true
        scrollView.bounces = false
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height * 2.5)
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        contentView = UIView()
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints {make in
            make.left.right.equalTo(view)
            make.top.equalToSuperview()
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

        gymCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        gymCollectionView.allowsMultipleSelection = true
        gymCollectionView.backgroundColor = .fitnessLightGrey
        gymCollectionView.isScrollEnabled = true
        gymCollectionView.showsHorizontalScrollIndicator = false
        gymCollectionView.bounces = false
        
        gymCollectionView.delegate = self
        gymCollectionView.dataSource = self
        gymCollectionView.register(GymFilterCell.self , forCellWithReuseIdentifier: "gymFilterCell")
        contentView.addSubview(gymCollectionView)
        
        selectedGyms = []
        
        gyms = []
        
        AppDelegate.networkManager.getGyms { (gyms) in
            self.gyms = gyms
            
            self.gymCollectionView.reloadData()
        }

        //START TIME SLIDER SECTION
        fitnessCenterStartTimeDivider = UIView()
        fitnessCenterStartTimeDivider.backgroundColor = .fitnessLightGrey
        contentView.addSubview(fitnessCenterStartTimeDivider)

        startTimeTitleLabel = UILabel()
        startTimeTitleLabel.sizeToFit()
        startTimeTitleLabel.font = ._12LatoBlack
        startTimeTitleLabel.textColor = .fitnessDarkGrey
        startTimeTitleLabel.text = "START TIME"
        contentView.addSubview(startTimeTitleLabel)

        startTimeLabel = UILabel()
        startTimeLabel.sizeToFit()
        startTimeLabel.font = ._12LatoBlack
        startTimeLabel.textColor = .fitnessDarkGrey
        startTimeLabel.text = "6:00 AM - 10:00 PM"
        contentView.addSubview(startTimeLabel)
        
        startTime = "6:00AM"
        endTime = "10:00PM"

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

        startTimeClassTypeDivider = UIView()
        startTimeClassTypeDivider.backgroundColor = .fitnessLightGrey
        contentView.addSubview(startTimeClassTypeDivider)

        //CLASS TYPE SECTION
        classTypeDropdown = UITableView(frame: .zero, style: .grouped)
        classTypeDropdown.separatorStyle = .none
        classTypeDropdown.showsVerticalScrollIndicator = false
        classTypeDropdown.bounces = false

        classTypeDropdown.register(DropdownViewCell.self, forCellReuseIdentifier: "dropdownViewCell")
        classTypeDropdown.register(DropdownHeaderView.self, forHeaderFooterViewReuseIdentifier: "dropdownHeaderView")
        classTypeDropdown.register(DropdownFooterView.self, forHeaderFooterViewReuseIdentifier: "dropdownFooterView")

        classTypeDropdown.delegate = self
        classTypeDropdown.dataSource = self
        contentView.addSubview(classTypeDropdown)

        classTypeInstructorDivider = UIView()
        classTypeInstructorDivider.backgroundColor = .fitnessLightGrey
        contentView.addSubview(classTypeInstructorDivider)
        
        selectedClasses = []
        
        classTypeDropdownData = DropdownData(dropStatus: .up, titles: [], ids: [], completed: false)
        
        AppDelegate.networkManager.getGymClassDescriptions { (gymClassDescriptions) in
            
            for gymClassDescription in gymClassDescriptions{
                self.classTypeDropdownData.titles.append(gymClassDescription.name)
                self.classTypeDropdownData.ids.append(gymClassDescription.id)
            }
            
            self.classTypeDropdownData.completed = true
            self.classTypeDropdown.reloadData()
            self.setupConstraints()
        }
        
        //INSTRUCTOR SECTION
        instructorDropdown = UITableView(frame: .zero, style: .grouped)
        instructorDropdown.separatorStyle = .none
        instructorDropdown.bounces = false
        instructorDropdown.showsVerticalScrollIndicator = false

        instructorDropdown.register(DropdownViewCell.self, forCellReuseIdentifier: "dropdownViewCell")
        instructorDropdown.register(DropdownHeaderView.self, forHeaderFooterViewReuseIdentifier: "dropdownHeaderView")
        instructorDropdown.register(DropdownFooterView.self, forHeaderFooterViewReuseIdentifier: "dropdownFooterView")

        instructorDropdown.delegate = self
        instructorDropdown.dataSource = self
        contentView.addSubview(instructorDropdown)

        instructorDivider = UIView()
        instructorDivider.backgroundColor = .fitnessLightGrey
        contentView.addSubview(instructorDivider)
        
        selectedInstructors = []
        instructorDropdownData = DropdownData(dropStatus: .up, titles: [], ids: [],  completed: false)
        
        AppDelegate.networkManager.getInstructors { (instructors) in
            for instructor in instructors{
                self.instructorDropdownData.titles.append(instructor.name)
                self.instructorDropdownData.ids.append(instructor.id)
            }
            
            self.instructorDropdownData.completed = true
            self.instructorDropdown.reloadData()
            self.setupConstraints()
        }

        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController!.tabBar.isHidden = true
    }

    // MARK: - CONSTRAINTS
    func setupConstraints() {
        //COLLECTION VIEW SECTION
        collectionViewTitle.snp.updateConstraints{make in
            make.left.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(20)
            make.bottom.equalTo(collectionViewTitle.snp.top).offset(15)
        }

        gymCollectionView.snp.updateConstraints{make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(51)
            make.bottom.equalTo(collectionViewTitle.snp.bottom).offset(47)
        }

        //SLIDER SECTION
        fitnessCenterStartTimeDivider.snp.updateConstraints{make in
            make.top.equalTo(gymCollectionView.snp.bottom).offset(16)
            make.bottom.equalTo(gymCollectionView.snp.bottom).offset(17)
            make.width.centerX.equalToSuperview()
        }

        startTimeTitleLabel.snp.updateConstraints{make in
            make.left.equalToSuperview().offset(16)
            make.top.equalTo(fitnessCenterStartTimeDivider.snp.bottom).offset(20)
            make.bottom.equalTo(fitnessCenterStartTimeDivider.snp.bottom).offset(35)
        }

        startTimeLabel.snp.updateConstraints{make in
            make.right.equalToSuperview().offset(-22)
            make.top.equalTo(fitnessCenterStartTimeDivider.snp.bottom).offset(20)
            make.bottom.equalTo(fitnessCenterStartTimeDivider.snp.bottom).offset(36)
        }

        startTimeSlider.snp.updateConstraints{make in
            make.right.equalToSuperview().offset(-16)
            make.left.equalToSuperview().offset(16)
            make.top.equalTo(fitnessCenterStartTimeDivider.snp.bottom).offset(47)
            make.bottom.equalTo(fitnessCenterStartTimeDivider.snp.bottom).offset(71)
        }

        startTimeClassTypeDivider.snp.updateConstraints{make in
            make.width.centerX.equalToSuperview()
            make.top.equalTo(fitnessCenterStartTimeDivider.snp.bottom).offset(90)
            make.bottom.equalTo(fitnessCenterStartTimeDivider.snp.bottom).offset(91)
        }

        //CLASS TYPE SECTION
        classTypeDropdown.snp.updateConstraints{make in
            make.top.equalTo(startTimeClassTypeDivider.snp.bottom)
            make.left.right.equalToSuperview()

            switch classTypeDropdownData.dropStatus{
            case .up:
                make.bottom.equalTo(startTimeClassTypeDivider.snp.bottom).offset(55)
            case .half:
                make.bottom.equalTo(startTimeClassTypeDivider.snp.bottom).offset(55 + 32 + 3*32)
            case .down:
                make.bottom.equalTo(startTimeClassTypeDivider.snp.bottom).offset(55 + 32 + classTypeDropdown.numberOfRows(inSection: 0)*32)
            default:
                make.bottom.equalTo(startTimeClassTypeDivider.snp.bottom).offset(55)
            }
        }

        classTypeInstructorDivider.snp.updateConstraints{make in
            make.width.centerX.equalToSuperview()
            make.top.equalTo(classTypeDropdown.snp.bottom)
            make.bottom.equalTo(classTypeDropdown.snp.bottom).offset(1)
        }

        //INSTRUCTOR SECTION
        instructorDropdown.snp.updateConstraints{make in
            make.top.equalTo(classTypeInstructorDivider.snp.bottom)
            make.left.right.equalToSuperview()

            switch instructorDropdownData.dropStatus{
            case .up:
                make.bottom.equalTo(classTypeInstructorDivider.snp.bottom).offset(55)
            case .half:
                make.bottom.equalTo(classTypeInstructorDivider.snp.bottom).offset(55 + 32 + 3*32)
            case .down:
                make.bottom.equalTo(classTypeInstructorDivider.snp.bottom).offset(55 + 32 + instructorDropdown.numberOfRows(inSection: 0)*32)
            default:
                make.bottom.equalTo(classTypeInstructorDivider.snp.bottom).offset(55)
            }
        }

        instructorDivider.snp.updateConstraints{make in
            make.width.centerX.equalToSuperview()
            make.top.equalTo(instructorDropdown.snp.bottom)
            make.bottom.equalTo(instructorDropdown.snp.bottom).offset(1)
        }
        
        //THIS MUST BE CHANGED IF ANY OF THE SCREEN'S HARD-CODED HEIGHTS ARE ALTERED
        var classHeight = 55
        if(classTypeDropdownData.dropStatus == .half){
            classHeight += 4*32
        }else if (classTypeDropdownData.dropStatus == .down){
            classHeight += 32*(1 + classTypeDropdown.numberOfRows(inSection: 0))
        }
        
        var instructorHeight = 55
        if(instructorDropdownData.dropStatus == .half){
            instructorHeight += 4*32
        }else if (instructorDropdownData.dropStatus == .down){
            instructorHeight += 32*(1 + instructorDropdown.numberOfRows(inSection: 0))
        }
        
        let height = 186 + classHeight + instructorHeight + 10
        scrollView.contentSize = CGSize(width: view.frame.width, height: CGFloat(height))
    }

    //MARK: - NAVIGATION BAR BUTTONS FUNCTIONS
    @objc func done(){
        let filterParameters = FilterParameters(shouldFilter: true, startTime: startTime, endTime: endTime, instructorIds: selectedInstructors, classDescIds: selectedClasses, gymIds: selectedGyms)
        
        //is there a better way of doing this?
        (navigationController!.viewControllers.first as! ClassListViewController).filterParameters = filterParameters
        
        navigationController!.popViewController(animated: true)
    }

    @objc func reset(){
        selectedGyms = []
        for i in 0..<gymCollectionView.numberOfItems(inSection: 0){
            gymCollectionView.deselectItem(at: IndexPath(row: i, section: 0), animated: true)
        }
        
        startTimeLabel.text = "6:00 AM - 10:00 PM"
        startTimeSlider.lowerValue = 0.0
        startTimeSlider.upperValue = 960.0
        
        classTypeDropdownData.dropStatus = .down
        selectedClasses = []
        dropClasses(sender: UITapGestureRecognizer(target: nil, action: nil))
        
        instructorDropdownData.dropStatus = .down
        selectedInstructors = []
        dropInstructors(sender: UITapGestureRecognizer(target: nil, action: nil))
    }

    //MARK: - COLLECTION VIEW METHODS
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gymFilterCell", for: indexPath) as! GymFilterCell

        cell.gymNameLabel.text = gyms[indexPath.row].name
        cell.gymNameLabel.sizeToFit()

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        for i in 0..<selectedGyms.count{
            if (selectedGyms[i] == gyms[indexPath.row].id){
                selectedGyms.remove(at: i)
                return
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedGyms.append(gyms[indexPath.row].id)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 35 + gyms[indexPath.row].name.count*10, height: 31)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gyms.count
    }

    //MARK: - SLIDER METHODS
    @objc func startTimeChanged() {
        let lowerSliderVal = startTimeSlider.lowerValue + 360
        let upperSliderVal = startTimeSlider.upperValue + 360

        var lowerHours = Int(lowerSliderVal/60)
        let lowerMinutes = Int(lowerSliderVal)%60
        var upperHours = Int(upperSliderVal/60)
        let upperMinutes = Int(upperSliderVal)%60

        if lowerHours > 12{
            upperHours -= 12
            lowerHours -= 12
            startTimeLabel.text = (String(lowerHours) + ":" + String(format: "%02d", lowerMinutes) + " PM - " + String(upperHours) + ":" + String(format: "%02d", upperMinutes) + " PM")
            startTime = (String(lowerHours) + ":" + String(format: "%02d", lowerMinutes) + "PM")
            endTime = (String(upperHours) + ":" + String(format: "%02d", upperMinutes) + "PM")
        }else if (upperHours < 12){
            startTimeLabel.text = (String(lowerHours) + ":" + String(format: "%02d", lowerMinutes) + " AM - " + String(upperHours) + ":" + String(format: "%02d", upperMinutes) + " AM")
            startTime = (String(lowerHours) + ":" + String(format: "%02d", lowerMinutes) + "AM")
            endTime = (String(upperHours) + ":" + String(format: "%02d", upperMinutes) + "AM")
        } else {
            upperHours -= 12
            startTimeLabel.text = (String(lowerHours) + ":" + String(format: "%02d", lowerMinutes) + " AM - " + String(upperHours) + ":" + String(format: "%02d", upperMinutes) + " PM")
            startTime = (String(lowerHours) + ":" + String(format: "%02d", lowerMinutes) + "AM")
            endTime = (String(upperHours) + ":" + String(format: "%02d", upperMinutes) + "PM")
        }
    }

    //MARK: - TABLE VIEW METHODS
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRows = 0
        if tableView == instructorDropdown{
            if(instructorDropdownData.completed == false){
                return 0
            }
            
            switch instructorDropdownData.dropStatus{
            case .up:
                numberOfRows = 0
            case .half:
                numberOfRows = 3
            case .down:
                numberOfRows = instructorDropdownData.titles.count
            default:
                numberOfRows = 0
            }
        }else if tableView == classTypeDropdown{
            if(classTypeDropdownData.completed == false){
                return 0
            }
            
            switch classTypeDropdownData.dropStatus{
            case .up:
                numberOfRows = 0
            case .half:
                numberOfRows = 3
            case .down:
                numberOfRows = classTypeDropdownData.titles.count
            default:
                numberOfRows = 0
            }
        }
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! DropdownViewCell
        var shouldAppend: Bool
        
        if(cell.checkBoxColoring.backgroundColor == .fitnessYellow){
            cell.checkBoxColoring.backgroundColor = .white
            shouldAppend = false
        }else{
            cell.checkBoxColoring.backgroundColor = .fitnessYellow
            shouldAppend = true
        }
        
        if (tableView == classTypeDropdown){
            if(shouldAppend){
                selectedClasses.append(cell.id)
            }else{
                for i in 0..<selectedClasses.count{
                    let id = selectedClasses[i]
                    if(id == cell.id){
                        selectedClasses.remove(at: i)
                        return
                    }
                }
            }
        }else{
            if(shouldAppend){
                selectedInstructors.append(cell.id)
            }else{
                for i in 0..<selectedInstructors.count{
                    let id = selectedInstructors[i]
                    if(id == cell.id){
                        selectedInstructors.remove(at: i)
                        return
                    }
                }
            }
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dropdownViewCell", for: indexPath) as! DropdownViewCell

        if tableView == instructorDropdown{
            if(indexPath.row < instructorDropdownData.titles.count){
                cell.titleLabel.text = instructorDropdownData.titles[indexPath.row]
                cell.id = instructorDropdownData.ids[indexPath.row]
            }
        }else if tableView == classTypeDropdown{
            if(indexPath.row < classTypeDropdownData.titles.count){
                cell.titleLabel.text = classTypeDropdownData.titles[indexPath.row]
                cell.id = classTypeDropdownData.ids[indexPath.row]
            }
        }

        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "dropdownHeaderView") as! DropdownHeaderView

        if tableView == instructorDropdown{
            header.titleLabel.text = "INSTRUCTOR"
            let gesture = UITapGestureRecognizer(target: self, action: #selector(self.dropInstructors(sender:) ))
            header.addGestureRecognizer(gesture)
        }else if tableView == classTypeDropdown{
            header.titleLabel.text = "CLASS TYPE"
            let gesture = UITapGestureRecognizer(target: self, action: #selector(self.dropClasses(sender:) ))
            header.addGestureRecognizer(gesture)
        }

        return header
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: "dropdownFooterView") as! DropdownFooterView

        if tableView == instructorDropdown{
            let gesture = UITapGestureRecognizer(target: self, action: #selector(self.dropHideInstructors(sender:) ))
            footer.addGestureRecognizer(gesture)
            if(instructorDropdownData.dropStatus == .half){
                footer.showHideLabel.text = "Show All Instructors"
            }else{
                footer.showHideLabel.text = "Hide"
            }
        }else if tableView == classTypeDropdown{
            let gesture = UITapGestureRecognizer(target: self, action: #selector(self.dropHideClasses(sender:) ))
            footer.addGestureRecognizer(gesture)
            if(classTypeDropdownData.dropStatus == .half){
                footer.showHideLabel.text = "Show All Classe Types"
            }else{
                footer.showHideLabel.text = "Hide"
            }
        }

        return footer
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        var height = 0
        if tableView == classTypeDropdown{
            switch classTypeDropdownData.dropStatus{
            case .up:
                height = 0
            case .half:
                height = 32
            case .down:
                height = 32
            default:
                height = 0
            }
        }else if tableView == instructorDropdown{
            switch instructorDropdownData.dropStatus{
            case .up:
                height = 0
            case .half:
                height = 32
            case .down:
                height = 32
            default:
                height = 0
            }
        }
        return CGFloat(height)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 32
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55
    }

    //MARK: - DROP METHODS
    @objc func dropInstructors( sender:UITapGestureRecognizer){
        
        if(instructorDropdownData.completed == false){
            return
        }

        instructorDropdown.beginUpdates()
        var modifiedIndices: [IndexPath] = []

        if (instructorDropdownData.dropStatus == .half || instructorDropdownData.dropStatus == .down) {
            (instructorDropdown.headerView(forSection: 0) as! DropdownHeaderView).downArrow.image = .none
            (instructorDropdown.headerView(forSection: 0) as! DropdownHeaderView).rightArrow.image = #imageLiteral(resourceName: "right_arrow")

            instructorDropdownData.dropStatus = .up
            var i = 0
            while i < instructorDropdown.numberOfRows(inSection: 0){
                modifiedIndices.append(IndexPath(row: i, section: 0))
                i += 1
            }
            instructorDropdown.deleteRows(at: modifiedIndices, with: .none)
        }else{
            (instructorDropdown.headerView(forSection: 0) as! DropdownHeaderView).downArrow.image = #imageLiteral(resourceName: "down_arrow")
            (instructorDropdown.headerView(forSection: 0) as! DropdownHeaderView).rightArrow.image = .none

            instructorDropdownData.dropStatus = .half
            for i in [0,1,2]{
                modifiedIndices.append(IndexPath(row: i, section: 0))
            }
            instructorDropdown.insertRows(at: modifiedIndices, with: .none)
        }
        instructorDropdown.endUpdates()
        setupConstraints()
    }

    @objc func dropClasses( sender:UITapGestureRecognizer){
        
        if(classTypeDropdownData.completed == false){
            return
        }
        
        classTypeDropdown.beginUpdates()
        var modifiedIndices: [IndexPath] = []

        if (classTypeDropdownData.dropStatus == .half || classTypeDropdownData.dropStatus == .down) {
            (classTypeDropdown.headerView(forSection: 0) as! DropdownHeaderView).downArrow.image = .none
            (classTypeDropdown.headerView(forSection: 0) as! DropdownHeaderView).rightArrow.image = #imageLiteral(resourceName: "right_arrow")
            classTypeDropdownData.dropStatus = .up
            var i = 0
            while i < classTypeDropdown.numberOfRows(inSection: 0){
                modifiedIndices.append(IndexPath(row: i, section: 0))
                i += 1
            }
            classTypeDropdown.deleteRows(at: modifiedIndices, with: .none)
        }else{
            (classTypeDropdown.headerView(forSection: 0) as! DropdownHeaderView).downArrow.image = #imageLiteral(resourceName: "down_arrow")
            (classTypeDropdown.headerView(forSection: 0) as! DropdownHeaderView).rightArrow.image = .none
            classTypeDropdownData.dropStatus = .half
            for i in [0,1,2]{
                modifiedIndices.append(IndexPath(row: i, section: 0))
            }
            classTypeDropdown.insertRows(at: modifiedIndices, with: .none)
        }
        classTypeDropdown.endUpdates()
        setupConstraints()
    }

    //MARK: - SHOW ALL/HIDE METHODS
    @objc func dropHideClasses( sender:UITapGestureRecognizer){
        
        if(classTypeDropdownData.completed == false){
            return
        }
        
        classTypeDropdown.beginUpdates()
        var modifiedIndices: [IndexPath] = []

        if (classTypeDropdownData.dropStatus == .half) {
            classTypeDropdownData.dropStatus = .down

            var i = 3
            while i < classTypeDropdownData.titles.count{
                modifiedIndices.append(IndexPath(row: i, section: 0))
                i += 1
            }
            classTypeDropdown.insertRows(at: modifiedIndices, with: .none)
        }else{
            classTypeDropdownData.dropStatus = .half
            var i = classTypeDropdown.numberOfRows(inSection: 0) - 1
            while i >= 3{
                modifiedIndices.append(IndexPath(row: i, section: 0))
                i -= 1
            }
            classTypeDropdown.deleteRows(at: modifiedIndices, with: .none)
        }

        classTypeDropdown.endUpdates()
        setupConstraints()
    }

    @objc func dropHideInstructors( sender:UITapGestureRecognizer){
        
        if(instructorDropdownData.completed == false){
            return
        }
        
        instructorDropdown.beginUpdates()
        var modifiedIndices: [IndexPath] = []

        if (instructorDropdownData.dropStatus == .half) {
            instructorDropdownData.dropStatus = .down

            var i = 3
            while i < instructorDropdownData.titles.count{
                modifiedIndices.append(IndexPath(row: i, section: 0))
                i += 1
            }
            instructorDropdown.insertRows(at: modifiedIndices, with: .none)
        }else{
            instructorDropdownData.dropStatus = .half
            var i = instructorDropdown.numberOfRows(inSection: 0) - 1
            while i >= 3{
                modifiedIndices.append(IndexPath(row: i, section: 0))
                i -= 1
            }
            instructorDropdown.deleteRows(at: modifiedIndices, with: .none)
        }

        instructorDropdown.endUpdates()
        setupConstraints()
    }
}
