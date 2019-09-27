//
//  GymDetailViewController.swift
//  Uplift
//
//  Created by Joseph Fulgieri on 4/18/18.
//  Copyright © 2018 Uplift. All rights reserved.
//

import Bartinter
import Crashlytics
import Kingfisher
import SnapKit
import UIKit

struct HoursData {
    var data: [String]!
    var isDropped: Bool!
}

struct FacilityData {
    var facility: String!
    var isDropped: Bool!
    var data: [(String, String)]!
}

enum Days {
    case sunday
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
}

class OldGymDetailViewController: UIViewController {

    // MARK: - INITIALIZATION
    var contentView: UIView!
    var scrollView: UIScrollView!

    var backButton: UIButton!
    var gymImageContainer: UIView!
    var gymImageView: UIImageView!
    var titleLabel: UILabel!

    /// Exists when gym.isOpen is false
    var closedLabel: UILabel?

    var days: [Days]!
    var hoursData: HoursData!
    var hoursPopularTimesSeparator: UIView!
    var hoursTableView: UITableView!
    var hoursTitleLabel: UILabel!

    let separatorSpacing = 24

    // Exist when gym.isOpen is true
    var popularTimesFacilitiesSeparator: UIView?
    var popularTimesHistogram: Histogram?
    var popularTimesTitleLabel: UILabel?

    var facilityData: FacilityData!
    var facilitiesClassesDivider: UIView!
    var facilitiesData: [String]!       //temp (until backend implements equiment)
    var facilitiesLabelArray: [UILabel] = []
    var facilitiesTitleLabel: UILabel!
    var facilityTableView: GymFacilitiesTableView!

    var classesCollectionView: UICollectionView!
    var todaysClassesLabel: UILabel!
    var todaysClasses: [GymClassInstance]! {
        didSet {
            classesCollectionView.reloadData()
            remakeConstraints()
        }
    }
    var noMoreClassesLabel: UILabel!

    var gym: Gym!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        // MARK: - Fabric
        Answers.logCustomEvent(withName: "Checking Gym Details")

        updatesStatusBarAppearanceAutomatically = true

        hoursData = HoursData(data: [], isDropped: false)

        setupHeaderAndWrappingViews()
        setupTimes()

