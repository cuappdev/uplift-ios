//
//  GymDetailViewController.swift
//  Fitness
//
//  Created by Joseph Fulgieri on 4/18/18.
//  Copyright © 2018 Uplift. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher
import Bartinter

struct HoursData {
    var isDropped: Bool!
    var data: [String]!
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

class GymDetailViewController: UIViewController, UICollectionViewDelegate {

    // MARK: - INITIALIZATION
    var scrollView: UIScrollView!
    var contentView: UIView!

    var backButton: UIButton!
    var gymImageView: UIImageView!
    var titleLabel: UILabel!

    // Exists when gym.isOpen is false
    var closedLabel: UILabel?

    var hoursTitleLabel: UILabel!
    var hoursTableView: UITableView!
    var days: [Days]!
    var hoursData: HoursData!
    var hoursPopularTimesSeparator: UIView!

    let separatorSpacing = 24

    // Exist when gym.isOpen is true
    var popularTimesTitleLabel: UILabel?
    var popularTimesHistogram: Histogram?
    var popularTimesFacilitiesSeparator: UIView?

    var facilitiesTitleLabel: UILabel!
    var facilitiesData: [String]!       //temp (until backend implements equiment)
    var facilitiesLabelArray: [UILabel]!
    var facilitiesClassesDivider: UIView!

    var todaysClassesLabel: UILabel!
    var classesTableView: UICollectionView!
    var todaysClasses: [GymClassInstance] = []

    var gym: Gym!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

         updatesStatusBarAppearanceAutomatically = true

        hoursData = HoursData(isDropped: false, data: [])
        facilitiesData = ["Pool", "Two-court Gymnasium", "Dance Studio", "16-lane Bowling Center"] //temp (until backend implements equiment)

        setupHeaderAndWrappingViews()
        setupTimes()

        //FACILITIES
        facilitiesTitleLabel = UILabel()
        facilitiesTitleLabel.font = ._16MontserratMedium
        facilitiesTitleLabel.textAlignment = .center
        facilitiesTitleLabel.textColor = .fitnessBlack
        facilitiesTitleLabel.sizeToFit()
        facilitiesTitleLabel.text = "FACILITIES"
        contentView.addSubview(facilitiesTitleLabel)

        facilitiesLabelArray = []
        for i in 0..<facilitiesData.count {  //temp (until backend implements equiment)
            let facilitiesLabel = UILabel()
            facilitiesLabel.font = ._14MontserratLight
            facilitiesLabel.textColor = .fitnessBlack
            facilitiesLabel.text = facilitiesData[i]
            facilitiesLabel.textAlignment = .center
            contentView.addSubview(facilitiesLabel)
            facilitiesLabelArray.append(facilitiesLabel)
        }

        facilitiesClassesDivider = UIView()
        facilitiesClassesDivider.backgroundColor = .fitnessLightGrey
        contentView.addSubview(facilitiesClassesDivider)

        //CLASSES
        todaysClassesLabel = UILabel()
        todaysClassesLabel.font = ._12LatoBlack
        todaysClassesLabel.textColor = .fitnessDarkGrey
        todaysClassesLabel.text = "TODAY'S CLASSES"
        todaysClassesLabel.textAlignment = .center
        todaysClassesLabel.sizeToFit()
        contentView.addSubview(todaysClassesLabel)

        let classFlowLayout = UICollectionViewFlowLayout()
        classFlowLayout.itemSize = CGSize(width: view.bounds.width - 32.0, height: 100.0)
        classFlowLayout.minimumLineSpacing = 12.0
        classFlowLayout.headerReferenceSize = .init(width: view.bounds.width - 32.0, height: 72.0)
        
        classesTableView = UICollectionView(frame: .zero, collectionViewLayout: classFlowLayout)
        classesTableView.bounces = false
        classesTableView.showsVerticalScrollIndicator = false
        classesTableView.backgroundColor = .white
        classesTableView.clipsToBounds = false

        classesTableView.register(ClassListCell.self, forCellWithReuseIdentifier: ClassListCell.identifier)

        classesTableView.dataSource = self
        contentView.addSubview(classesTableView)

        //get gym class instances once branch merged

        setupConstraints()
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
            make.left.right.equalTo(view)
            make.top.equalToSuperview()
            make.bottom.equalTo(view.snp.bottom)
        }

