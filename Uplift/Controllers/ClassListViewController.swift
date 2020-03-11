//
//  ClassListViewController.swift
//  Uplift
//
//  Created by Austin Astorga on 10/09/18.
//  Copyright © 2018 Uplift. All rights reserved.
//

import Crashlytics
import SnapKit
import UIKit

struct FilterParameters {
    var classNames: [String]
    var endTime: Date
    var gymIds: [String]
    var instructorNames: [String]
    var shouldFilter: Bool
    var startTime: Date
    var tags: [String]

    init(classNames: [String] = [],
         endTime: Date = Date(),
         gymIds: [String] = [],
         instructorNames: [String] = [],
         shouldFilter: Bool = false,
         startTime: Date = Date(),
         tags: [String] = []) {
        self.classNames = classNames
        self.endTime = endTime
        self.gymIds = gymIds
        self.instructorNames = instructorNames
        self.shouldFilter = shouldFilter
        self.startTime = startTime
        self.tags = tags
    }

}

class ClassListViewController: UIViewController {

    // MARK: - Private view vars
    private var calendarCollectionView: UICollectionView!
    private var classCollectionView: UICollectionView!
    private var filterButton: FilterButton!
    private var titleLabel: UILabel!
    private var titleView: UIView!

    private var noClassesEmptyStateView: NoClassesEmptyStateView!
    private var noResultsEmptyStateView: NoResultsEmptyStateView!

    // MARK: - Private data vars
    private var classList: [[GymClassInstance]] = Array.init(repeating: [], count: 10)
    private var currentFilterParams: FilterParameters?
    private var filteredClasses: [GymClassInstance] = []
    private var filteringIsActive = false

    private var numPendingNetworkRequests = 0
    
    private let loadingHeader = LoadingHeaderView(frame: .zero)
    private var loadingScrollView: LoadingScrollView!

    // MARK: - Calendar data vars
    private var calendarDatesList: [Date] = CalendarGenerator.getCalendarDates()
    lazy private var calendarDateSelected: Date = {
        return currDate
    }()
    private var currDate: Date!

    init() {
        super.init(nibName: nil, bundle: nil)
        initializeCollectionViews()
        // Set currDate to be today's date
        currDate = calendarDatesList[3]
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true

        setupViews()
        setupConstraints()

        getClassesFor(date: calendarDateSelected)
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }

    override func viewDidAppear(_ animated: Bool) {
        // Update filtering
        if let params = currentFilterParams {
            filterOptions(params: params)
        }
    }

    // MARK: - Public methods
    func updateCalendarDateSelectedToToday() {
        // Set the calendarDateSelected to be today
        calendarDateSelected = calendarDatesList[3]
        calendarCollectionView.reloadData()
        getClassesFor(date: calendarDateSelected)
        if currentFilterParams != nil {
            filterOptions(params: FilterParameters())
        }
    }

    // MARK: - Targets
    @objc func filterPressed() {
        let filterVC = FilterViewController(currentFilterParams: currentFilterParams)
        filterVC.delegate = self
        let filterNavController = UINavigationController(rootViewController: filterVC)
        tabBarController?.present(filterNavController, animated: true, completion: nil)
    }

    // MARK: - Private methods

    /// Get the list of classes for [date] and update classCollectionView with those classes.
    private func getClassesFor(date: Date) {
        guard let index = self.calendarDatesList.firstIndex(of: date) else { return }

        if classList[index].isEmpty {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"

            numPendingNetworkRequests += 1
            NetworkManager.shared.getGymClassesForDate(date: dateFormatter.string(from: date), completion: { [weak self] classes in
                guard let strongSelf = self else { return }

                strongSelf.classList[index] = classes.sorted(by: { $0.startTime < $1.startTime })
                strongSelf.updateClassCollectionViewWithFilters()

                strongSelf.decrementNumPendingNetworkRequests()
            })
            return
        }

        updateClassCollectionViewWithFilters()
    }

    /// Update classCollectionView with the current filters
    private func updateClassCollectionViewWithFilters() {
        if let filterParams = self.currentFilterParams {
            self.filterOptions(params: filterParams)
        } else {
            self.classCollectionView.reloadData()
        }
    }
    
    /// Set a new filter for the view controller
    func updateFilter(_ filter: FilterParameters) {
        self.currentFilterParams = filter
    }

    func decrementNumPendingNetworkRequests() {
        numPendingNetworkRequests -= 1
        if numPendingNetworkRequests == 0 {
            loadingHeader.isHidden = true
            loadingScrollView.isHidden = true
        }
    }
}