        let edgeSwipe = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(back))
        edgeSwipe.edges = .left
        contentView.addGestureRecognizer(edgeSwipe)

        // FACILITIES
        facilitiesTitleLabel = UILabel()
        facilitiesTitleLabel.font = ._16MontserratMedium
        facilitiesTitleLabel.textAlignment = .center
        facilitiesTitleLabel.textColor = .fitnessBlack
        facilitiesTitleLabel.sizeToFit()
        facilitiesTitleLabel.text = "FACILITIES"
        contentView.addSubview(facilitiesTitleLabel)

        setupFacilities()
        facilitiesClassesDivider = UIView()
        facilitiesClassesDivider.backgroundColor = .fitnessLightGrey
        contentView.addSubview(facilitiesClassesDivider)

        // CLASSES
        todaysClassesLabel = UILabel()
        todaysClassesLabel.font = ._12LatoBlack
        todaysClassesLabel.textColor = .fitnessDarkGrey
        todaysClassesLabel.text = "TODAY'S CLASSES"
        todaysClassesLabel.textAlignment = .center
        contentView.addSubview(todaysClassesLabel)

        noMoreClassesLabel = UILabel()
        noMoreClassesLabel.font = UIFont._14MontserratLight
        noMoreClassesLabel.textColor = .fitnessDarkGrey
        noMoreClassesLabel.text = "We are done for today. \nCheck again tomorrow!\n🌟"
        noMoreClassesLabel.numberOfLines = 0
        noMoreClassesLabel.textAlignment = .center
        contentView.addSubview(noMoreClassesLabel)

        let classFlowLayout = UICollectionViewFlowLayout()
        classFlowLayout.itemSize = CGSize(width: view.bounds.width - 32.0, height: 100.0)
        classFlowLayout.minimumLineSpacing = 12.0
        classFlowLayout.headerReferenceSize = .zero

        classesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: classFlowLayout)
        classesCollectionView.bounces = false
        classesCollectionView.showsVerticalScrollIndicator = false
        classesCollectionView.isScrollEnabled = false
        classesCollectionView.backgroundColor = .white
        classesCollectionView.clipsToBounds = false
        classesCollectionView.delaysContentTouches = false

        classesCollectionView.register(ClassListCell.self, forCellWithReuseIdentifier: ClassListCell.identifier)

        classesCollectionView.dataSource = self
        classesCollectionView.delegate = self
        contentView.addSubview(classesCollectionView)

        contentView.bringSubviewToFront(backButton)

        todaysClasses = []
        setupConstraints()

        NetworkManager.shared.getClassInstancesByGym(gymId: gym.id, date: Date.getNowString()) { gymClasses in
            self.todaysClasses = gymClasses
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        switch UIApplication.shared.statusBarStyle {
        case .lightContent:
            backButton.setImage(UIImage(named: ImageNames.lightBackArrow), for: .normal)
        case .default, .darkContent:
            backButton.setImage(UIImage(named: ImageNames.darkBackArrow), for: .normal)
        }
    }

    // MARK: - SETUP HEADER AND WRAPPING VIEWS
    func setupHeaderAndWrappingViews() {
        scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.isScrollEnabled = true
        scrollView.bounces = true
        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height * 2.5)
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        contentView = UIView()
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.edges.width.equalTo(scrollView)
        }

        // HEADER
        gymImageContainer = UIView()
        gymImageContainer.backgroundColor = .darkGray
        contentView.addSubview(gymImageContainer)

        gymImageView = UIImageView()
        gymImageView.contentMode = UIView.ContentMode.scaleAspectFill
        gymImageView.clipsToBounds = true
        gymImageView.kf.setImage(with: gym.imageURL)
        contentView.addSubview(gymImageView)

        if !gym.isOpen {
            let tempClosedLabel =  UILabel()
            tempClosedLabel.font = ._16MontserratSemiBold
            tempClosedLabel.textColor = .white
            tempClosedLabel.textAlignment = .center
            tempClosedLabel.backgroundColor = .fitnessBlack
            tempClosedLabel.text = "CLOSED"
            contentView.addSubview(tempClosedLabel)

            closedLabel = tempClosedLabel
        }

        backButton = UIButton()
        backButton.setImage(UIImage(named: ImageNames.lightBackArrow), for: .normal)
        backButton.sizeToFit()
        backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        contentView.addSubview(backButton)

        titleLabel = UILabel()
        titleLabel.font = ._48Bebas
        titleLabel.textAlignment = .center
        titleLabel.sizeToFit()
        titleLabel.textColor = .white
        titleLabel.text = gym.name
        contentView.addSubview(titleLabel)
    }

    // MARK: - SETUP FACILITIES TABLE
    func setupFacilities() {
        if gym.id == GymIds.helenNewman {
            facilityTableView = GymFacilitiesTableView(facilityName: .helenNewman)
        } else if gym.id == GymIds.teagleDown || gym.id == GymIds.teagleUp {
            facilityTableView = GymFacilitiesTableView(facilityName: .teagle)
        } else if gym.id == GymIds.appel {
            facilityTableView = GymFacilitiesTableView(facilityName: .appel)
        } else {
            facilityTableView = GymFacilitiesTableView(facilityName: .noyes)
        }
        contentView.addSubview(facilityTableView)
    }

    // MARK: - HOURS AND POPULAR TIMES
    func setupTimes() {
        // HOURS
        hoursTitleLabel = UILabel()
        hoursTitleLabel.font = ._16MontserratMedium
        hoursTitleLabel.textColor = .fitnessBlack
        hoursTitleLabel.textAlignment = .center
        hoursTitleLabel.sizeToFit()
        hoursTitleLabel.text = "HOURS"
        contentView.addSubview(hoursTitleLabel)

        hoursTableView = UITableView(frame: .zero, style: .grouped)
        hoursTableView.bounces = false
        hoursTableView.showsVerticalScrollIndicator = false
        hoursTableView.separatorStyle = .none
        hoursTableView.backgroundColor = .clear
        hoursTableView.isScrollEnabled = false
        hoursTableView.allowsSelection = false

        hoursTableView.register(GymHoursCell.self, forCellReuseIdentifier: GymHoursCell.identifier)
        hoursTableView.register(GymHoursHeaderView.self, forHeaderFooterViewReuseIdentifier: GymHoursHeaderView.identifier)

        hoursTableView.delegate = self
        hoursTableView.dataSource = self
        contentView.addSubview(hoursTableView)

        hoursPopularTimesSeparator = UIView()
        hoursPopularTimesSeparator.backgroundColor = .fitnessLightGrey
        contentView.addSubview(hoursPopularTimesSeparator)

        days = [.sunday, .monday, .tuesday, .wednesday, .thursday, .friday, .saturday]

        // POPULAR TIMES
        if gym.isOpen {
            popularTimesTitleLabel = UILabel()
            popularTimesTitleLabel?.font = ._16MontserratMedium
            popularTimesTitleLabel?.textAlignment = .center
            popularTimesTitleLabel?.textColor = .fitnessBlack
            popularTimesTitleLabel?.sizeToFit()
            popularTimesTitleLabel?.text = "BUSY TIMES"
            contentView.addSubview(popularTimesTitleLabel!)

            let data = gym.popularTimesList[Date().getIntegerDayOfWeekToday()]
            let todaysHours = gym.gymHoursToday

            popularTimesHistogram = Histogram(frame: CGRect(x: 0, y: 0, width: view.frame.width - 36, height: 0), data: data, todaysHours: todaysHours)
            contentView.addSubview(popularTimesHistogram!)

            popularTimesFacilitiesSeparator = UIView()
            popularTimesFacilitiesSeparator?.backgroundColor = .fitnessLightGrey
            contentView.addSubview(popularTimesFacilitiesSeparator!)
        }

    }

    // MARK: - CONSTRAINTS
    // swiftlint:disable:next function_body_length
    func setupConstraints() {
        let backButtonLeftPadding = 20
        let backButtonSize = CGSize(width: 23, height: 19)
        let backButtonTopPadding = 30
        let classesCollectionViewItemHeight = 112
        let classesCollectionViewTopPadding = 32
        let closedLabelHeight = 60
        let facilitiesClassesDividerHeight = 1
        let facilitiesLabelHeight = 20
        let facilitiesLabelTopPadding = 10
        let facilitiesTitleLabelHeight = 19
        let facilityTableViewTopPadding = 20
        let gymImageContainerHeight = 360
        let hoursPopularTimesHeight = 1
        let hoursPopularTimesSeparatorTopPadding = 32
        let hoursTableViewDroppedHeight = 181
        let hoursTableViewHeight = 27
        let hoursTableViewTopPadding = 12
        let hoursTitleLabelHeight = 19
        let hoursTitleLabelTopPadding = 36
        let noMoreClassesLabelBottomPadding = 24
        let noMoreClassesLabelHeight = 66
        let popularTimesFacilitiesSeparatorHeight = 1
        let popularTimesHistogramHeight = 101
        let popularTimesHistogramHorizontalPadding = 18
        let popularTimesTitleLabelHeight = 19
        let titleLabelHeight = 57
        let titleLabelTopPadding = 134
        let todaysClassesLabelHeight = 15
        let todaysClassesLabelTopPadding = 64

        gymImageContainer.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view)
            make.top.equalTo(scrollView)
            make.height.equalTo(gymImageContainerHeight)
        }

        gymImageView.snp.updateConstraints { make in
            make.leading.trailing.equalTo(gymImageContainer)
            make.top.equalTo(view).priority(.high)
            make.height.greaterThanOrEqualTo(gymImageContainer).priority(.high)
            make.bottom.equalTo(gymImageContainer)
        }

        if !gym.isOpen {
            closedLabel?.snp.updateConstraints { make in
                make.leading.trailing.equalToSuperview()
                make.bottom.equalTo(gymImageView.snp.bottom)
                make.height.equalTo(closedLabelHeight)
            }
        }

        backButton.snp.makeConstraints { make in
            make.leading.equalTo(view).offset(backButtonLeftPadding)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(backButtonTopPadding)
            make.size.equalTo(backButtonSize)
        }

        titleLabel.snp.updateConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(titleLabelTopPadding)
            make.height.equalTo(titleLabelHeight)
        }

        // HOURS
        hoursTitleLabel.snp.updateConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(gymImageView.snp.bottom).offset(hoursTitleLabelTopPadding)
            make.height.equalTo(hoursTitleLabelHeight)
        }

        hoursTableView.snp.updateConstraints { make in
            make.centerX.width.equalToSuperview()
            make.top.equalTo(hoursTitleLabel.snp.bottom).offset(hoursTableViewTopPadding)
            if hoursData.isDropped {
                make.height.equalTo(hoursTableViewDroppedHeight)
            } else {
                make.height.equalTo(hoursTableViewHeight)
            }
        }

        hoursPopularTimesSeparator.snp.updateConstraints {make in
            make.top.equalTo(hoursTableView.snp.bottom).offset(hoursPopularTimesSeparatorTopPadding)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(hoursPopularTimesHeight)
        }

        // POPULAR TIMES
        if gym.isOpen {
            popularTimesTitleLabel?.snp.updateConstraints { make in
                make.top.equalTo(hoursPopularTimesSeparator.snp.bottom).offset(separatorSpacing)
                make.centerX.width.equalToSuperview()
                make.height.equalTo(popularTimesTitleLabelHeight)
            }

            popularTimesHistogram?.snp.updateConstraints { make in
                make.top.equalTo(popularTimesTitleLabel!.snp.bottom).offset(separatorSpacing)
                make.leading.equalToSuperview().offset(popularTimesHistogramHorizontalPadding)
                make.trailing.equalToSuperview().offset(-popularTimesHistogramHorizontalPadding)
                make.height.equalTo(popularTimesHistogramHeight)
            }

            popularTimesFacilitiesSeparator?.snp.updateConstraints { make in
                make.leading.trailing.equalToSuperview()
                make.top.equalTo(popularTimesHistogram!.snp.bottom).offset(separatorSpacing)
                make.height.equalTo(popularTimesFacilitiesSeparatorHeight)
            }

            // FACILITIES
            facilitiesTitleLabel.snp.updateConstraints { make in
                make.top.equalTo(popularTimesFacilitiesSeparator!.snp.bottom).offset(separatorSpacing)
                make.centerX.width.equalToSuperview()
                make.height.equalTo(facilitiesTitleLabelHeight)
            }
        } else {
            facilitiesTitleLabel.snp.updateConstraints { make in
                make.top.equalTo(hoursPopularTimesSeparator.snp.bottom).offset(separatorSpacing)
                make.centerX.width.equalToSuperview()
                make.height.equalTo(facilitiesTitleLabelHeight)
            }
        }

        facilityTableView.snp.updateConstraints {make in
            make.width.centerX.equalToSuperview()
            make.top.equalTo(facilitiesTitleLabel.snp.bottom).offset(facilityTableViewTopPadding)
        }

        (0..<facilitiesLabelArray.count).forEach { i in
            facilitiesLabelArray[i].snp.updateConstraints { make in
                if i == 0 {
                    make.top.equalTo(facilitiesTitleLabel.snp.bottom).offset(facilitiesLabelTopPadding)
                } else {
                    make.top.equalTo(facilitiesLabelArray[i-1].snp.bottom)
                }
                make.centerX.width.equalToSuperview()
                make.height.equalTo(facilitiesLabelHeight)
            }
        }

        facilitiesClassesDivider.snp.updateConstraints { make in
            make.width.centerX.equalToSuperview()
            make.top.equalTo(facilityTableView.snp.bottom).offset(separatorSpacing)
            make.height.equalTo(facilitiesClassesDividerHeight)
        }

        // CLASSES
        todaysClassesLabel.snp.updateConstraints { make in
            make.centerX.width.equalToSuperview()
            make.top.equalTo(facilitiesClassesDivider.snp.bottom).offset(todaysClassesLabelTopPadding)
            make.height.equalTo(todaysClassesLabelHeight)
        }

        classesCollectionView.snp.updateConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(todaysClassesLabel.snp.bottom).offset(classesCollectionViewTopPadding)
            make.height.equalTo(classesCollectionView.numberOfItems(inSection: 0) * classesCollectionViewItemHeight)
        }

        if todaysClasses.isEmpty {
            noMoreClassesLabel.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview()
                make.top.equalTo(classesCollectionView.snp.bottom)
                make.bottom.equalToSuperview().inset(noMoreClassesLabelBottomPadding)
                make.height.equalTo(noMoreClassesLabelHeight)
            }
        } else {
            noMoreClassesLabel.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview()
                make.top.equalTo(classesCollectionView.snp.bottom)
                make.bottom.equalToSuperview().inset(noMoreClassesLabelBottomPadding)
                make.height.equalTo(0)
            }
        }
    }

    func remakeConstraints() {
        let classesCollectionViewCellHeight = 112
        let classesCollectionViewTopPaddingg = 32
        let noMoreClassesLabelBottomPadding = 24
        let noMoreClassesLabelHeight = 66

        classesCollectionView.snp.remakeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(todaysClassesLabel.snp.bottom).offset(classesCollectionViewTopPaddingg)
            make.height.equalTo(classesCollectionView.numberOfItems(inSection: 0) * classesCollectionViewCellHeight)
        }

        if todaysClasses.isEmpty {
            noMoreClassesLabel.snp.remakeConstraints { make in
                make.leading.trailing.equalToSuperview()
                make.top.equalTo(classesCollectionView.snp.bottom)
                make.bottom.equalToSuperview().inset(noMoreClassesLabelBottomPadding)
                make.height.equalTo(noMoreClassesLabelHeight)
            }
        } else {
            noMoreClassesLabel.snp.remakeConstraints { make in
                make.leading.trailing.equalToSuperview()
                make.top.equalTo(classesCollectionView.snp.bottom)
                make.bottom.equalToSuperview().inset(noMoreClassesLabelBottomPadding)
                make.height.equalTo(0)
            }
        }
    }

    func getStringFromDailyHours(dailyGymHours: DailyGymHours) -> String {
        let openTime = dailyGymHours.openTime.getStringOfDatetime(format: "h:mm a")
        let closeTime = dailyGymHours.closeTime.getStringOfDatetime(format: "h:mm a")

        if dailyGymHours.openTime != dailyGymHours.closeTime {
            return "\(openTime) - \(closeTime)"
        } else {
            return "Closed"
        }
    }

    // DROP HOURS
    @objc func dropHours( sender: UITapGestureRecognizer) {
        hoursTableView.beginUpdates()
        var modifiedIndices: [IndexPath] = []
        // only modifying 6 rows because today's hours are always displayed
        (0..<6).forEach { i in
            modifiedIndices.append(IndexPath(row: i, section: 0))
        }

        if hoursData.isDropped {
            hoursData.isDropped = false
            hoursTableView.deleteRows(at: modifiedIndices, with: .fade)
            if let headerView = hoursTableView.headerView(forSection: 0) as? GymHoursHeaderView {
                headerView.downArrow.image = .none
                headerView.rightArrow.image = UIImage(named: "right-arrow-solid")
            }

            UIView.animate(withDuration: 0.3) {
                self.setupConstraints()
                self.view.layoutIfNeeded()
            }
        } else {
            hoursData.isDropped = true
            hoursTableView.insertRows(at: modifiedIndices, with: .fade)
            if let headerView = hoursTableView.headerView(forSection: 0) as? GymHoursHeaderView {
                headerView.downArrow.image = UIImage(named: "down-arrow-solid")
                headerView.rightArrow.image = .none
            }

            UIView.animate(withDuration: 0.5) {
                self.setupConstraints()
                self.view.layoutIfNeeded()
            }
        }
        hoursTableView.endUpdates()
    }

    // MARK: - BUTTON METHODS
    @objc func back() {
        if let navigationController = navigationController {
            navigationController.popViewController(animated: true)
        }
    }
}