        //HEADER
        gymImageView = UIImageView()
        gymImageView.contentMode = UIView.ContentMode.scaleAspectFill
        gymImageView.translatesAutoresizingMaskIntoConstraints = false
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
        backButton.setImage(#imageLiteral(resourceName: "back-arrow"), for: .normal)
        backButton.sizeToFit()
        backButton.addTarget(self, action: #selector(self.back), for: .touchUpInside)
        contentView.addSubview(backButton)

        titleLabel = UILabel()
        titleLabel.font = ._48Bebas
        titleLabel.textAlignment = .center
        titleLabel.sizeToFit()
        titleLabel.textColor = .white
        titleLabel.text = gym.name
        contentView.addSubview(titleLabel)
    }

    // MARK: - HOURS AND POPULAR TIMES
    func setupTimes() {
        //HOURS
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
        hoursTableView.backgroundColor = .white
        hoursTableView.isScrollEnabled = false

        hoursTableView.register(GymHoursCell.self, forCellReuseIdentifier: GymHoursCell.identifier)
        hoursTableView.register(GymHoursHeaderView.self, forHeaderFooterViewReuseIdentifier: GymHoursHeaderView.identifier)

        hoursTableView.delegate = self
        hoursTableView.dataSource = self
        contentView.addSubview(hoursTableView)

        hoursPopularTimesSeparator = UIView()
        hoursPopularTimesSeparator.backgroundColor = .fitnessLightGrey
        contentView.addSubview(hoursPopularTimesSeparator)

        days = [.sunday, .monday, .tuesday, .wednesday, .thursday, .friday, .saturday]

        //POPULAR TIMES
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
    func setupConstraints() {
        //HEADER
        let window = UIApplication.shared.keyWindow
        let topPadding = window?.safeAreaInsets.top ?? 0.0
        gymImageView.snp.updateConstraints {make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().inset(-topPadding)
            make.height.equalTo(360)
        }

        if !gym.isOpen {
            closedLabel?.snp.updateConstraints {make in
                make.left.right.equalToSuperview()
                make.bottom.equalTo(gymImageView.snp.bottom)
                make.height.equalTo(60)
            }
        }

        backButton.snp.updateConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(16)
            make.width.equalTo(23)
            make.height.equalTo(19)
        }

        titleLabel.snp.updateConstraints {make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(134)
            make.height.equalTo(57)
        }

        //HOURS
        hoursTitleLabel.snp.updateConstraints {make in
            make.centerX.equalToSuperview()
            make.top.equalTo(gymImageView.snp.bottom).offset(36)
            make.height.equalTo(19)
        }

        hoursTableView.snp.updateConstraints {make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.top.equalTo(hoursTitleLabel.snp.bottom).offset(12)
            if (hoursData.isDropped) {
                make.height.equalTo(181)
            } else {
                make.height.equalTo(27)
            }
        }

        hoursPopularTimesSeparator.snp.updateConstraints {make in
            make.top.equalTo(hoursTableView.snp.bottom).offset(32)
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
        }

        //POPULAR TIMES
        if gym.isOpen {
            popularTimesTitleLabel?.snp.updateConstraints {make in
                make.top.equalTo(hoursPopularTimesSeparator.snp.bottom).offset(separatorSpacing)
                make.centerX.width.equalToSuperview()
                make.height.equalTo(19)
            }

            popularTimesHistogram?.snp.updateConstraints {make in
                make.top.equalTo(popularTimesTitleLabel!.snp.bottom).offset(separatorSpacing)
                make.left.equalToSuperview().offset(18)
                make.right.equalToSuperview().offset(-18)
                make.height.equalTo(101)
            }

            popularTimesFacilitiesSeparator?.snp.updateConstraints {make in
                make.left.right.equalToSuperview()
                make.top.equalTo(popularTimesHistogram!.snp.bottom).offset(separatorSpacing)
                make.height.equalTo(1)
            }

            //FACILITIES
            facilitiesTitleLabel.snp.updateConstraints {make in
                make.top.equalTo(popularTimesFacilitiesSeparator!.snp.bottom).offset(separatorSpacing)
                make.centerX.width.equalToSuperview()
                make.height.equalTo(19)
            }
        } else {
            facilitiesTitleLabel.snp.updateConstraints {make in
                make.top.equalTo(hoursPopularTimesSeparator.snp.bottom).offset(separatorSpacing)
                make.centerX.width.equalToSuperview()
                make.height.equalTo(19)
            }
        }

        for i in 0..<facilitiesLabelArray.count {
            facilitiesLabelArray[i].snp.updateConstraints {make in
                if (i == 0) {
                    make.top.equalTo(facilitiesTitleLabel.snp.bottom).offset(10)
                } else {
                    make.top.equalTo(facilitiesLabelArray[i-1].snp.bottom)
                }
                make.centerX.width.equalToSuperview()
                make.height.equalTo(20)
            }
        }

        facilitiesClassesDivider.snp.updateConstraints {make in
            make.width.centerX.equalToSuperview()
            make.top.equalTo(facilitiesLabelArray.last!.snp.bottom).offset(separatorSpacing)
            make.height.equalTo(1)
        }

        //CLASSES
        todaysClassesLabel.snp.updateConstraints {make in
            make.centerX.width.equalToSuperview()
            make.top.equalTo(facilitiesClassesDivider.snp.bottom).offset(64)
            make.height.equalTo(15)
        }

        classesTableView.snp.updateConstraints {make in
            make.left.right.equalToSuperview()
            make.top.equalTo(todaysClassesLabel.snp.bottom).offset(32)
            make.height.equalTo(classesTableView.numberOfItems(inSection: 0) * 112)
        }

        var dropHoursHeight = 27
        if hoursData.isDropped {
            dropHoursHeight = 181
        }

        let facilitiesHeight = facilitiesData.count*20
        let todaysClassesHeight = classesTableView.numberOfItems(inSection: 0)*112
        let height: Int

        // THIS MUST BE CHANGED IF ANY OF THE SCREEN'S HARD-CODED HEIGHTS ARE ALTERED
        if gym.isOpen {
            height = 427 + dropHoursHeight + 282 + facilitiesHeight + 137 + todaysClassesHeight
        } else {
            height = 427 + dropHoursHeight + 89 + facilitiesHeight + 137 + todaysClassesHeight
        }

        scrollView.contentSize = CGSize(width: view.frame.width, height: CGFloat(height))
    }

    func getStringFromDailyHours(dailyGymHours: DailyGymHours) -> String {
        if dailyGymHours.openTime != dailyGymHours.closeTime {
            return "\(dailyGymHours.openTime.getStringOfDatetime(format: "h:mm a")) - \(dailyGymHours.closeTime.getStringOfDatetime(format: "h:mm a"))"
        } else {
            return "Closed"
        }
    }

    //DROP HOURS
    @objc func dropHours( sender: UITapGestureRecognizer) {
        hoursTableView.beginUpdates()
        var modifiedIndices: [IndexPath] = []
        for i in 0..<6 {
            modifiedIndices.append(IndexPath(row: i, section: 0))
        }

        if (hoursData.isDropped) {
            hoursData.isDropped = false
            hoursTableView.deleteRows(at: modifiedIndices, with: .none)
            (hoursTableView.headerView(forSection: 0) as! GymHoursHeaderView).downArrow.image = .none
            (hoursTableView.headerView(forSection: 0) as! GymHoursHeaderView).rightArrow.image = #imageLiteral(resourceName: "right-arrow-solid")
        } else {
            hoursData.isDropped = true
            hoursTableView.insertRows(at: modifiedIndices, with: .none)
            (hoursTableView.headerView(forSection: 0) as! GymHoursHeaderView).downArrow.image = #imageLiteral(resourceName: "down-arrow-solid")
            (hoursTableView.headerView(forSection: 0) as! GymHoursHeaderView).rightArrow.image = .none
        }

        hoursTableView.endUpdates()
        setupConstraints()
    }

    // MARK: - BUTTON METHODS
    @objc func back() {
        navigationController!.popViewController(animated: true)
    }
}

// MARK: CollectionViewDataSource
extension GymDetailViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (collectionView == classesTableView) {
            return todaysClasses.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (collectionView == classesTableView) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ClassListCell.identifier, for: indexPath) as! ClassListCell
            let gymClassInstance = todaysClasses[indexPath.item]
            cell.classLabel.text = gymClassInstance.className
            cell.timeLabel.text = Date.getStringDate(date: gymClassInstance.startTime)
            cell.timeLabel.text = cell.timeLabel.text?.removeLeadingZero()
            
