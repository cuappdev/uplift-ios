//
//  ClassListViewController.swift
//  Fitness
//
//  Created by Austin Astorga on 10/09/18.
//  Copyright © 2018 Uplift. All rights reserved.
//

import UIKit
import SnapKit

struct FilterParameters {
    var shouldFilter: Bool
    var startTime: Date
    var encodedStartTime: Double
    var endTime: Date
    var encodedEndTime: Double
    var instructorNames: [String]
    var classNames: [String]
    var gymIds: [String]
}

class ClassListViewController: UIViewController {

    let daysOfWeek = ["Su", "M", "T", "W", "Th", "F", "Sa"]
    let cal = Calendar.current
    let currDate = Date()

    var calendarCollectionView: UICollectionView!
    var classCollectionView: UICollectionView!
    var searchBar: UISearchBar!
    var filterButton: UIButton!

    var noClassesEmptyStateView: NoClassesEmptyStateView!

    var classList: [[GymClassInstance]] = []
    var filteredClasses: [GymClassInstance] = []
    var filteringIsActive = false
    var currentFilterParams: FilterParameters?
    var calendarDatesList: [Date] = []
    lazy var calendarDateSelected: Date = {
        return currDate
    }()

    override func viewDidLoad() {
        view.backgroundColor = .white
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()

        searchBar = UISearchBar()
        searchBar.showsCancelButton = false
        searchBar.delegate = self
        searchBar.placeholder = "find a way to sweat"
        searchBar.changeSearchBarColor(color: .white)

        let textfield = searchBar.value(forKey: "searchField") as? UITextField
        textfield?.textColor = UIColor.fitnessBlack
        textfield?.font = ._12MontserratRegular
        textfield?.layer.borderWidth = 1.0
        textfield?.layer.borderColor = UIColor.fitnessMediumGrey.cgColor
        textfield?.layer.cornerRadius = 18.0

        navigationItem.titleView = searchBar

        noClassesEmptyStateView = NoClassesEmptyStateView()

        createCalendarDates()
        setupCollectionViews()

        view.addSubview(noClassesEmptyStateView)
        noClassesEmptyStateView.snp.makeConstraints { make in
            make.edges.equalTo(classCollectionView)
        }

        getClassesFor(date: calendarDateSelected)

        filterButton = UIButton()
        filterButton.setTitle("APPLY FILTER", for: .normal)
        filterButton.titleLabel?.font = ._14MontserratSemiBold
        filterButton.layer.cornerRadius = 24.0
        filterButton.setTitleColor(.black, for: .normal)
        filterButton.backgroundColor = .white
        filterButton.addTarget(self, action: #selector(filterPressed), for: .touchUpInside)

        view.addSubview(filterButton)

        filterButton.snp.makeConstraints { make in
            make.width.equalTo(180.0)
            make.height.equalTo(48)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(36)
            make.centerX.equalToSuperview()
        }

        classCollectionView.contentInset = .init(top: 0.0, left: 0.0, bottom: 84.0, right: 0.0)

        view.layoutIfNeeded()
        filterButton.layer.shadowColor = UIColor.fitnessBlack.cgColor
        filterButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        filterButton.layer.shadowRadius = 2.0
        filterButton.layer.shadowOpacity = 0.2
        filterButton.layer.masksToBounds = false
    }

    func createCalendarDates() {
        guard let startDate = cal.date(byAdding: .day, value: -3, to: currDate) else { return }
        guard let endDate = cal.date(byAdding: .day, value: 6, to: currDate) else { return }

        var date = startDate
        while date <= endDate {
            calendarDatesList.append(date)
            classList.append([])
            date = cal.date(byAdding: .day, value: 1, to: date) ?? Date()
        }
    }

    @objc func filterPressed() {
        let filterVC = FilterViewController(currentFilterParams: currentFilterParams)
        filterVC.delegate = self
        let filterNavController = UINavigationController(rootViewController: filterVC)
        tabBarController?.present(filterNavController, animated: true, completion: nil)
    }

    func setupCollectionViews() {
        let calendarFlowLayout = UICollectionViewFlowLayout()
        calendarFlowLayout.itemSize = CGSize(width: 24, height: 47)
        calendarFlowLayout.scrollDirection = .horizontal
        calendarFlowLayout.minimumLineSpacing = 40.0
        calendarFlowLayout.sectionInset = .init(top: 0.0, left: 16.0, bottom: 0.0, right: 16.0)

        calendarCollectionView = UICollectionView(frame: .zero, collectionViewLayout: calendarFlowLayout)
        calendarCollectionView.showsHorizontalScrollIndicator = false
        calendarCollectionView.delegate = self
        calendarCollectionView.dataSource = self
        calendarCollectionView.backgroundColor = .white
        calendarCollectionView.register(CalendarCell.self, forCellWithReuseIdentifier: CalendarCell.identifier)
        view.addSubview(calendarCollectionView)
        calendarCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(40.0)
            make.height.equalTo(47)
            make.leading.trailing.equalToSuperview()
        }

        let classFlowLayout = UICollectionViewFlowLayout()
        classFlowLayout.itemSize = CGSize(width: view.bounds.width - 32.0, height: 100.0)
        classFlowLayout.minimumLineSpacing = 12.0
        classFlowLayout.headerReferenceSize = .init(width: view.bounds.width - 32.0, height: 72.0)

        classCollectionView = UICollectionView(frame: .zero, collectionViewLayout: classFlowLayout)
        classCollectionView.delegate = self
        classCollectionView.dataSource = self
        classCollectionView.backgroundColor = .white
         classCollectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "class-list-header")
        classCollectionView.register(ClassListCell.self, forCellWithReuseIdentifier: ClassListCell.identifier)
        view.addSubview(classCollectionView)
        classCollectionView.snp.makeConstraints { make in
            make.top.equalTo(calendarCollectionView.snp.bottom).offset(18)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }

