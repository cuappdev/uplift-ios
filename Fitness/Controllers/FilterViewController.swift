//
//  FilterViewController.swift
//  Fitness
//
//  Created by Joseph Fulgieri on 4/2/18.
//  Copyright © 2018 Uplift. All rights reserved.
//

import UIKit
import SnapKit

enum Dropped {
    case up, half, down
}

struct DropdownData {
    var dropStatus: Dropped!
    var titles: [String]!
    var completed: Bool!
}

struct GymNameId {
    var name: String!
    var id: String!
}

protocol FilterDelegate {
    func filterOptions(params: FilterParameters)
}

class FilterViewController: UIViewController, RangeSeekSliderDelegate {

    // MARK: - INITIALIZATION
    var timeFormatter: DateFormatter!
    var scrollView: UIScrollView!
    var contentView: UIView!

    var collectionViewTitle: UILabel!
    var gymCollectionView: UICollectionView!
    var gyms: [GymNameId]!
    var delegate: FilterDelegate?
    /// ids of the selected gyms
    var selectedGyms: [String] = []

    var fitnessCenterStartTimeDivider: UIView!
    var startTimeTitleLabel: UILabel!
    var startTimeLabel: UILabel!
    var startTimeSlider: RangeSeekSlider!
    var timeRanges: [Date] = []


    var startTimeClassTypeDivider: UIView!
    var startTime = "6:00AM"
    var endTime = "10:00PM"

    var classTypeDropdown: UITableView!
    var classTypeDropdownData: DropdownData!
    var classTypeInstructorDivider: UIView!
    var selectedClasses: [String] = []

    var instructorDropdown: UITableView!
    var instructorDropdownData: DropdownData!
    var instructorDivider: UIView!
    var selectedInstructors: [String] = []

    convenience init(currentFilterParams: FilterParameters?) {
        self.init()
        //TODO: - See if we already have filter params, and apply them
        
        guard let existingFilterParams = currentFilterParams else {
            return
        }
        
        selectedGyms = existingFilterParams.gymIds
        selectedClasses = existingFilterParams.classNames
        selectedInstructors = existingFilterParams.instructorNames
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let cal = Calendar.current
        let currDate = Date()
        let startDate = cal.date(bySettingHour: 6, minute: 0, second: 0, of: currDate)!
        let endDate = cal.date(bySettingHour: 22, minute: 0, second: 0, of: currDate)!

        var date = startDate

        while date <= endDate {
            timeRanges.append(date)
            date = cal.date(byAdding: .minute, value: 15, to: date)!
        }

        timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mma"

        setupWrappingViews()

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
        startTimeLabel.text = startTime + " - " + endTime
        contentView.addSubview(startTimeLabel)

        startTimeSlider = RangeSeekSlider(frame: .zero)
        startTimeSlider.minValue = 0.0 //15 minute intervals
        startTimeSlider.maxValue = 960.0
        startTimeSlider.selectedMinValue = 0.0
        startTimeSlider.selectedMaxValue = 960.0
        startTimeSlider.enableStep = true
        startTimeSlider.delegate = self
        startTimeSlider.step = 15.0
        startTimeSlider.handleDiameter = 24.0
        startTimeSlider.selectedHandleDiameterMultiplier = 1.0
        startTimeSlider.lineHeight = 6.0
        startTimeSlider.hideLabels = true

        startTimeSlider.colorBetweenHandles = .fitnessYellow
        startTimeSlider.handleColor = .white
        startTimeSlider.handleBorderWidth = 1.0
        startTimeSlider.handleBorderColor = .fitnessLightGrey
        startTimeSlider.tintColor = .fitnessLightGrey
        contentView.addSubview(startTimeSlider)

        startTimeClassTypeDivider = UIView()
        startTimeClassTypeDivider.backgroundColor = .fitnessLightGrey
        contentView.addSubview(startTimeClassTypeDivider)

        //CLASS TYPE SECTION
        classTypeDropdown = UITableView(frame: .zero, style: .grouped)
        classTypeDropdown.separatorStyle = .none
        classTypeDropdown.showsVerticalScrollIndicator = false
        classTypeDropdown.bounces = false

        classTypeDropdown.register(DropdownViewCell.self, forCellReuseIdentifier: DropdownViewCell.identifier)
        classTypeDropdown.register(DropdownHeaderView.self, forHeaderFooterViewReuseIdentifier: DropdownHeaderView.identifier)
        classTypeDropdown.register(DropdownFooterView.self, forHeaderFooterViewReuseIdentifier: DropdownFooterView.identifier)

        classTypeDropdown.delegate = self
        classTypeDropdown.dataSource = self
        contentView.addSubview(classTypeDropdown)

        classTypeInstructorDivider = UIView()
        classTypeInstructorDivider.backgroundColor = .fitnessLightGrey
        contentView.addSubview(classTypeInstructorDivider)

        classTypeDropdownData = DropdownData(dropStatus: .up, titles: [], completed: false)

        AppDelegate.networkManager.getClassNames { (classNames) in

            self.classTypeDropdownData.titles.append(contentsOf: classNames)

            self.classTypeDropdownData.completed = true
            self.classTypeDropdown.reloadData()
            self.setupConstraints()
        }

        //INSTRUCTOR SECTION
        instructorDropdown = UITableView(frame: .zero, style: .grouped)
        instructorDropdown.separatorStyle = .none
        instructorDropdown.bounces = false
        instructorDropdown.showsVerticalScrollIndicator = false

        instructorDropdown.register(DropdownViewCell.self, forCellReuseIdentifier: DropdownViewCell.identifier)
        instructorDropdown.register(DropdownHeaderView.self, forHeaderFooterViewReuseIdentifier: DropdownHeaderView.identifier)
        instructorDropdown.register(DropdownFooterView.self, forHeaderFooterViewReuseIdentifier: DropdownFooterView.identifier)

        instructorDropdown.delegate = self
        instructorDropdown.dataSource = self
        contentView.addSubview(instructorDropdown)

        instructorDivider = UIView()
        instructorDivider.backgroundColor = .fitnessLightGrey
        contentView.addSubview(instructorDivider)

        instructorDropdownData = DropdownData(dropStatus: .up, titles: [], completed: false)

        AppDelegate.networkManager.getInstructors { (instructors) in

            for instructor in instructors {
                // self.instructorDropdownData.titles.append(instructor.name)
                // self.instructorDropdownData.ids.append(instructor.id)
                self.instructorDropdownData.titles.append(instructor)
            }

            self.instructorDropdownData.completed = true
            self.instructorDropdown.reloadData()
            self.setupConstraints()
        }

        setupConstraints()
    }

