//
//  SportsFilterViewController.swift
//  Uplift
//
//  Created by Artesia Ko on 4/11/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import SnapKit
import UIKit

protocol SportsFilterDelegate: class {

    func filterOptions(params: SportsFilterParameters?)

}

class SportsFilterViewController: UIViewController {

    private let filterSections: [SportsFilterSection] = [.gym, .startTime, .numPlayers, .sports]

    private var filterOptionsCollectionView: UICollectionView!

    weak var delegate: SportsFilterDelegate?

    var sportsTypeDropdownData: DropdownData!

    init(currentFilterParams: SportsFilterParameters?) {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        view.backgroundColor = .white

        //NAVIGATION BAR
        setupNavBar()

        let layout = UICollectionViewFlowLayout()
        filterOptionsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        filterOptionsCollectionView.register(SportsFilterGymCollectionViewCell.self, forCellWithReuseIdentifier: Identifiers.sportsFilterGymCell)
        filterOptionsCollectionView.register(SportsFilterStartTimeCollectionViewCell.self, forCellWithReuseIdentifier: Identifiers.sportsFilterStartTimeCell)
        filterOptionsCollectionView.register(SportsFilterNumPlayersCollectionViewCell.self, forCellWithReuseIdentifier: Identifiers.sportsFilterNumPlayersCell)
        filterOptionsCollectionView.register(SportsFilterSportsDropdownCollectionViewCell.self, forCellWithReuseIdentifier: Identifiers.sportsFilterSportsDropdownCell)
        filterOptionsCollectionView.delegate = self
        filterOptionsCollectionView.dataSource = self
        filterOptionsCollectionView.backgroundColor = .clear
        view.addSubview(filterOptionsCollectionView)

        setupConstraints()

        sportsTypeDropdownData = DropdownData(completed: false, dropStatus: .up, titles: [])

        // TODO: replace with networked sports.
        let sportsNames = ["Basketball", "Soccer", "Table Tennis", "Frisbee", "A", "B", "C"]
        sportsTypeDropdownData.titles.append(contentsOf: sportsNames)
        sportsTypeDropdownData.completed = true
    }

    func setupNavBar() {
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
    }

    @objc func done() {
        filterOptionsCollectionView.reloadData()
    }

    @objc func reset() {

    }

    func setupConstraints() {
        filterOptionsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}

extension SportsFilterViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterSections.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch filterSections[indexPath.row] {
        case .gym:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.sportsFilterGymCell, for: indexPath) as! SportsFilterGymCollectionViewCell
            return cell
        case .startTime:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.sportsFilterStartTimeCell, for: indexPath) as! SportsFilterStartTimeCollectionViewCell
            return cell
        case .numPlayers:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.sportsFilterNumPlayersCell, for: indexPath) as! SportsFilterNumPlayersCollectionViewCell
            return cell
        case .sports:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.sportsFilterSportsDropdownCell, for: indexPath) as! SportsFilterSportsDropdownCollectionViewCell
            cell.delegate = self
            cell.configure(for: sportsTypeDropdownData)
            return cell
        }
    }

}

extension SportsFilterViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        var height: CGFloat = 0
        switch filterSections[indexPath.row] {
        case .gym:
            height = SportsFilterGymCollectionViewCell.height
        case .startTime:
            height = SportsFilterStartTimeCollectionViewCell.height
        case .numPlayers:
            height = SportsFilterNumPlayersCollectionViewCell.height
        case .sports:
            if let cell = collectionView.cellForItem(at: indexPath) as? SportsFilterSportsDropdownCollectionViewCell {
                height = cell.getDropdownHeight()
            } else {
                height = SportsFilterSportsDropdownCollectionViewCell.initialHeight
            }
        }
        return CGSize(width: width, height: height)
    }

}

extension SportsFilterViewController: DropdownHeaderViewDelegate {

    func didTapHeaderView() {
        <#code#>
    }

}

extension SportsFilterViewController: DropdownViewDelegate {

    func dropdownStatusChanged(to status: DropdownStatus, with height: CGFloat) {
        <#code#>
    }

}

//extension SportsFilterViewController: SportsFilterDropdown {
//
//    func dropdownStatusChanged(to status: DropdownStatus, with height: CGFloat) {
//        sportsTypeDropdownData.dropStatus = status
//        (0..<filterSections.count).forEach { index in
//            if filterSections[index] == .sports {
//                let indexPath = IndexPath(item: index, section: 0)
//                filterOptionsCollectionView.reloadItems(at: [indexPath])
//            }
//        }
//    }
//
//}

