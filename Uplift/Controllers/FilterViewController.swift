//
//  FilterViewController.swift
//  Uplift
//
//  Created by Joseph Fulgieri on 4/2/18.
//  Copyright © 2018 Uplift. All rights reserved.
//

import SnapKit
import UIKit

enum Dropped {
    case up, half, down
}

struct DropdownData {
    var completed: Bool!
    var dropStatus: Dropped!
    var titles: [String]!
}

struct GymNameId {
    var name: String!
    var id: String!
}

protocol FilterDelegate {
    func filterOptions(params: FilterParameters)
}

// swiftlint:disable:next type_body_length
class FilterViewController: UIViewController, RangeSeekSliderDelegate {

    // MARK: - INITIALIZATION
    var contentView: UIView!
    var scrollView: UIScrollView!
    var timeFormatter: DateFormatter!

    var collectionViewTitle: UILabel!
    var delegate: FilterDelegate?
    var gymCollectionView: UICollectionView!
    var gyms: [GymNameId]!
    /// ids of the selected gyms
    var selectedGyms: [String] = []

    var fitnessCenterStartTimeDivider: UIView!
    var startTimeLabel: UILabel!
    var startTimeSlider: RangeSeekSlider!
    var startTimeTitleLabel: UILabel!
    var timeRanges: [Date] = []

    var endTime = "10:00PM"
    var startTime = "6:00AM"
    var startTimeClassTypeDivider: UIView!

    var classTypeDropdownHeader: DropdownHeaderView!
    var classTypeDropdownFooter: DropdownFooterView!
    var classTypeDropdown: UITableView!
    var classTypeDropdownData: DropdownData!
    var classTypeInstructorDivider: UIView!
    var selectedClasses: [String] = []

    var instructorDivider: UIView!
    var instructorDropdownHeader: DropdownHeaderView!
    var instructorDropdownFooter: DropdownFooterView!
    var instructorDropdown: UITableView!
    var instructorDropdownData: DropdownData!
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

    // swiftlint:disable:next function_body_length
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

        // START TIME SLIDER SECTION
        fitnessCenterStartTimeDivider = UIView()
        fitnessCenterStartTimeDivider.backgroundColor = .gray01
        contentView.addSubview(fitnessCenterStartTimeDivider)

        startTimeTitleLabel = UILabel()
        startTimeTitleLabel.sizeToFit()
        startTimeTitleLabel.font = ._12MontserratBold
        startTimeTitleLabel.textColor = .gray04
        startTimeTitleLabel.text = ClientStrings.Filter.startTime
        contentView.addSubview(startTimeTitleLabel)

        startTimeLabel = UILabel()
        startTimeLabel.sizeToFit()
        startTimeLabel.font = ._12MontserratBold
        startTimeLabel.textColor = .gray04
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

        startTimeSlider.colorBetweenHandles = .primaryYellow
        startTimeSlider.handleColor = .white
        startTimeSlider.handleBorderWidth = 1.0
        startTimeSlider.handleBorderColor = .gray01
        startTimeSlider.handleShadowColor = .gray02
        startTimeSlider.handleShadowOffset = CGSize(width: 0, height: 2)
        startTimeSlider.handleShadowOpacity = 0.6
        startTimeSlider.handleShadowRadius = 1.0
        startTimeSlider.tintColor = .gray01
        contentView.addSubview(startTimeSlider)

        startTimeClassTypeDivider = UIView()
        startTimeClassTypeDivider.backgroundColor = .gray01
        contentView.addSubview(startTimeClassTypeDivider)

        // CLASS TYPE SECTION
        classTypeDropdownHeader = DropdownHeaderView(title: ClientStrings.Filter.selectClassTypeSection)
        contentView.addSubview(classTypeDropdownHeader)

        classTypeDropdownFooter = DropdownFooterView()
        classTypeDropdownFooter.clipsToBounds = true
        contentView.addSubview(classTypeDropdownFooter)