    // MARK: - SETUP WRAPPING VIEWS
    func setupWrappingViews() {
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
        scrollView.bounces = true
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height * 2.5)
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }

        contentView = UIView()
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints {make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView)
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
        gymCollectionView.register(GymFilterCell.self, forCellWithReuseIdentifier: GymFilterCell.identifier)
        contentView.addSubview(gymCollectionView)

        gyms = []

        AppDelegate.networkManager.getGymNames { (gyms) in

            self.gyms = gyms
            self.gymCollectionView.reloadData()
        }
    }

    // MARK: - CONSTRAINTS
    func setupConstraints() {
        //COLLECTION VIEW SECTION
        collectionViewTitle.snp.remakeConstraints {make in
            make.left.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(20)
            make.bottom.equalTo(collectionViewTitle.snp.top).offset(15)
        }

        gymCollectionView.snp.remakeConstraints {make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(51)
            make.bottom.equalTo(collectionViewTitle.snp.bottom).offset(47)
        }

        //SLIDER SECTION
        fitnessCenterStartTimeDivider.snp.remakeConstraints {make in
            make.top.equalTo(gymCollectionView.snp.bottom).offset(16)
            make.bottom.equalTo(gymCollectionView.snp.bottom).offset(17)
            make.width.centerX.equalToSuperview()
        }

        startTimeTitleLabel.snp.remakeConstraints {make in
            make.left.equalToSuperview().offset(16)
            make.top.equalTo(fitnessCenterStartTimeDivider.snp.bottom).offset(20)
            make.bottom.equalTo(fitnessCenterStartTimeDivider.snp.bottom).offset(35)
        }

        startTimeLabel.snp.remakeConstraints {make in
            make.right.equalToSuperview().offset(-22)
            make.top.equalTo(fitnessCenterStartTimeDivider.snp.bottom).offset(20)
            make.bottom.equalTo(fitnessCenterStartTimeDivider.snp.bottom).offset(36)
        }

        startTimeSlider.snp.remakeConstraints {make in
            make.trailing.equalToSuperview().offset(-16)
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(startTimeLabel.snp.bottom).offset(12)
            make.height.equalTo(30)
        }

        startTimeClassTypeDivider.snp.remakeConstraints {make in
            make.width.centerX.equalToSuperview()
            make.top.equalTo(fitnessCenterStartTimeDivider.snp.bottom).offset(90)
            make.bottom.equalTo(fitnessCenterStartTimeDivider.snp.bottom).offset(91)
        }

        //CLASS TYPE SECTION
        classTypeDropdown.snp.remakeConstraints {make in
            make.top.equalTo(startTimeClassTypeDivider.snp.bottom)
            make.left.right.equalToSuperview()

            switch classTypeDropdownData.dropStatus! {
            case .up:
                make.height.equalTo(55)
            case .half:
                make.height.equalTo(55 + 32 + 3*32)
            case .down:
                make.height.equalTo(55 + 32 + classTypeDropdown.numberOfRows(inSection: 0)*32)
            }
        }

        classTypeInstructorDivider.snp.remakeConstraints {make in
            make.width.centerX.equalToSuperview()
            make.top.equalTo(classTypeDropdown.snp.bottom)
            make.bottom.equalTo(classTypeDropdown.snp.bottom).offset(1)
        }

        //INSTRUCTOR SECTION
        instructorDropdown.snp.remakeConstraints {make in
            make.top.equalTo(classTypeInstructorDivider.snp.bottom)
            make.left.right.equalToSuperview()

            switch instructorDropdownData.dropStatus! {
            case .up:
                make.height.equalTo(55)
            case .half:
                make.height.equalTo(55 + 32 + 3*32)
            case .down:
                make.height.equalTo(55 + 32 + instructorDropdown.numberOfRows(inSection: 0)*32)
            }
        }

        instructorDivider.snp.remakeConstraints {make in
            make.width.centerX.equalToSuperview()
            make.top.equalTo(instructorDropdown.snp.bottom)
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
        }
    }

    // MARK: - NAVIGATION BAR BUTTONS FUNCTIONS
    @objc func done() {
        let minValueIndex = Int(startTimeSlider.selectedMinValue / 15.0)
        let maxValueIndex = Int(startTimeSlider.selectedMaxValue / 15.0)

        let minDate = timeRanges[minValueIndex]
        let maxDate = timeRanges[maxValueIndex]

        let shouldFilter: Bool = {
            if minValueIndex != 0 || maxValueIndex != timeRanges.count - 1 { return true }
            if !selectedInstructors.isEmpty || !selectedClasses.isEmpty || !selectedGyms.isEmpty { return true }
            return false
        }()

        let filterParameters = FilterParameters(shouldFilter: shouldFilter, startTime: minDate, encodedStartTime: 0.0, endTime: maxDate, encodedEndTime: 0.0, instructorNames: selectedInstructors, classNames: selectedClasses, gymIds: selectedGyms)

        delegate?.filterOptions(params: filterParameters)

        dismiss(animated: true, completion: nil)
    }

    @objc func reset() {
        selectedGyms = []
        for i in 0..<gymCollectionView.numberOfItems(inSection: 0) {
            gymCollectionView.deselectItem(at: IndexPath(row: i, section: 0), animated: true)

        }

        startTimeLabel.text = "6:00AM - 10:00PM"
        startTimeSlider.selectedMinValue = 0.0
        startTimeSlider.selectedMaxValue = 960.0

        classTypeDropdownData.dropStatus = .down
        selectedClasses = []
        dropClasses(sender: UITapGestureRecognizer(target: nil, action: nil))

        instructorDropdownData.dropStatus = .down
        selectedInstructors = []
        dropInstructors(sender: UITapGestureRecognizer(target: nil, action: nil))

    }

    // MARK: - SLIDER METHODS
    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
        let minValueIndex = Int(minValue / 15.0)
        let maxValueIndex = Int(maxValue / 15.0)

        let minDate = timeRanges[minValueIndex]
        let maxDate = timeRanges[maxValueIndex]

        startTimeLabel.text = "\(timeFormatter.string(from: minDate)) - \(timeFormatter.string(from: maxDate))"

    }

    // MARK: - DROP METHODS
    @objc func dropInstructors( sender: UITapGestureRecognizer) {
        if instructorDropdownData.completed == false {
            instructorDropdownData.dropStatus = .up
            return
        }

        instructorDropdown.beginUpdates()
        var modifiedIndices: [IndexPath] = []

        if instructorDropdownData.dropStatus == .half || instructorDropdownData.dropStatus == .down {
            (instructorDropdown.headerView(forSection: 0) as! DropdownHeaderView).downArrow.image = .none
            (instructorDropdown.headerView(forSection: 0) as! DropdownHeaderView).rightArrow.image = #imageLiteral(resourceName: "right_arrow")

            instructorDropdownData.dropStatus = .up
            var i = 0
            while i < instructorDropdown.numberOfRows(inSection: 0) {
                modifiedIndices.append(IndexPath(row: i, section: 0))
                i += 1
            }
            instructorDropdown.deleteRows(at: modifiedIndices, with: .none)
        } else {
            (instructorDropdown.headerView(forSection: 0) as! DropdownHeaderView).downArrow.image = #imageLiteral(resourceName: "down_arrow")
            (instructorDropdown.headerView(forSection: 0) as! DropdownHeaderView).rightArrow.image = .none

            instructorDropdownData.dropStatus = .half
            for i in [0, 1, 2] {
                modifiedIndices.append(IndexPath(row: i, section: 0))
            }
            instructorDropdown.insertRows(at: modifiedIndices, with: .none)
        }
        instructorDropdown.endUpdates()
        setupConstraints()
    }

    @objc func dropClasses( sender: UITapGestureRecognizer) {
        if classTypeDropdownData.completed == false {
            classTypeDropdownData.dropStatus = .up
            return
        }

        classTypeDropdown.beginUpdates()
        var modifiedIndices: [IndexPath] = []

        if classTypeDropdownData.dropStatus == .half || classTypeDropdownData.dropStatus == .down {
            (classTypeDropdown.headerView(forSection: 0) as! DropdownHeaderView).downArrow.image = .none
            (classTypeDropdown.headerView(forSection: 0) as! DropdownHeaderView).rightArrow.image = #imageLiteral(resourceName: "right_arrow")
            classTypeDropdownData.dropStatus = .up
            var i = 0
            while i < classTypeDropdown.numberOfRows(inSection: 0) {
                modifiedIndices.append(IndexPath(row: i, section: 0))
                i += 1
            }
            classTypeDropdown.deleteRows(at: modifiedIndices, with: .none)
        } else {
            (classTypeDropdown.headerView(forSection: 0) as! DropdownHeaderView).downArrow.image = #imageLiteral(resourceName: "down_arrow")
            (classTypeDropdown.headerView(forSection: 0) as! DropdownHeaderView).rightArrow.image = .none
            classTypeDropdownData.dropStatus = .half
            for i in [0, 1, 2] {
                modifiedIndices.append(IndexPath(row: i, section: 0))
            }
            classTypeDropdown.insertRows(at: modifiedIndices, with: .none)
        }
        classTypeDropdown.endUpdates()
        setupConstraints()
    }

    // MARK: - SHOW ALL/HIDE METHODS
    @objc func dropHideClasses( sender: UITapGestureRecognizer) {
        if classTypeDropdownData.completed == false {
            return
        }

        classTypeDropdown.beginUpdates()
        var modifiedIndices: [IndexPath] = []

        if classTypeDropdownData.dropStatus == .half {
            classTypeDropdownData.dropStatus = .down

            var i = 3
            while i < classTypeDropdownData.titles.count {
                modifiedIndices.append(IndexPath(row: i, section: 0))
                i += 1
            }
            classTypeDropdown.insertRows(at: modifiedIndices, with: .none)
        } else {
            classTypeDropdownData.dropStatus = .half
            var i = classTypeDropdown.numberOfRows(inSection: 0) - 1
            while i >= 3 {
                modifiedIndices.append(IndexPath(row: i, section: 0))
                i -= 1
            }
            classTypeDropdown.deleteRows(at: modifiedIndices, with: .none)
        }

        classTypeDropdown.endUpdates()
        setupConstraints()
    }

    @objc func dropHideInstructors( sender: UITapGestureRecognizer) {

        if instructorDropdownData.completed == false {
            return
        }

        instructorDropdown.beginUpdates()
        var modifiedIndices: [IndexPath] = []

        if instructorDropdownData.dropStatus == .half {
            instructorDropdownData.dropStatus = .down

            var i = 3
            while i < instructorDropdownData.titles.count {
                modifiedIndices.append(IndexPath(row: i, section: 0))
                i += 1
            }
            instructorDropdown.insertRows(at: modifiedIndices, with: .none)
        } else {
            instructorDropdownData.dropStatus = .half
            var i = instructorDropdown.numberOfRows(inSection: 0) - 1
            while i >= 3 {
                modifiedIndices.append(IndexPath(row: i, section: 0))
                i -= 1
            }
            instructorDropdown.deleteRows(at: modifiedIndices, with: .none)
        }

        instructorDropdown.endUpdates()
        setupConstraints()
    }
}