//class SportsFilterViewController: UIViewController, RangeSeekSliderDelegate {
//
//    // MARK: - INITIALIZATION
//    var contentView: UIView!
//    var scrollView: UIScrollView!
//    var timeFormatter: DateFormatter!
//
//    var collectionViewTitle: UILabel!
//    var delegate: SportsFilterDelegate?
//    var gymCollectionView: UICollectionView!
//    var gyms: [GymNameId]!
//    /// ids of the selected gyms
//    var selectedGyms: [String] = []
//
//    var fitnessCenterStartTimeDivider: UIView!
//    var startTimeLabel: UILabel!
//    var startTimeSlider: RangeSeekSlider!
//    var startTimeTitleLabel: UILabel!
//    var timeRanges: [Date] = []
//
//    var endTime = "10:00PM"
//    var startTime = "6:00AM"
//
//    var startTimeNumPlayersDivider: UIView!
//    var numPlayersLabel: UILabel!
//    var numPlayersSlider: RangeSeekSlider!
//    var numPlayersTitleLabel: UILabel!
//    var playerRanges: [Int] = []
//
//    var maxPlayers = 10
//    var minPlayers = 2
//
//    var numPlayersSportsTypeDivider: UIView!
//    var sportsTypeDropdownHeader: DropdownHeaderView!
//    var sportsTypeDropdownFooter: DropdownFooterView!
//    var sportsTypeDropdown: UITableView!
//    var sportsTypeDropdownData: DropdownData!
//    var sportsTypeBottomDivider: UIView!
//    var selectedSports: [String] = []
//
//    convenience init(currentFilterParams: SportsFilterParameters?) {
//        self.init()
//        //TODO: - See if we already have filter params, and apply them
//
//        guard let existingFilterParams = currentFilterParams else {
//            return
//        }
//
//        selectedGyms = existingFilterParams.gymIds
//        selectedSports = existingFilterParams.sportsNames
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .white
//        let cal = Calendar.current
//        let currDate = Date()
//        let startDate = cal.date(bySettingHour: 6, minute: 0, second: 0, of: currDate)!
//        let endDate = cal.date(bySettingHour: 22, minute: 0, second: 0, of: currDate)!
//
//        var date = startDate
//
//        while date <= endDate {
//            timeRanges.append(date)
//            date = cal.date(byAdding: .minute, value: 15, to: date)!
//        }
//
//        timeFormatter = DateFormatter()
//        timeFormatter.dateFormat = "h:mma"
//
//        setupWrappingViews()
//
//        // START TIME SLIDER SECTION
//        fitnessCenterStartTimeDivider = UIView()
//        fitnessCenterStartTimeDivider.backgroundColor = .gray01
//        contentView.addSubview(fitnessCenterStartTimeDivider)
//
//        startTimeTitleLabel = UILabel()
//        startTimeTitleLabel.sizeToFit()
//        startTimeTitleLabel.font = ._12MontserratBold
//        startTimeTitleLabel.textColor = .gray04
//        startTimeTitleLabel.text = ClientStrings.Filter.startTime
//        contentView.addSubview(startTimeTitleLabel)
//
//        startTimeLabel = UILabel()
//        startTimeLabel.sizeToFit()
//        startTimeLabel.font = ._12MontserratBold
//        startTimeLabel.textColor = .gray04
//        startTimeLabel.text = startTime + " - " + endTime
//        contentView.addSubview(startTimeLabel)
//
//        startTimeSlider = RangeSeekSlider(frame: .zero)
//        startTimeSlider.minValue = 0.0 //15 minute intervals
//        startTimeSlider.maxValue = 960.0
//        startTimeSlider.selectedMinValue = 0.0
//        startTimeSlider.selectedMaxValue = 960.0
//        startTimeSlider.enableStep = true
//        startTimeSlider.delegate = self
//        startTimeSlider.step = 15.0
//        startTimeSlider.handleDiameter = 24.0
//        startTimeSlider.selectedHandleDiameterMultiplier = 1.0
//        startTimeSlider.lineHeight = 6.0
//        startTimeSlider.hideLabels = true
//
//        part2()
//    }
//
//    func part2() {
//
//        startTimeSlider.colorBetweenHandles = .primaryYellow
//        startTimeSlider.handleColor = .white
//        startTimeSlider.handleBorderWidth = 1.0
//        startTimeSlider.handleBorderColor = .gray01
//        startTimeSlider.handleShadowColor = .gray02
//        startTimeSlider.handleShadowOffset = CGSize(width: 0, height: 2)
//        startTimeSlider.handleShadowOpacity = 0.6
//        startTimeSlider.handleShadowRadius = 1.0
//        startTimeSlider.tintColor = .gray01
//        contentView.addSubview(startTimeSlider)
//
//        startTimeNumPlayersDivider = UIView()
//        startTimeNumPlayersDivider.backgroundColor = .gray01
//        contentView.addSubview(startTimeNumPlayersDivider)
//
//        numPlayersTitleLabel = UILabel()
//        numPlayersTitleLabel.sizeToFit()
//        numPlayersTitleLabel.font = ._12MontserratBold
//        numPlayersTitleLabel.textColor = .gray04
//        numPlayersTitleLabel.text = "NUMBER OF PLAYERS"
//        contentView.addSubview(numPlayersTitleLabel)
//
//        numPlayersLabel = UILabel()
//        numPlayersLabel.sizeToFit()
//        numPlayersLabel.font = ._12MontserratBold
//        numPlayersLabel.textColor = .gray04
//        numPlayersLabel.text = "\(minPlayers) - \(maxPlayers)"
//        contentView.addSubview(numPlayersLabel)
//
//        numPlayersSlider = RangeSeekSlider(frame: .zero)
//        numPlayersSlider.minValue = 2.0
//        numPlayersSlider.maxValue = 10.0
//        numPlayersSlider.selectedMinValue = 2.0
//        numPlayersSlider.selectedMaxValue = 10.0
//        numPlayersSlider.enableStep = true
//        numPlayersSlider.delegate = self
//        numPlayersSlider.step = 1.0
//        numPlayersSlider.handleDiameter = 24.0
//        numPlayersSlider.selectedHandleDiameterMultiplier = 1.0
//        numPlayersSlider.lineHeight = 6.0
//        numPlayersSlider.hideLabels = true
//
//        numPlayersSlider.colorBetweenHandles = .primaryYellow
//        numPlayersSlider.handleColor = .white
//        numPlayersSlider.handleBorderWidth = 1.0
//        numPlayersSlider.handleBorderColor = .gray01
//        numPlayersSlider.handleShadowColor = .gray02
//        numPlayersSlider.handleShadowOffset = CGSize(width: 0, height: 2)
//        numPlayersSlider.handleShadowOpacity = 0.6
//        numPlayersSlider.handleShadowRadius = 1.0
//        numPlayersSlider.tintColor = .gray01
//        contentView.addSubview(numPlayersSlider)
//
//        numPlayersSportsTypeDivider = UIView()
//        numPlayersSportsTypeDivider.backgroundColor = .gray01
//        contentView.addSubview(numPlayersSportsTypeDivider)
//
//        // SPORTS TYPE SECTION
//        sportsTypeDropdownHeader = DropdownHeaderView(title: "SPORTS")
//        contentView.addSubview(sportsTypeDropdownHeader)
//
//        sportsTypeDropdownFooter = DropdownFooterView()
//        sportsTypeDropdownFooter.clipsToBounds = true
//        contentView.addSubview(sportsTypeDropdownFooter)
//
//        let toggleMoreSports = UITapGestureRecognizer(target: self, action: #selector(self.dropHideSports(sender:) ))
//        sportsTypeDropdownFooter.addGestureRecognizer(toggleMoreSports)
//
//        sportsTypeDropdown = UITableView()
//        sportsTypeDropdown.separatorStyle = .none
//        sportsTypeDropdown.showsVerticalScrollIndicator = false
//        sportsTypeDropdown.bounces = false
//
//        sportsTypeDropdown.register(DropdownViewCell.self, forCellReuseIdentifier: Identifiers.dropdownViewCell)
//        sportsTypeDropdown.delegate = self
//        sportsTypeDropdown.dataSource = self
//        contentView.addSubview(sportsTypeDropdown)
//
//        sportsTypeBottomDivider = UIView()
//        sportsTypeBottomDivider.backgroundColor = .gray01
//        contentView.addSubview(sportsTypeBottomDivider)
//
//        sportsTypeDropdownData = SportsFilterSportsDropdown(completed: false, dropStatus: .up, titles: [])
//
//        // TODO: replace with networked sports.
//        let sportsNames = ["Basketball", "Soccer", "Table Tennis", "Frisbee", "A", "B", "C"]
//        sportsTypeDropdownData.titles.append(contentsOf: sportsNames)
//        sportsTypeDropdownData.titles.sort()
//        sportsTypeDropdownData.completed = true
//        sportsTypeDropdown.reloadData()
//
//        setupConstraints()
//        setupDropdownHeaderViews()
//    }
//
//    // MARK: - SETUP WRAPPING VIEWS
//    func setupWrappingViews() {
//        // NAVIGATION BAR
//        let titleView = UILabel()
//        titleView.text = ClientStrings.Filter.vcTitleLabel
//        titleView.font = ._14MontserratBold
//        self.navigationItem.titleView = titleView
//
//        // Color Navigation Bar White if Dark Mode
//        if #available(iOS 13, *) {
//            navigationItem.standardAppearance = .init()
//            navigationItem.compactAppearance = .init()
//            navigationItem.compactAppearance?.backgroundColor = .primaryWhite
//            navigationItem.standardAppearance?.backgroundColor = .primaryWhite
//            titleView.textColor = .primaryBlack
//        }
//
//        let doneBarButton = UIBarButtonItem(title: ClientStrings.Filter.doneButton, style: .plain, target: self, action: #selector(done))
//        doneBarButton.tintColor = .primaryBlack
//        doneBarButton.setTitleTextAttributes([
//            NSAttributedString.Key.font: UIFont._14MontserratMedium as Any
//        ], for: .normal)
//        self.navigationItem.rightBarButtonItem = doneBarButton
//
//        let resetBarButton = UIBarButtonItem(title: ClientStrings.Filter.resetButton, style: .plain, target: self, action: #selector(reset))
//        resetBarButton.tintColor = .primaryBlack
//        resetBarButton.setTitleTextAttributes([
//            NSAttributedString.Key.font: UIFont._14MontserratMedium as Any
//        ], for: .normal)
//        self.navigationItem.leftBarButtonItem = resetBarButton
//
//        // SCROLL VIEW
//        scrollView = UIScrollView()
//        scrollView.showsVerticalScrollIndicator = false
//        scrollView.isScrollEnabled = true
//        scrollView.bounces = true
//        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height * 2.5)
//        view.addSubview(scrollView)
//        scrollView.snp.makeConstraints { make in
//            make.edges.equalTo(view.safeAreaLayoutGuide)
//        }
//
//        contentView = UIView()
//        scrollView.addSubview(contentView)
//        contentView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//            make.width.equalTo(scrollView)
//        }
//
//        // COLLECTION VIEW
//        collectionViewTitle = UILabel()
//        collectionViewTitle.font = ._12MontserratBold
//        collectionViewTitle.textColor = .gray04
//        collectionViewTitle.text = ClientStrings.Filter.selectGymSection
//        contentView.addSubview(collectionViewTitle)
//
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .horizontal
//        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0 )
//        layout.minimumInteritemSpacing = 1
//        layout.minimumLineSpacing = 0
//
//        gymCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        gymCollectionView.allowsMultipleSelection = true
//        gymCollectionView.backgroundColor = .gray01
//        gymCollectionView.isScrollEnabled = true
//        gymCollectionView.showsHorizontalScrollIndicator = false
//        gymCollectionView.bounces = false
//
//        gymCollectionView.delegate = self
//        gymCollectionView.dataSource = self
//        gymCollectionView.register(GymFilterCell.self, forCellWithReuseIdentifier: Identifiers.gymFilterCell)
//        contentView.addSubview(gymCollectionView)
//
//        gyms = []
//
//        NetworkManager.shared.getGymNames(completion: { (gyms) in
//            self.gyms = gyms
//            self.gymCollectionView.reloadData()
//        })
//    }
//
//    // MARK: - CONSTRAINTS
//    func setupConstraints() {
//        // COLLECTION VIEW SECTION
//        collectionViewTitle.snp.remakeConstraints { make in
//            make.leading.equalToSuperview().offset(16)
//            make.top.equalToSuperview().offset(20)
//            make.bottom.equalTo(collectionViewTitle.snp.top).offset(15)
//        }
//
//        gymCollectionView.snp.remakeConstraints { make in
//            make.leading.trailing.equalToSuperview()
//            make.top.equalToSuperview().offset(51)
//            make.bottom.equalTo(collectionViewTitle.snp.bottom).offset(47)
//        }
//
//        // SLIDER SECTION
//        fitnessCenterStartTimeDivider.snp.remakeConstraints { make in
//            make.top.equalTo(gymCollectionView.snp.bottom).offset(16)
//            make.bottom.equalTo(gymCollectionView.snp.bottom).offset(17)
//            make.width.centerX.equalToSuperview()
//        }
//
//        startTimeTitleLabel.snp.remakeConstraints { make in
//            make.leading.equalToSuperview().offset(16)
//            make.top.equalTo(fitnessCenterStartTimeDivider.snp.bottom).offset(20)
//            make.bottom.equalTo(fitnessCenterStartTimeDivider.snp.bottom).offset(35)
//        }
//
//        startTimeLabel.snp.remakeConstraints { make in
//            make.trailing.equalToSuperview().offset(-22)
//            make.top.equalTo(fitnessCenterStartTimeDivider.snp.bottom).offset(20)
//            make.bottom.equalTo(fitnessCenterStartTimeDivider.snp.bottom).offset(36)
//        }
//
//        startTimeSlider.snp.remakeConstraints { make in
//            make.trailing.equalToSuperview().offset(-16)
//            make.leading.equalToSuperview().offset(16)
//            make.top.equalTo(startTimeLabel.snp.bottom).offset(12)
//            make.height.equalTo(30)
//        }
//
//        startTimeNumPlayersDivider.snp.remakeConstraints { make in
//            make.width.centerX.equalToSuperview()
//            make.top.equalTo(fitnessCenterStartTimeDivider.snp.bottom).offset(90)
//            make.bottom.equalTo(fitnessCenterStartTimeDivider.snp.bottom).offset(91)
//        }
//
//        numPlayersTitleLabel.snp.remakeConstraints { make in
//            make.leading.equalToSuperview().offset(16)
//            make.top.equalTo(startTimeNumPlayersDivider.snp.bottom).offset(20)
//            make.bottom.equalTo(startTimeNumPlayersDivider.snp.bottom).offset(35)
//        }
//
//        numPlayersLabel.snp.remakeConstraints { make in
//            make.trailing.equalToSuperview().offset(-22)
//            make.top.equalTo(startTimeNumPlayersDivider.snp.bottom).offset(20)
//            make.bottom.equalTo(startTimeNumPlayersDivider.snp.bottom).offset(36)
//        }
//
//        numPlayersSlider.snp.remakeConstraints { make in
//            make.trailing.equalToSuperview().offset(-16)
//            make.leading.equalToSuperview().offset(16)
//            make.top.equalTo(numPlayersLabel.snp.bottom).offset(12)
//            make.height.equalTo(30)
//        }
//
//        numPlayersSportsTypeDivider.snp.remakeConstraints { make in
//            make.width.centerX.equalToSuperview()
//            make.top.equalTo(startTimeNumPlayersDivider.snp.bottom).offset(90)
//            make.bottom.equalTo(startTimeNumPlayersDivider.snp.bottom).offset(91)
//        }
//
//        // SPORTS TYPE SECTION
//        sportsTypeDropdownHeader.snp.remakeConstraints { make in
//            make.top.equalTo(numPlayersSportsTypeDivider.snp.bottom)
//            make.leading.trailing.equalToSuperview()
//            make.height.equalTo(55)
//        }
//
//        sportsTypeDropdown.snp.remakeConstraints { make in
//            make.top.equalTo(sportsTypeDropdownHeader.snp.bottom)
//            make.leading.trailing.equalToSuperview()
//
//            if let dropStatus = sportsTypeDropdownData.dropStatus {
//                switch dropStatus {
//                    case .up:
//                        make.height.equalTo(0)
//                    case .half:
//                        make.height.equalTo(3 * 32)
//                    case .down:
//                        make.height.equalTo(sportsTypeDropdown.numberOfRows(inSection: 0) * 32)
//                }
//            } else {
//                make.height.equalTo(0)
//            }
//        }
//
//        sportsTypeDropdownFooter.snp.remakeConstraints { make in
//            make.top.equalTo(sportsTypeDropdown.snp.bottom)
//            make.leading.trailing.equalToSuperview()
//
//            if let dropStatus = sportsTypeDropdownData.dropStatus {
//                switch dropStatus {
//                    case .up:
//                        make.height.equalTo(0)
//                    case .half, .down:
//                        make.height.equalTo(32)
//                }
//            } else {
//                make.height.equalTo(0)
//            }
//        }
//
//        sportsTypeBottomDivider.snp.remakeConstraints { make in
//            make.width.centerX.equalToSuperview()
//            make.top.equalTo(sportsTypeDropdownFooter.snp.bottom)
//            make.bottom.equalTo(sportsTypeDropdownFooter).offset(1)
//        }
//
//        updateTableFooterViews()
//    }
//
//    func setupDropdownHeaderViews() {
//        let toggleSports = UITapGestureRecognizer(target: self, action: #selector(self.dropSports(sender:) ))
//        sportsTypeDropdownHeader.addGestureRecognizer(toggleSports)
//        sportsTypeDropdownHeader.updateDropdownHeader(selectedFilters: selectedSports)
//    }
//
//    func updateTableFooterViews() {
//        sportsTypeDropdownFooter.showHideLabel.text = sportsTypeDropdownData.dropStatus == .half
//            ? "Show All Sports"
//            : ClientStrings.Dropdown.collapse
//    }
//
//    // MARK: - NAVIGATION BAR BUTTONS FUNCTIONS
//    @objc func done() {
//        let minValueIndex = Int(startTimeSlider.selectedMinValue / 15.0)
//        let maxValueIndex = Int(startTimeSlider.selectedMaxValue / 15.0)
//
//        let minDate = timeRanges[minValueIndex]
//        let maxDate = timeRanges[maxValueIndex]
//
//        let shouldFilter: Bool = {
//            if minValueIndex != 0 || maxValueIndex != timeRanges.count - 1 { return true }
//            if !selectedSports.isEmpty || !selectedGyms.isEmpty { return true }
//            return false
//        }()
//        let filterParameters = SportsFilterParameters(endTime: maxDate, gymIds: selectedGyms, maxPlayers: 10, minPlayers: 2, shouldFilter: shouldFilter, sportsNames: selectedSports, startTime: minDate, tags: [])
//
//        delegate?.filterOptions(params: filterParameters)
//
//        dismiss(animated: true, completion: nil)
//    }
//
//    @objc func reset() {
//        let minDate = timeRanges[0]
//        let maxDate = timeRanges[timeRanges.count - 1]
//        let filterParameters = SportsFilterParameters(endTime: maxDate, gymIds: [], maxPlayers: 10, minPlayers: 2, shouldFilter: false, sportsNames: [], startTime: minDate, tags: [])
//
//        delegate?.filterOptions(params: filterParameters)
//
//        dismiss(animated: true, completion: nil)
//
//    }
//
//    // MARK: - SLIDER METHODS
//    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
//        let minValueIndex = Int(minValue / 15.0)
//        let maxValueIndex = Int(maxValue / 15.0)
//
//        let minDate = timeRanges[minValueIndex]
//        let maxDate = timeRanges[maxValueIndex]
//
//        startTimeLabel.text = "\(timeFormatter.string(from: minDate)) - \(timeFormatter.string(from: maxDate))"
//
//    }
//
//    @objc func dropSports(sender: UITapGestureRecognizer) {
//        if sportsTypeDropdownData.completed == false {
//            sportsTypeDropdownData.dropStatus = .up
//            return
//        }
//
//        sportsTypeDropdown.beginUpdates()
//        var modifiedIndices: [IndexPath] = []
//
//        if sportsTypeDropdownData.dropStatus == .half || sportsTypeDropdownData.dropStatus == .down {
//            sportsTypeDropdownHeader.rotateArrowUp()
//            sportsTypeDropdownData.dropStatus = .up
//            var i = 0
//            while i < sportsTypeDropdown.numberOfRows(inSection: 0) {
//                modifiedIndices.append(IndexPath(row: i, section: 0))
//                i += 1
//            }
//            sportsTypeDropdown.deleteRows(at: modifiedIndices, with: .none)
//        } else {
//            sportsTypeDropdownHeader.rotateArrowDown()
//            sportsTypeDropdownData.dropStatus = .half
//            for i in [0, 1, 2] {
//                modifiedIndices.append(IndexPath(row: i, section: 0))
//            }
//            sportsTypeDropdown.insertRows(at: modifiedIndices, with: .none)
//        }
//        sportsTypeDropdown.endUpdates()
//        setupConstraints()
//    }
//
//    // MARK: - SHOW ALL/HIDE METHODS
//    @objc func dropHideSports( sender: UITapGestureRecognizer) {
//        if sportsTypeDropdownData.completed == false {
//            return
//        }
//
//        sportsTypeDropdown.beginUpdates()
//        var modifiedIndices: [IndexPath] = []
//
//        if sportsTypeDropdownData.dropStatus == .half {
//            sportsTypeDropdownData.dropStatus = .down
//
//            var i = 3
//            while i < sportsTypeDropdownData.titles.count {
//                modifiedIndices.append(IndexPath(row: i, section: 0))
//                i += 1
//            }
//            sportsTypeDropdown.insertRows(at: modifiedIndices, with: .none)
//        } else {
//            sportsTypeDropdownData.dropStatus = .half
//            var i = sportsTypeDropdown.numberOfRows(inSection: 0) - 1
//            while i >= 3 {
//                modifiedIndices.append(IndexPath(row: i, section: 0))
//                i -= 1
//            }
//            sportsTypeDropdown.deleteRows(at: modifiedIndices, with: .none)
//        }
//
//        sportsTypeDropdown.endUpdates()
//        setupConstraints()
//    }
//}
//
//// MARK: CollectionViewDelegateFlowLayout
//extension SportsFilterViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
//        for i in 0..<selectedGyms.count {
//            if selectedGyms[i] == gyms[indexPath.row].id {
//                selectedGyms.remove(at: i)
//                return
//            }
//        }
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        selectedGyms.append(gyms[indexPath.row].id)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 35 + gyms[indexPath.row].name.count*10, height: 31)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return gyms.count
//    }
//
//}
//
//// MARK: CollectionViewDataSource
//extension SportsFilterViewController: UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.gymFilterCell, for: indexPath) as! GymFilterCell
//
//        cell.gymNameLabel.text = gyms[indexPath.row].name
//        cell.gymNameLabel.sizeToFit()
//
//        if selectedGyms.contains(gyms[indexPath.row].id) {
//            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .right)
//            cell.isSelected = true
//        }
//        return cell
//    }
//}
//
//// MARK: TableViewDataSource
//extension SportsFilterViewController: UITableViewDataSource {
//    //TODO: Refactor this method for better code readability
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        var numberOfRows = 0
//        if tableView == sportsTypeDropdown {
//            if !sportsTypeDropdownData.completed {
//                return 0
//            }
//
//            switch sportsTypeDropdownData.dropStatus! {
//            case .up:
//                numberOfRows = 0
//            case .half:
//                numberOfRows = 3
//            case .down:
//                numberOfRows = sportsTypeDropdownData.titles.count
//            }
//        }
//        return numberOfRows
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.dropdownViewCell, for: indexPath) as! DropdownViewCell
//
//        if tableView == sportsTypeDropdown {
//            if indexPath.row < sportsTypeDropdownData.titles.count {
//                cell.titleLabel.text = sportsTypeDropdownData.titles[indexPath.row]
//
//                if selectedSports.contains(sportsTypeDropdownData.titles[indexPath.row]) {
//                    cell.checkBoxColoring.backgroundColor = .primaryYellow
//                }
//            }
//        }
//        return cell
//    }
//}
//
//// MARK: TableViewDelegate
//extension SportsFilterViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let cell = tableView.cellForRow(at: indexPath) as! DropdownViewCell
//        var shouldAppend: Bool = cell.checkBoxColoring.backgroundColor == .primaryYellow
//
//        cell.checkBoxColoring.backgroundColor = shouldAppend ? .white : .primaryYellow
//        shouldAppend = !shouldAppend
//
//        if tableView == sportsTypeDropdown {
//            if shouldAppend {
//                selectedSports.append(cell.titleLabel.text!)
//            } else {
//                for i in 0..<selectedSports.count {
//                    let name = selectedSports[i]
//                    if name == cell.titleLabel.text! {
//                        selectedSports.remove(at: i)
//                        sportsTypeDropdownHeader.updateDropdownHeader(selectedFilters: selectedSports)
//                        return
//                    }
//                }
//            }
//            sportsTypeDropdownHeader.updateDropdownHeader(selectedFilters: selectedSports)
//        }
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 32
//    }
//}