// MARK: CollectionViewDataSource, CollectionViewDelegate
extension OldGymDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == classesCollectionView {
            return todaysClasses.count
        }
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == classesCollectionView {
            //swiftlint:disable:next force_cast
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ClassListCell.identifier, for: indexPath) as! ClassListCell

            cell.configure(gymClassInstance: todaysClasses[indexPath.item], style: .date)

            return cell
        }
        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        UIView.animate(withDuration: 0.35, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: [], animations: {
            cell.transform = CGAffineTransform(scaleX: 0.96, y: 0.96)
        }, completion: nil)
    }

    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        UIView.animate(withDuration: 0.35, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: [], animations: {
            cell.transform = .identity
        }, completion: nil)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let classDetailViewController = ClassDetailViewController(gymClassInstance: todaysClasses[indexPath.item])
        navigationController?.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(classDetailViewController, animated: true)
    }
}

// MARK: TableViewDataSource
extension OldGymDetailViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView == hoursTableView && hoursData.isDropped ? 6 : 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == hoursTableView {
            //swiftlint:disable:next force_cast
            let cell = tableView.dequeueReusableCell(withIdentifier: GymHoursCell.identifier, for: indexPath) as! GymHoursCell
            let date = Date()
            let day = (date.getIntegerDayOfWeekToday() + indexPath.row + 1) % 7