// MARK: CollectionViewDelegateFlowLayout
extension FilterViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        for i in 0..<selectedGyms.count {
            if selectedGyms[i] == gyms[indexPath.row].id {
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

}

// MARK: CollectionViewDataSource
extension FilterViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GymFilterCell.identifier, for: indexPath) as! GymFilterCell

        cell.gymNameLabel.text = gyms[indexPath.row].name
        cell.gymNameLabel.sizeToFit()

        if selectedGyms.contains(gyms[indexPath.row].id) {
            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .right)
            cell.isSelected = true
        }
        return cell
    }
}

// MARK: TableViewDataSource
extension FilterViewController: UITableViewDataSource {
    //TODO: Refactor this method for better code readability
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRows = 0
        if tableView == instructorDropdown {
            if instructorDropdownData.completed == false {
                return 0
            }
            switch instructorDropdownData.dropStatus! {
            case .up:
                numberOfRows = 0
            case .half:
                numberOfRows = 3
            case .down:
                numberOfRows = instructorDropdownData.titles.count
            }
        } else if tableView == classTypeDropdown {
            if classTypeDropdownData.completed == false {
                return 0
            }

            switch classTypeDropdownData.dropStatus! {
            case .up:
                numberOfRows = 0
            case .half:
                numberOfRows = 3
            case .down:
                numberOfRows = classTypeDropdownData.titles.count
            }
        }
        return numberOfRows
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DropdownViewCell.identifier, for: indexPath) as! DropdownViewCell

        if tableView == instructorDropdown {
            if indexPath.row < instructorDropdownData.titles.count {
                cell.titleLabel.text = instructorDropdownData.titles[indexPath.row]

                if selectedInstructors.contains(instructorDropdownData.titles[indexPath.row]) {
                    cell.checkBoxColoring.backgroundColor = .fitnessYellow
                }
            }
        } else if tableView == classTypeDropdown {
            if indexPath.row < classTypeDropdownData.titles.count {
                cell.titleLabel.text = classTypeDropdownData.titles[indexPath.row]

                if selectedClasses.contains(classTypeDropdownData.titles[indexPath.row]) {
                    cell.checkBoxColoring.backgroundColor = .fitnessYellow
                }
            }
        }
        return cell
    }
}