    func getClassesFor(date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        NetworkManager.shared.getGymClassesForDate(date: dateFormatter.string(from: date)) { classes in
            guard let index = self.calendarDatesList.firstIndex(of: date) else { return }
            self.classList[index] = classes
            self.classCollectionView.reloadData()

            if let filterParams = self.currentFilterParams {
                self.filterOptions(params: filterParams)
            }
        }
    }
}

extension ClassListViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        if collectionView == classCollectionView {
            noClassesEmptyStateView.isHidden = !classList[calendarDatesList.firstIndex(of: calendarDateSelected)!].isEmpty
        }

        if collectionView == calendarCollectionView {
            return calendarDatesList.count
        }

        if filteringIsActive {
            return filteredClasses.count
        }

        return classList[calendarDatesList.firstIndex(of: calendarDateSelected)!].count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == calendarCollectionView {
            //swiftlint:disable:next force_cast
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarCell.identifier, for: indexPath) as! CalendarCell
            let dateForCell = calendarDatesList[indexPath.item]
            let dayOfWeek = cal.component(.weekday, from: dateForCell) - 1
            let dayOfMonth = cal.component(.day, from: dateForCell)
            cell.dayOfWeekLabel.text = daysOfWeek[dayOfWeek]
            cell.dateLabel.text = "\(dayOfMonth)"

            if dateForCell < currDate {
                cell.dateLabel.textColor = .fitnessMediumGrey
                cell.dayOfWeekLabel.textColor = .fitnessMediumGrey
            }

            if dateForCell == calendarDateSelected {
                cell.dateLabelCircle.isHidden = false
                cell.dateLabel.textColor = .white
            }
            return cell
        }

         guard let index = calendarDatesList.firstIndex(of: calendarDateSelected) else { return UICollectionViewCell() }
        let classForCell = filteringIsActive ? filteredClasses[indexPath.item] : classList[index][indexPath.item]
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a"
        //swiftlint:disable:next force_cast
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ClassListCell.identifier, for: indexPath) as! ClassListCell
        cell.classLabel.text = classForCell.className
        cell.durationLabel.text = "\(Int(classForCell.duration / 60.0)) min"
        cell.timeLabel.text = timeFormatter.string(from: classForCell.startTime)
        cell.instructorLabel.text = classForCell.instructor
        cell.locationLabel.text = classForCell.location
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == calendarCollectionView {
            calendarDateSelected = calendarDatesList[indexPath.item]
            calendarCollectionView.reloadData()
            getClassesFor(date: calendarDateSelected)
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        if collectionView == calendarCollectionView { return UICollectionReusableView() }

        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "class-list-header", for: indexPath)
            headerView.subviews.forEach { $0.removeFromSuperview() }
            let titleLabel = UILabel()
            titleLabel.font = ._14MontserratSemiBold
            titleLabel.textColor = .fitnessDarkGrey
            titleLabel.textAlignment = .center
            if currDate == calendarDateSelected {
                titleLabel.text = "TODAY"
            } else {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMM d"
                titleLabel.text = dateFormatter.string(from: calendarDateSelected)
            }

            headerView.addSubview(titleLabel)
            titleLabel.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.top.equalToSuperview().offset(18)
                make.leading.trailing.equalToSuperview()
                make.height.equalTo(titleLabel.intrinsicContentSize.height)
            }
            return headerView
        default:
            fatalError("Unexpected element kind")
        }
    }

}