            cell.hoursLabel.text = getStringFromDailyHours(dailyGymHours: gym.gymHours[day])

            switch days[day] {
            case .sunday:
                cell.dayLabel.text = DayAbbreviations.sunday
            case .monday:
                cell.dayLabel.text = DayAbbreviations.monday
            case .tuesday:
                cell.dayLabel.text = DayAbbreviations.tuesday
            case .wednesday:
                cell.dayLabel.text = DayAbbreviations.wednesday
            case .thursday:
                cell.dayLabel.text = DayAbbreviations.thursday
            case .friday:
                cell.dayLabel.text = DayAbbreviations.friday
            case .saturday:
                cell.dayLabel.text = DayAbbreviations.saturday
            }

            return cell
        }

        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == hoursTableView {
            //swiftlint:disable:next force_cast
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: GymHoursHeaderView.identifier) as! GymHoursHeaderView

            header.hoursLabel.text = getStringFromDailyHours(dailyGymHours: gym.gymHoursToday)

            let gesture = UITapGestureRecognizer(target: self, action: #selector(self.dropHours(sender:) ))
            header.addGestureRecognizer(gesture)

            return header
        }

        return nil
    }
}

// MARK: TableViewDelegate
extension OldGymDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == hoursTableView {
            return indexPath.row == 5 ? 19 : 27
        }

        return 112
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == hoursTableView {
            return hoursData.isDropped ? 27 : 19
        }

        return 0
    }
}

// MARK: - ScrollViewDelegate
extension OldGymDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        statusBarUpdater?.refreshStatusBarStyle()

        switch UIApplication.shared.statusBarStyle {
        case .lightContent:
            backButton.setImage(UIImage(named: ImageNames.lightBackArrow), for: .normal)
        case .default, .darkContent:
            backButton.setImage(UIImage(named: ImageNames.darkBackArrow), for: .normal)
        }
    }
}