// MARK: TableViewDelegate
extension FilterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! DropdownViewCell
        var shouldAppend: Bool = cell.checkBoxColoring.backgroundColor == .fitnessYellow

        cell.checkBoxColoring.backgroundColor = shouldAppend ? .white : .fitnessYellow
        shouldAppend = !shouldAppend

        if tableView == classTypeDropdown {
            if(shouldAppend) {
                selectedClasses.append(cell.titleLabel.text!)
            } else {
                for i in 0..<selectedClasses.count {
                    let name = selectedClasses[i]
                    if name == cell.titleLabel.text! {
                        selectedClasses.remove(at: i)
                        return
                    }
                }
            }
        } else {
            if shouldAppend {
                selectedInstructors.append(cell.titleLabel.text!)
            } else {
                for i in 0..<selectedInstructors.count {
                    let name = selectedInstructors[i]
                    if name == cell.titleLabel.text! {
                        selectedInstructors.remove(at: i)
                        return
                    }
                }
            }
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 32
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        var height: CGFloat = 0
        if tableView == classTypeDropdown {
            switch classTypeDropdownData.dropStatus! {
            case .up:
                height = 0
            case .half, .down:
                height = 32
            }
        } else if tableView == instructorDropdown {
            switch instructorDropdownData.dropStatus! {
            case .up:
                height = 0
            case .half, .down:
                height = 32
            }
        }
        return height
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: DropdownFooterView.identifier) as! DropdownFooterView

        if tableView == instructorDropdown {
            let gesture = UITapGestureRecognizer(target: self, action: #selector(self.dropHideInstructors(sender:) ))
            footer.addGestureRecognizer(gesture)
            if (instructorDropdownData.dropStatus == .half) {
                footer.showHideLabel.text = "Show All Instructors"
            } else {
                footer.showHideLabel.text = "Hide"
            }
        } else if tableView == classTypeDropdown {
            let gesture = UITapGestureRecognizer(target: self, action: #selector(self.dropHideClasses(sender:) ))
            footer.addGestureRecognizer(gesture)
            if (classTypeDropdownData.dropStatus == .half) {
                footer.showHideLabel.text = "Show All Classe Types"
            } else {
                footer.showHideLabel.text = "Hide"
            }
        }
        return footer
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: DropdownHeaderView.identifier) as! DropdownHeaderView

        if tableView == instructorDropdown {
            header.titleLabel.text = "INSTRUCTOR"
            let gesture = UITapGestureRecognizer(target: self, action: #selector(self.dropInstructors(sender:) ))
            header.addGestureRecognizer(gesture)
        } else if tableView == classTypeDropdown {
            header.titleLabel.text = "CLASS TYPE"
            let gesture = UITapGestureRecognizer(target: self, action: #selector(self.dropClasses(sender:) ))
            header.addGestureRecognizer(gesture)
        }

        return header
    }
}