            cell.instructorLabel.text = gymClassInstance.instructor
            
            cell.duration = Int(gymClassInstance.duration) / 60
            cell.durationLabel.text = String(cell.duration) + " min"
            
            return cell
        }
        return UICollectionViewCell()
    }
}

// MARK: TableViewDataSource
extension GymDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == hoursTableView) {
            if (hoursData.isDropped) {
                return 6
            } else {
                return 0
            }
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (tableView == hoursTableView) {
            let cell = tableView.dequeueReusableCell(withIdentifier: GymHoursCell.identifier, for: indexPath) as! GymHoursCell
            let date = Date()
            let day = (date.getIntegerDayOfWeekToday() + indexPath.row + 1) % 7

            cell.hoursLabel.text = getStringFromDailyHours(dailyGymHours: gym.gymHoursToday)

            switch days[day] {
            case .sunday:
                cell.dayLabel.text = "Su"
            case .monday:
                cell.dayLabel.text = "M"
            case .tuesday:
                cell.dayLabel.text = "T"
            case .wednesday:
                cell.dayLabel.text = "W"
            case .thursday:
                cell.dayLabel.text = "Th"
            case .friday:
                cell.dayLabel.text = "F"
            case .saturday:
                cell.dayLabel.text = "Sa"
            }

            return cell
        } else {
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if (tableView == hoursTableView) {
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: GymHoursHeaderView.identifier) as! GymHoursHeaderView

            header.hoursLabel.text = getStringFromDailyHours(dailyGymHours: gym.gymHoursToday)

            let gesture = UITapGestureRecognizer(target: self, action: #selector(self.dropHours(sender:) ))
            header.addGestureRecognizer(gesture)

            return header
        } else {
            return nil
        }
    }
}

// MARK: TableViewDelegate
extension GymDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (tableView == hoursTableView) {
            return indexPath.row == 5 ? 19 : 27
        } else {
            return 112
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (tableView == hoursTableView) {
            if (hoursData.isDropped) {
                return 27
            } else {
                return 19
            }
        } else {
            return 0
        }
    }
}

extension GymDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        statusBarUpdater?.refreshStatusBarStyle()
    }
}
