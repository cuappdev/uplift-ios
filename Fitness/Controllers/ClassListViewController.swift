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
    var endTime: Date
    var instructorNames: [String]
    var classNames: [String]
    var gymIds: [String]
    var tags: [String]
    
    init() {
        shouldFilter = false
        startTime = Date()
        endTime = startTime
        instructorNames = []
        classNames = []
        gymIds = []
        tags = []
    }
    
    init(applyFilter: Bool, startingTime: Date,  endingTime: Date, instructorsNames: [String], classesNames: [String], gymsIds: [String], tagsNames: [String]) {
        shouldFilter = applyFilter
        startTime = startingTime
        endTime = endingTime
        instructorNames = instructorsNames
        classNames = classesNames
        gymIds = gymsIds
        tags = tagsNames
    }
}

class ClassListViewController: UIViewController {

    let daysOfWeek = ["Su", "M", "T", "W", "Th", "F", "Sa"]
    let cal = Calendar.current
    let currDate: Date!

    var calendarCollectionView: UICollectionView!
    var classCollectionView: UICollectionView!
    var searchBar: UISearchBar!
    var filterButton: UIButton!
    var titleLabel: UILabel!
    var titleView: UIView!

    var noClassesEmptyStateView: NoClassesEmptyStateView!
    var noResultsEmptyStateView: NoResultsEmptyStateView!

    var classList: [[GymClassInstance]] = Array.init(repeating: [], count: 10)
    var filteredClasses: [GymClassInstance] = []
    var filteringIsActive = false
    var currentFilterParams: FilterParameters?
    var calendarDatesList: [Date] = []
    lazy var calendarDateSelected: Date = {
        return currDate
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        calendarDatesList = ClassListViewController.createCalendarDates()
        currDate = calendarDatesList[3]
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        initializeCollectionViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .white

        searchBar = UISearchBar()
        searchBar.showsCancelButton = false
        searchBar.delegate = self
        searchBar.placeholder = "find a way to sweat"
        searchBar.searchTextPositionAdjustment = UIOffset(horizontal: 2.0, vertical: 0)
        searchBar.tintColor = UIColor.fitnessDarkGrey
        searchBar.changeSearchBarColor(color: .white)

        let textfield = searchBar.value(forKey: "searchField") as? UITextField
        textfield?.textColor = UIColor.fitnessBlack
        textfield?.font = ._12MontserratRegular
        textfield?.layer.borderWidth = 1.0
        textfield?.layer.borderColor = UIColor.fitnessMediumGrey.cgColor
        textfield?.layer.cornerRadius = 18.0

        navigationController?.isNavigationBarHidden = true

        titleView = UIView()
        titleView.backgroundColor = .white
        titleView.layer.shadowOffset = CGSize(width: 0, height: 9)
        titleView.layer.shadowColor = UIColor.buttonShadow.cgColor
        titleView.layer.shadowOpacity = 0.25
        titleView.clipsToBounds = false
        view.addSubview(titleView)
        
        titleLabel = UILabel()
        titleLabel.font = ._24MontserratBold
        titleLabel.textColor = .fitnessBlack
        titleLabel.text = "CLASSES"
        titleView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {make in
            make.leading.equalToSuperview().offset(24)
            make.bottom.equalToSuperview().offset(-20)
            make.height.equalTo(26)
            make.trailing.lessThanOrEqualTo(titleView)
        }

        titleView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(120)
        }
        
//        navigationItem.titleView = searchBar
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)

        noClassesEmptyStateView = NoClassesEmptyStateView()
        noResultsEmptyStateView = NoResultsEmptyStateView()

        setupCollectionViews()

        view.addSubview(noClassesEmptyStateView)
        noClassesEmptyStateView.snp.makeConstraints { make in
            make.edges.equalTo(classCollectionView)
        }
        view.addSubview(noResultsEmptyStateView)
        noResultsEmptyStateView.snp.makeConstraints { make in
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

    override func viewWillAppear(_ animated: Bool) {
        navigationController!.isNavigationBarHidden = true
    }

    override func viewDidAppear(_ animated: Bool) {
        // Update favorited
        for cell in classCollectionView.visibleCells {
            let classCell = cell as! ClassListCell
            classCell.classId = {classCell.classId}()
        }

        // Update filtering
        if let params = currentFilterParams {
            filterOptions(params: params)
        }
    }

    static func createCalendarDates() -> [Date] {
        let cal = Calendar.current
        let currDate = Date()
        
        guard let startDate = cal.date(byAdding: .day, value: -3, to: currDate) else { return  [] }
        guard let endDate = cal.date(byAdding: .day, value: 6, to: currDate) else { return [] }

        var dateList: [Date] = []
        var date = startDate
        while date <= endDate {
            dateList.append(date)
            date = cal.date(byAdding: .day, value: 1, to: date) ?? Date()
        }
        
        return dateList
    }

    @objc func filterPressed() {
        let filterVC = FilterViewController(currentFilterParams: currentFilterParams)
        filterVC.delegate = self
        let filterNavController = UINavigationController(rootViewController: filterVC)
        tabBarController?.present(filterNavController, animated: true, completion: nil)
    }
    
    func initializeCollectionViews() {
        let calendarFlowLayout = UICollectionViewFlowLayout()
        calendarFlowLayout.itemSize = CGSize(width: 24, height: 47)
        calendarFlowLayout.scrollDirection = .horizontal
        calendarFlowLayout.minimumLineSpacing = 40.0
        calendarFlowLayout.sectionInset = .init(top: 0.0, left: 16.0, bottom: 0.0, right: 16.0)

        calendarCollectionView = UICollectionView(frame: .zero, collectionViewLayout: calendarFlowLayout)
        calendarCollectionView.delegate = self
        calendarCollectionView.dataSource = self
        
        let classFlowLayout = UICollectionViewFlowLayout()
        classFlowLayout.itemSize = CGSize(width: UIScreen.main.bounds.width - 32.0, height: 100.0)
        classFlowLayout.minimumLineSpacing = 12.0
        classFlowLayout.headerReferenceSize = .init(width: UIScreen.main.bounds.width - 32.0, height: 72.0)
        
        classCollectionView = UICollectionView(frame: .zero, collectionViewLayout: classFlowLayout)
        classCollectionView.delegate = self
        classCollectionView.dataSource = self
    }

    func setupCollectionViews() {
        calendarCollectionView.showsHorizontalScrollIndicator = false
        calendarCollectionView.backgroundColor = .white
        calendarCollectionView.register(CalendarCell.self, forCellWithReuseIdentifier: CalendarCell.identifier)
        view.addSubview(calendarCollectionView)
        calendarCollectionView.snp.makeConstraints { make in
            make.top.equalTo(titleView.snp.bottom).offset(40.0)
            make.height.equalTo(47)
            make.leading.trailing.equalToSuperview()
        }
        
        classCollectionView.backgroundColor = .white
        classCollectionView.delaysContentTouches = false
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
        
        guard let index = self.calendarDatesList.firstIndex(of: date) else { return }
        if classList[index].isEmpty {
            NetworkManager.shared.getGymClassesForDate(date: dateFormatter.string(from: date)) { classes in
                self.classList[index] = classes
                
                if let filterParams = self.currentFilterParams {
                    self.filterOptions(params: filterParams)
                } else {
                    self.classCollectionView.reloadData()
                }
            }
        } else {
            if let filterParams = self.currentFilterParams {
                self.filterOptions(params: filterParams)
            } else {
                self.classCollectionView.reloadData()
            }
        }
    }
}