extension ClassListViewController: UISearchBarDelegate {

    // MARK: - SEARCHING
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteringIsActive = false
            classCollectionView.reloadData()
            return
        }
        filteringIsActive = true
        filteredClasses = classList[calendarDatesList.firstIndex(of: calendarDateSelected)!]
        filteredClasses = filteredClasses.filter { $0.className.lowercased().contains(searchText.lowercased())}
        classCollectionView.reloadData()
    }
}

// MARK: - Filtering Delegate
extension ClassListViewController: FilterDelegate {

    func filterOptions(params: FilterParameters) {

        filteringIsActive = params.shouldFilter

        if filteringIsActive {
            currentFilterParams = params

            // Modify Button
            filterButton.backgroundColor = .fitnessYellow
            filterButton.setTitle("APPLIED FILTER", for: .normal)
        } else {
            currentFilterParams = nil
            // Modify Button
            filterButton.backgroundColor = .white
            filterButton.setTitle("APPLY FILTER", for: .normal)
            classCollectionView.reloadData()
            return
        }

        filteredClasses = classList[calendarDatesList.firstIndex(of: calendarDateSelected)!]
        filteredClasses = filteredClasses.filter { currClass in
            guard currClass.startTime >= params.startTime,
                currClass.endTime <= params.endTime
                else { return false }

            if !params.gymIds.isEmpty {
                guard params.gymIds.contains(currClass.gymId) else { return false }
            }
            if !params.classNames.isEmpty {
                guard params.classNames.contains(currClass.className) else { return false }
            }

            if !params.instructorNames.isEmpty {
                guard params.instructorNames.contains(currClass.instructor) else { return false }
            }
            return true
        }
        classCollectionView.reloadData()
    }
}