extension ClassListViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == classCollectionView {
            guard let indexOfSelectedDate = calendarDatesList.firstIndex(of: calendarDateSelected) else { return 0 }

            let selectedDaysClasses = classList[indexOfSelectedDate]
            let selectedDayHasNoClasses = selectedDaysClasses.isEmpty
            let filteredClassesIsEmpty = filteringIsActive && filteredClasses.isEmpty
            noClassesEmptyStateView.isHidden = !selectedDayHasNoClasses
            noResultsEmptyStateView.isHidden = !(filteredClassesIsEmpty && !selectedDayHasNoClasses)

            if filteringIsActive {
                return filteredClasses.count
            }

            return selectedDaysClasses.count
        }

        if collectionView == calendarCollectionView {
            return calendarDatesList.count
        }

        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == calendarCollectionView {
            return CalendarGenerator.getCalendarCell(collectionView, indexPath: indexPath, calendarDatesList: calendarDatesList, currDate: currDate, calendarDateSelected: calendarDateSelected)
        }

        guard let index = calendarDatesList.firstIndex(of: calendarDateSelected) else { return UICollectionViewCell() }
        //swiftlint:disable:next force_cast
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ClassListCell.identifier, for: indexPath) as! ClassListCell
        let gymClassInstance = filteringIsActive ? filteredClasses[indexPath.item] : classList[index][indexPath.item]
        cell.configure(gymClassInstance: gymClassInstance, style: .date)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == calendarCollectionView {
            calendarDateSelected = calendarDatesList[indexPath.item]
            calendarCollectionView.reloadData()
            getClassesFor(date: calendarDateSelected)
        } else if collectionView == classCollectionView {
            guard let index = calendarDatesList.firstIndex(of: calendarDateSelected) else { return }
            let gymClassInstance = filteringIsActive ? filteredClasses[indexPath.row] : classList[index][indexPath.row]
            let classDetailViewController = ClassDetailViewController(gymClassInstance: gymClassInstance)
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
        if collectionView == classCollectionView {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CalendarGenerator.classListHeaderViewIdentifier, for: indexPath) as! ClassListHeaderView

            var titleLabelText = ClientStrings.Calendar.todayLabel
            if currDate != calendarDateSelected {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMM d"
                titleLabelText = dateFormatter.string(from: calendarDateSelected)
            }
            headerView.configure(with: titleLabelText)
            return headerView
        }

        return UICollectionReusableView()
    }

}

// MARK: - Filtering Delegate
extension ClassListViewController: FilterDelegate {

    func filterOptions(params: FilterParameters) {

        filteringIsActive = params.shouldFilter
        filterButton.updateButton(filterActive: filteringIsActive)

        if filteringIsActive {
            currentFilterParams = params
            // MARK: - Fabric
            Answers.logCustomEvent(withName: "Applied Filters")
        } else {
            currentFilterParams = nil
            classCollectionView.reloadData()
            return
        }

        // Get the difference in days between startTime and calendarDateSelected
        let offset = Int(calendarDateSelected.timeIntervalSince(params.startTime) / Date.secondsPerDay)
        var components =  DateComponents()
        components.day = offset

        // Get the adjustedStart and adjustedEnd times
        let adjustedStart = CalendarGenerator.cal.date(byAdding: components, to: params.startTime) ?? params.startTime
        let adjustedEnd = CalendarGenerator.cal.date(byAdding: components, to: params.endTime) ?? params.endTime

        guard let indexOfSelectedDate = calendarDatesList.firstIndex(of: calendarDateSelected) else { return }

        // Get the list of valid classes that are in between the adjustedStart and adjustedEnd times
        filteredClasses = classList[indexOfSelectedDate].filter { currClass in
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

        // Reload classCollectionView with updated filteredClasses
        classCollectionView.reloadData()
    }
}

// MARK: - Layout
extension ClassListViewController {

    private func initializeCollectionViews() {
        let calendarFlowLayout = UICollectionViewFlowLayout()
        calendarFlowLayout.itemSize = CGSize(width: 24, height: 47)
        calendarFlowLayout.scrollDirection = .horizontal
        calendarFlowLayout.minimumLineSpacing = 40.0
        calendarFlowLayout.sectionInset = .init(top: 0.0, left: 16.0, bottom: 0.0, right: 16.0)

        calendarCollectionView = UICollectionView(frame: .zero, collectionViewLayout: calendarFlowLayout)

        let classFlowLayout = UICollectionViewFlowLayout()
        let screenWidth = UIScreen.main.bounds.width
        classFlowLayout.itemSize = CGSize(width: screenWidth - 32.0, height: 100.0)
        classFlowLayout.minimumLineSpacing = 12.0
        classFlowLayout.headerReferenceSize = .init(width: screenWidth - 32.0, height: 72.0)

        classCollectionView = UICollectionView(frame: .zero, collectionViewLayout: classFlowLayout)
    }