        let toggleMoreClasses = UITapGestureRecognizer(target: self, action: #selector(self.dropHideClasses(sender:) ))
        classTypeDropdownFooter.addGestureRecognizer(toggleMoreClasses)

        classTypeDropdown = UITableView()
        classTypeDropdown.separatorStyle = .none
        classTypeDropdown.showsVerticalScrollIndicator = false
        classTypeDropdown.bounces = false

        classTypeDropdown.register(DropdownViewCell.self, forCellReuseIdentifier: DropdownViewCell.identifier)
        classTypeDropdown.delegate = self
        classTypeDropdown.dataSource = self
        contentView.addSubview(classTypeDropdown)

        classTypeInstructorDivider = UIView()
        classTypeInstructorDivider.backgroundColor = .gray01
        contentView.addSubview(classTypeInstructorDivider)

        classTypeDropdownData = DropdownData(completed: false, dropStatus: .up, titles: [])

        NetworkManager.shared.getClassNames { classNames in
            self.classTypeDropdownData.titles.append(contentsOf: classNames)
            self.classTypeDropdownData.titles.sort()

            self.classTypeDropdownData.completed = true
            self.classTypeDropdown.reloadData()
            self.setupConstraints()
        }

        // INSTRUCTOR SECTION
        instructorDropdownHeader = DropdownHeaderView(title: ClientStrings.Filter.selectInstructorSection)
        contentView.addSubview(instructorDropdownHeader)
        
        instructorDropdownFooter = DropdownFooterView()
        instructorDropdownFooter.clipsToBounds = true
        contentView.addSubview(instructorDropdownFooter)
        
        let toggleMoreInstructors = UITapGestureRecognizer(target: self, action: #selector(self.dropHideInstructors(sender:) ))
        instructorDropdownFooter.addGestureRecognizer(toggleMoreInstructors)
               
        instructorDropdown = UITableView()
        instructorDropdown.separatorStyle = .none
        instructorDropdown.bounces = false
        instructorDropdown.showsVerticalScrollIndicator = false

        instructorDropdown.register(DropdownViewCell.self, forCellReuseIdentifier: DropdownViewCell.identifier)

        instructorDropdown.delegate = self
        instructorDropdown.dataSource = self
        contentView.addSubview(instructorDropdown)

        instructorDivider = UIView()
        instructorDivider.backgroundColor = .gray01
        contentView.addSubview(instructorDivider)

        instructorDropdownData = DropdownData(completed: false, dropStatus: .up, titles: [])

        NetworkManager.shared.getInstructors { instructors in
            self.instructorDropdownData.titles.append(contentsOf: instructors)
            self.instructorDropdownData.titles.sort()

            self.instructorDropdownData.completed = true
            self.instructorDropdown.reloadData()
            self.setupConstraints()
        }

        setupConstraints()
        setupDropdownHeaderViews()
    }

    // MARK: - SETUP WRAPPING VIEWS
    func setupWrappingViews() {
        // NAVIGATION BAR
        let titleView = UILabel()
        titleView.text = ClientStrings.Filter.vcTitleLabel
        titleView.font = ._14MontserratBold
        self.navigationItem.titleView = titleView

        // Color Navigation Bar White if Dark Mode
        if #available(iOS 13, *) {
            navigationItem.standardAppearance = .init()
            navigationItem.compactAppearance = .init()
            navigationItem.compactAppearance?.backgroundColor = .primaryWhite
            navigationItem.standardAppearance?.backgroundColor = .primaryWhite
            titleView.textColor = .primaryBlack
        }

        let doneBarButton = UIBarButtonItem(title: ClientStrings.Filter.doneButton, style: .plain, target: self, action: #selector(done))
        doneBarButton.tintColor = .primaryBlack
        doneBarButton.setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont._14MontserratMedium as Any
        ], for: .normal)
        self.navigationItem.rightBarButtonItem = doneBarButton