extension ClassListViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        if collectionView == classCollectionView {
            noClassesEmptyStateView.isHidden = !classList[calendarDatesList.firstIndex(of: calendarDateSelected)!].isEmpty
            noResultsEmptyStateView.isHidden = !((filteringIsActive && filteredClasses.isEmpty) && !classList[calendarDatesList.firstIndex(of: calendarDateSelected)!].isEmpty)
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
            cell.dateLabel.font = ._12MontserratRegular
            cell.dayOfWeekLabel.font = ._12MontserratRegular

            if dateForCell < currDate {
                cell.dateLabel.textColor = .fitnessMediumGrey
                cell.dayOfWeekLabel.textColor = .fitnessMediumGrey
            }

            if dateForCell == calendarDateSelected {
                cell.dateLabelCircle.isHidden = false
                cell.dateLabel.textColor = .white
                cell.dateLabel.font = ._12MontserratSemiBold
                cell.dayOfWeekLabel.font = ._12MontserratSemiBold
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
        cell.classId = classForCell.classDetailId

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == calendarCollectionView {
            calendarDateSelected = calendarDatesList[indexPath.item]
            calendarCollectionView.reloadData()
            getClassesFor(date: calendarDateSelected)
        } else if collectionView == classCollectionView {
            let classDetailViewController = ClassDetailViewController()
            guard let index = calendarDatesList.firstIndex(of: calendarDateSelected) else { return }
            classDetailViewController.gymClassInstance = filteringIsActive ? filteredClasses[indexPath.row] : classList[index][indexPath.row]
            navigationController?.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(classDetailViewController, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        if collectionView == classCollectionView {
            guard let cell = collectionView.cellForItem(at: indexPath) else { return }
            UIView.animate(withDuration: 0.35, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: [], animations: {
                cell.transform = CGAffineTransform(scaleX: 0.96, y: 0.96)
            }, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        if collectionView == classCollectionView {
            guard let cell = collectionView.cellForItem(at: indexPath) else { return }
            UIView.animate(withDuration: 0.35, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: [], animations: {
                cell.transform = .identity
            }, completion: nil)
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
        filteredClasses = filteredClasses.filter {
            $0.className.lowercased().contains(searchText.lowercased()) ||
            $0.classDescription.lowercased().contains(searchText.lowercased()) ||
            $0.gymId.lowercased().contains(searchText.lowercased()) ||
            $0.instructor.lowercased().contains(searchText.lowercased()) ||
            $0.location.lowercased().contains(searchText.lowercased())
        }
        classCollectionView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    @objc func dismissKeyboard(){
        searchBar.endEditing(true)
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

        let offset = Int(calendarDateSelected.timeIntervalSince(params.startTime))/86400
        var components =  DateComponents()
        components.day = offset
        
        let adjustedStart = cal.date(byAdding: components, to: params.startTime) ?? params.startTime
        let adjustedEnd = cal.date(byAdding: components, to: params.endTime) ?? params.endTime
        
        filteredClasses = classList[calendarDatesList.firstIndex(of: calendarDateSelected)!]
        filteredClasses = filteredClasses.filter { currClass in
            guard currClass.startTime >= adjustedStart, currClass.endTime <= adjustedEnd else { return false }
            
            if !params.gymIds.isEmpty {
                guard params.gymIds.contains(currClass.gymId) else { return false }
            }
            if !params.classNames.isEmpty {
                guard params.classNames.contains(currClass.className) else { return false }
            }

            if !params.instructorNames.isEmpty {
                guard params.instructorNames.contains(currClass.instructor) else { return false }
            }

            if !params.tags.isEmpty {
                guard (currClass.tags.contains { tag in
                    return params.tags.contains(tag.name)}) else { return false }
            }

            return true
        }
        classCollectionView.reloadData()
    }
}