/* class ClassListViewController: UITableViewController, UISearchBarDelegate {

    // MARK: - INITIALIZATION
    var allGymClassInstances: [GymClassInstance]?
    var validGymClassInstances: [GymClassInstance]?

    var locations: [Int: String]!

    var selectedDate: String!

    var filterParameters: FilterParameters!

    var shouldFilterBySearchbar: Bool!
    var filterText: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        selectedDate = dateFormatter.string(from: Date())

        filterParameters = FilterParameters(shouldFilter: false, startTime: "6:00AM", encodedStartTime: 0, endTime: "10:00PM", encodedEndTime: 960, instructorNames: [], classNames: [], gymIds: [])

        tableView = UITableView(frame: .zero, style: .grouped)
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false

        tableView.register(ClassListHeaderView.self, forHeaderFooterViewReuseIdentifier: ClassListHeaderView.identifier)
        tableView.register(ClassListCell.self, forCellReuseIdentifier: ClassListCell.identifier)

        let searchBar = SearchBar.createSearchBar()
        searchBar.delegate = self
        shouldFilterBySearchbar = false
        filterText = ""

        self.navigationItem.titleView = searchBar

        let filterBarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "filter"), style: .plain, target: self, action: #selector(filter))
        filterBarButton.tintColor = .fitnessBlack
        self.navigationItem.rightBarButtonItem = filterBarButton

        let resetBarButton = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(reset))
        resetBarButton.tintColor = .fitnessBlack
        self.navigationItem.leftBarButtonItem = resetBarButton

        view.backgroundColor = .white



        updateGymClasses()
    }

    override func viewDidAppear(_ animated: Bool) {
        navigationController!.isNavigationBarHidden = false
        tabBarController!.tabBar.isHidden = false

        if (filterParameters.shouldFilter) {
            // update gyms given filter
            filterParameters.shouldFilter = false
        }

    }

    func updateGymClasses() {
        if filterParameters.shouldFilter {
            AppDelegate.networkManager.getGymClassInstancesSearch(startTime: filterParameters.startTime, endTime: filterParameters.endTime,
                                                                  instructorIDs: filterParameters.instructorNames, gymIDs: filterParameters.gymIds,
                                                                  classNames: filterParameters.classNames) { (gymClassInstances) in
                self.allGymClassInstances = gymClassInstances
                self.validGymClassInstances = self.getValidGymClassInstances()

                self.locations = [:] // temp, will be included in a GymClassInstance soon
            }
        } else {
            NetworkManager.shared.getGymClassesForDate(date: selectedDate) { (gymClassInstances) in
                self.allGymClassInstances = gymClassInstances
                self.validGymClassInstances = self.getValidGymClassInstances()
                self.tableView.reloadData()
                self.locations = [:] // temp, will be included in a GymClassInstance soon
            }
        }
    }

    // MARK: - TABLEVIEW
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if let numberOfRows = validGymClassInstances?.count {
            return numberOfRows
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ClassListCell.identifier, for: indexPath) as! ClassListCell

        if let gymClassInstance = validGymClassInstances?[indexPath.row] {

            cell.classLabel.text = gymClassInstance.className
            cell.timeLabel.text = Date.getStringDate(date: gymClassInstance.startTime)
            cell.timeLabel.text = cell.timeLabel.text?.removeLeadingZero()
            cell.instructorLabel.text = gymClassInstance.instructor

            cell.duration = Int(gymClassInstance.duration) / 60 //Gets minutes
            cell.durationLabel.text = "\(String(describing: cell.duration)) min"
            cell.locationLabel.text = gymClassInstance.location
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 112
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ClassListHeaderView.identifier) as! ClassListHeaderView

        //header.delegate = self
        return header
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 155
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let classDetailViewController = ClassDetailViewController()
        let cell = tableView.cellForRow(at: indexPath) as! ClassListCell

        classDetailViewController.gymClassInstance = allGymClassInstances![indexPath.row]
        classDetailViewController.durationLabel.text = cell.durationLabel.text?.uppercased()
        classDetailViewController.locationLabel.text = cell.locationLabel.text

        Alamofire.request(allGymClassInstances![indexPath.row].imageURL).responseImage { response in
            if let image = response.result.value {
                classDetailViewController.classImageView.image = image
            }
        }

        //DATE
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let day = dateFormatter.date(from: self.selectedDate) ?? Date()

        dateFormatter.dateFormat = "EEEE"
        var dateLabel = dateFormatter.string(from: day)
        dateFormatter.dateFormat = "MMMM"
        dateLabel += ", " + dateFormatter.string(from: day)
        dateFormatter.dateFormat = "d"
        dateLabel += " " + dateFormatter.string(from: day)
        classDetailViewController.dateLabel.text = dateLabel

        //TIME
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: "EDT")!
        let classInstance = classDetailViewController.gymClassInstance!
        dateFormatter.dateFormat = "h:mm a"
        classDetailViewController.timeLabel.text = dateFormatter.string(from: classInstance.startTime) + " - " + dateFormatter.string(from: classInstance.endTime)

        navigationController!.pushViewController(classDetailViewController, animated: true)
    }

    // MARK: - SEARCHING
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if (searchText != "") {
            shouldFilterBySearchbar = true
        }
        filterText = searchText
        validGymClassInstances = getValidGymClassInstances()
        tableView.reloadData()
        shouldFilterBySearchbar = false
    }

    //Returns all valid gymClassInstances to display
    func getValidGymClassInstances() -> [GymClassInstance] {
        var validInstances: [GymClassInstance] = []

        if (shouldFilterBySearchbar == false) {
            return allGymClassInstances!
        }

        for gymClassInstance in allGymClassInstances! {
            let className = gymClassInstance.className
            if className.contains(filterText) {
                validInstances.append(gymClassInstance)
            }
        }

        return validInstances
    }

    //called by header when new date is selected
    func updateDate() {
        updateGymClasses()
    }

    // MARK: - FILTER
    @objc func filter() {
        let filterViewController = FilterViewController()
        //account for if they .shouldfilter
        filterViewController.selectedGyms = filterParameters.gymIds
        filterViewController.selectedClasses = filterParameters.classNames
        filterViewController.selectedInstructors = filterParameters.instructorNames
        filterViewController.startTime = filterParameters.startTime
        filterViewController.endTime = filterParameters.endTime

        filterViewController.startTimeSliderStartRange[0] = filterParameters.encodedStartTime
        filterViewController.startTimeSliderStartRange[1] = filterParameters.encodedEndTime

        navigationController!.pushViewController(filterViewController, animated: true)
    }

    @objc func reset() {
        filterParameters.shouldFilter = false
        //update data
    }
} */