        let resetBarButton = UIBarButtonItem(title: ClientStrings.Filter.resetButton, style: .plain, target: self, action: #selector(reset))
        resetBarButton.tintColor = .primaryBlack
        resetBarButton.setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont._14MontserratMedium as Any
        ], for: .normal)
        self.navigationItem.leftBarButtonItem = resetBarButton

        // SCROLL VIEW
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
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView)
        }

        // COLLECTION VIEW
        collectionViewTitle = UILabel()
        collectionViewTitle.font = ._12MontserratBold
        collectionViewTitle.textColor = .gray04
        collectionViewTitle.text = ClientStrings.Filter.selectGymSection
        contentView.addSubview(collectionViewTitle)

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0 )
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 0

        gymCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        gymCollectionView.allowsMultipleSelection = true
        gymCollectionView.backgroundColor = .gray01
        gymCollectionView.isScrollEnabled = true
        gymCollectionView.showsHorizontalScrollIndicator = false
        gymCollectionView.bounces = false

        gymCollectionView.delegate = self
        gymCollectionView.dataSource = self
        gymCollectionView.register(GymFilterCell.self, forCellWithReuseIdentifier: GymFilterCell.identifier)
        contentView.addSubview(gymCollectionView)

        gyms = []

        NetworkManager.shared.getGymNames(completion: { (gyms) in
            self.gyms = gyms
            self.gymCollectionView.reloadData()
        })
    }

    // MARK: - CONSTRAINTS
    func setupConstraints() {
        // COLLECTION VIEW SECTION
        collectionViewTitle.snp.remakeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(20)
            make.bottom.equalTo(collectionViewTitle.snp.top).offset(15)
        }

        gymCollectionView.snp.remakeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(51)
            make.bottom.equalTo(collectionViewTitle.snp.bottom).offset(47)
        }

        // SLIDER SECTION
        fitnessCenterStartTimeDivider.snp.remakeConstraints { make in
            make.top.equalTo(gymCollectionView.snp.bottom).offset(16)
            make.bottom.equalTo(gymCollectionView.snp.bottom).offset(17)
            make.width.centerX.equalToSuperview()
        }

        startTimeTitleLabel.snp.remakeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(fitnessCenterStartTimeDivider.snp.bottom).offset(20)
            make.bottom.equalTo(fitnessCenterStartTimeDivider.snp.bottom).offset(35)
        }

        startTimeLabel.snp.remakeConstraints { make in
            make.trailing.equalToSuperview().offset(-22)
            make.top.equalTo(fitnessCenterStartTimeDivider.snp.bottom).offset(20)
            make.bottom.equalTo(fitnessCenterStartTimeDivider.snp.bottom).offset(36)
        }

        startTimeSlider.snp.remakeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(startTimeLabel.snp.bottom).offset(12)
            make.height.equalTo(30)
        }

        startTimeClassTypeDivider.snp.remakeConstraints { make in
            make.width.centerX.equalToSuperview()
            make.top.equalTo(fitnessCenterStartTimeDivider.snp.bottom).offset(90)
            make.bottom.equalTo(fitnessCenterStartTimeDivider.snp.bottom).offset(91)
        }

        // CLASS TYPE SECTION
        classTypeDropdownHeader.snp.remakeConstraints { make in
            make.top.equalTo(startTimeClassTypeDivider.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(55)
        }
        
        classTypeDropdown.snp.remakeConstraints { make in
            make.top.equalTo(classTypeDropdownHeader.snp.bottom)
            make.leading.trailing.equalToSuperview()
            
            if let dropStatus = classTypeDropdownData.dropStatus {
                switch dropStatus {
                    case .up:
                        make.height.equalTo(0)
                    case .half:
                        make.height.equalTo(3 * 32)
                    case .down:
                        make.height.equalTo(classTypeDropdown.numberOfRows(inSection: 0) * 32)
                }
            } else {
                make.height.equalTo(0)
            }
        }

        classTypeDropdownFooter.snp.remakeConstraints { make in
            make.top.equalTo(classTypeDropdown.snp.bottom)
            make.leading.trailing.equalToSuperview()
            
            if let dropStatus = classTypeDropdownData.dropStatus {
                switch dropStatus {
                    case .up:
                        make.height.equalTo(0)
                    case .half, .down:
                        make.height.equalTo(32)
                }
            } else {
                make.height.equalTo(0)
            }
        }
        
        classTypeInstructorDivider.snp.remakeConstraints { make in
            make.width.centerX.equalToSuperview()
            make.top.equalTo(classTypeDropdownFooter.snp.bottom)
            make.bottom.equalTo(classTypeDropdownFooter).offset(1)
        }

        // INSTRUCTOR SECTION
        instructorDropdownHeader.snp.remakeConstraints { make in
            make.top.equalTo(classTypeInstructorDivider.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(55)
        }
        
        instructorDropdown.snp.remakeConstraints { make in
            make.top.equalTo(instructorDropdownHeader.snp.bottom)
            make.leading.trailing.equalToSuperview()
            
            if let dropStatus = instructorDropdownData.dropStatus {
                switch dropStatus {
                    case .up:
                        make.height.equalTo(0)
                    case .half:
                        make.height.equalTo(3 * 32)
                    case .down:
                        make.height.equalTo(instructorDropdown.numberOfRows(inSection: 0) * 32)
                }
            } else {
                make.height.equalTo(0)
            }
        }
        
        instructorDropdownFooter.snp.remakeConstraints { make in
            make.top.equalTo(instructorDropdown.snp.bottom)
            make.leading.trailing.equalToSuperview()

            if let dropStatus = instructorDropdownData.dropStatus {
                switch dropStatus {
                    case .up:
                        make.height.equalTo(0)
                    case .half, .down:
                        make.height.equalTo(32)
                }
            } else {
                make.height.equalTo(0)
            }
        }

        instructorDivider.snp.remakeConstraints { make in
            make.width.centerX.equalToSuperview()
            make.top.equalTo(instructorDropdownFooter.snp.bottom)
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
        }
        
        updateTableFooterViews()
    }
    
    func setupDropdownHeaderViews() {
        let toggleClasses = UITapGestureRecognizer(target: self, action: #selector(self.dropClasses(sender:) ))
        classTypeDropdownHeader.addGestureRecognizer(toggleClasses)
           
        let toggleInstructors = UITapGestureRecognizer(target: self, action: #selector(self.dropInstructors(sender:) ))
        instructorDropdownHeader.addGestureRecognizer(toggleInstructors)
        
        classTypeDropdownHeader.updateDropdownHeader(selectedFilters: selectedClasses)
        instructorDropdownHeader.updateDropdownHeader(selectedFilters: selectedInstructors)
    }
    
    func updateTableFooterViews() {
        instructorDropdownFooter.showHideLabel.text = instructorDropdownData.dropStatus == .half
            ? ClientStrings.Filter.dropdownShowInstructors
            : ClientStrings.Dropdown.collapse
        classTypeDropdownFooter.showHideLabel.text = classTypeDropdownData.dropStatus == .half
            ? ClientStrings.Filter.dropdownShowClassTypes
            : ClientStrings.Dropdown.collapse
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

        let filterParameters = FilterParameters(classNames: selectedClasses, endTime: maxDate, gymIds: selectedGyms, instructorNames: selectedInstructors, shouldFilter: shouldFilter, startTime: minDate, tags: [])

        delegate?.filterOptions(params: filterParameters)

        dismiss(animated: true, completion: nil)
    }

    @objc func reset() {
        let minDate = timeRanges[0]
        let maxDate = timeRanges[timeRanges.count - 1]
        let filterParameters = FilterParameters(classNames: [], endTime: maxDate, gymIds: [], instructorNames: [], shouldFilter: false, startTime: minDate, tags: [])

        delegate?.filterOptions(params: filterParameters)

        dismiss(animated: true, completion: nil)

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
            instructorDropdownHeader.rotateArrowUp()
            instructorDropdownData.dropStatus = .up
            var i = 0
            while i < instructorDropdown.numberOfRows(inSection: 0) {
                modifiedIndices.append(IndexPath(row: i, section: 0))
                i += 1
            }
            instructorDropdown.deleteRows(at: modifiedIndices, with: .none)
        } else {
            instructorDropdownHeader.rotateArrowDown()
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
            classTypeDropdownHeader.rotateArrowUp()
            classTypeDropdownData.dropStatus = .up
            var i = 0
            while i < classTypeDropdown.numberOfRows(inSection: 0) {
                modifiedIndices.append(IndexPath(row: i, section: 0))
                i += 1
            }
            classTypeDropdown.deleteRows(at: modifiedIndices, with: .none)
        } else {
            classTypeDropdownHeader.rotateArrowDown()
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
            if !instructorDropdownData.completed {
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
            if !classTypeDropdownData.completed {
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
                    cell.checkBoxColoring.backgroundColor = .primaryYellow
                }
            }
        } else if tableView == classTypeDropdown {
            if indexPath.row < classTypeDropdownData.titles.count {
                cell.titleLabel.text = classTypeDropdownData.titles[indexPath.row]

                if selectedClasses.contains(classTypeDropdownData.titles[indexPath.row]) {
                    cell.checkBoxColoring.backgroundColor = .primaryYellow
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
        var shouldAppend: Bool = cell.checkBoxColoring.backgroundColor == .primaryYellow

        cell.checkBoxColoring.backgroundColor = shouldAppend ? .white : .primaryYellow
        shouldAppend = !shouldAppend

        if tableView == classTypeDropdown {
            if shouldAppend {
                selectedClasses.append(cell.titleLabel.text!)
            } else {
                for i in 0..<selectedClasses.count {
                    let name = selectedClasses[i]
                    if name == cell.titleLabel.text! {
                        selectedClasses.remove(at: i)
                        classTypeDropdownHeader.updateDropdownHeader(selectedFilters: selectedClasses)
                        return
                    }
                }
            }
            classTypeDropdownHeader.updateDropdownHeader(selectedFilters: selectedClasses)
        } else {
            if shouldAppend {
                selectedInstructors.append(cell.titleLabel.text!)
            } else {
                for i in 0..<selectedInstructors.count {
                    let name = selectedInstructors[i]
                    if name == cell.titleLabel.text! {
                        selectedInstructors.remove(at: i)
                        instructorDropdownHeader.updateDropdownHeader(selectedFilters: selectedInstructors)
                        return
                    }
                }
            }
            instructorDropdownHeader.updateDropdownHeader(selectedFilters: selectedInstructors)
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 32
    }
}