    private func setupViews() {
        setupCollectionViews()

        titleView = UIView()
        titleView.backgroundColor = .white
        titleView.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        titleView.layer.shadowOpacity = 0.4
        titleView.layer.shadowRadius = 10.0
        titleView.layer.shadowColor = UIColor.buttonShadow.cgColor
        titleView.layer.masksToBounds = false
        titleView.clipsToBounds = false
        view.addSubview(titleView)

        titleLabel = UILabel()
        titleLabel.font = ._24MontserratBold
        titleLabel.textColor = .primaryBlack
        titleLabel.text = ClientStrings.ClassList.vcTitleLabel
        titleView.addSubview(titleLabel)

        noClassesEmptyStateView = NoClassesEmptyStateView()
        view.addSubview(noClassesEmptyStateView)

        noResultsEmptyStateView = NoResultsEmptyStateView()
        view.addSubview(noResultsEmptyStateView)

        filterButton = FilterButton()
        filterButton.addTarget(self, action: #selector(filterPressed), for: .touchUpInside)
        view.addSubview(filterButton)

        view.addSubview(loadingHeader)

        loadingScrollView = LoadingScrollView(frame: .zero, collectionViewTypes: [.calendar, .classes], collectionViewWidth: view.bounds.width)
        view.addSubview(loadingScrollView)
    }

    private func setupConstraints() {
        let calendarCollectionViewHeight = 47
        let calendarCollectionViewTopPadding = 40
        let classCollectionViewTopPadding = 18
        let filterButtonBottomPadding = 18
        let filterButtonSize = CGSize(width: 164, height: 46)
        let titleBottomConstant = -20
        let titleHeightConstant = 26
        let titleLeadingConstant = 24
        let titleViewHeightConstant = 120
        let noClassesEmptyStateViewTopOffset = 92

        titleView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(titleViewHeightConstant)
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(titleLeadingConstant)
            make.bottom.equalToSuperview().offset(titleBottomConstant)
            make.height.equalTo(titleHeightConstant)
            make.trailing.lessThanOrEqualTo(titleView)
        }

        calendarCollectionView.snp.makeConstraints { make in
            make.top.equalTo(titleView.snp.bottom)
                .offset(calendarCollectionViewTopPadding)
            make.height.equalTo(calendarCollectionViewHeight)
            make.leading.trailing.equalToSuperview()
        }

        classCollectionView.snp.makeConstraints { make in
            make.top.equalTo(calendarCollectionView.snp.bottom).offset(classCollectionViewTopPadding)
            make.leading.trailing.bottom.equalToSuperview()
        }

        noClassesEmptyStateView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(classCollectionView)
            make.top.equalTo(calendarCollectionView.snp.bottom).offset(noClassesEmptyStateViewTopOffset)
        }

        noResultsEmptyStateView.snp.makeConstraints { make in
            make.edges.equalTo(classCollectionView)
        }

        filterButton.snp.makeConstraints { make in
            make.size.equalTo(filterButtonSize)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(filterButtonBottomPadding)
            make.centerX.equalToSuperview()
        }

        loadingHeader.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(titleViewHeightConstant)
        }

        loadingScrollView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(loadingHeader.snp.bottom)
        }
    }

    private func setupCollectionViews() {
        calendarCollectionView.delegate = self
        calendarCollectionView.dataSource = self
        calendarCollectionView.showsHorizontalScrollIndicator = false
        calendarCollectionView.backgroundColor = .white
        calendarCollectionView.register(CalendarCell.self, forCellWithReuseIdentifier: CalendarGenerator.calendarCellIdentifier)
        calendarCollectionView.layer.zPosition = -1
        view.addSubview(calendarCollectionView)

        classCollectionView.delegate = self
        classCollectionView.dataSource = self
        classCollectionView.contentInset = .init(top: 0.0, left: 0.0, bottom: 84.0, right: 0.0)
        classCollectionView.backgroundColor = .white
        classCollectionView.delaysContentTouches = false
        classCollectionView.register(ClassListHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CalendarGenerator.classListHeaderViewIdentifier)
        classCollectionView.register(ClassListCell.self, forCellWithReuseIdentifier: ClassListCell.identifier)
        view.addSubview(classCollectionView)
    }

}
