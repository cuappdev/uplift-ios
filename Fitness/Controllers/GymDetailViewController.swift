//
//  GymDetailViewController.swift
//  Fitness
//
//  Created by Joseph Fulgieri on 4/18/18.
//  Copyright © 2018 Keivan Shahida. All rights reserved.
//

import UIKit
import SnapKit
import AlamofireImage
import Alamofire

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

class GymDetailViewController: UIViewController {

    // MARK: - INITIALIZATION
    var scrollView: UIScrollView!
    var contentView: UIView!

    var backButton: UIButton!
    var starButton: UIButton!
    var gymImageView: UIImageView!
    var titleLabel: UILabel!

    var hoursTitleLabel: UILabel!
    var hoursTableView: UITableView!
    var days: [Days]!
    var hoursData: HoursData!
    var hoursBusynessSeparator: UIView!

    var popularTimesTitleLabel: UILabel!
    var popularTimesHistogram: Histogram!
    var busynessFacilitiesSeparator: UIView!

    var facilitiesTitleLabel: UILabel!
    var facilitiesData: [String]!       //temp (until backend implements equiment)
    var facilitiesLabelArray: [UILabel]!
    var facilitiesClassesDivider: UIView!

    var todaysClassesLabel: UILabel!
    var classesTableView: UITableView!
    var todaysClasses: [GymClassInstance] = []

    var gym: Gym!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

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

        classesTableView = UITableView(frame: .zero, style: .grouped)
        classesTableView.separatorStyle = .none
        classesTableView.bounces = false
        classesTableView.showsVerticalScrollIndicator = false
        classesTableView.backgroundColor = .white
        classesTableView.clipsToBounds = false

        classesTableView.register(ClassListCell.self, forCellReuseIdentifier: ClassListCell.identifier)

        classesTableView.delegate = self
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
        scrollView.bounces = false
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
        gymImageView.contentMode = UIViewContentMode.scaleAspectFill
        gymImageView.translatesAutoresizingMaskIntoConstraints = false
        gymImageView.clipsToBounds = true
        contentView.addSubview(gymImageView)
        
        Alamofire.request(gym.imageURL).responseImage { response in
            if let image = response.result.value {
                self.gymImageView.image = image
            }
        }
        
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
        
        hoursBusynessSeparator = UIView()
        hoursBusynessSeparator.backgroundColor = .fitnessLightGrey
        contentView.addSubview(hoursBusynessSeparator)
        
        //POPULAR TIMES
        popularTimesTitleLabel = UILabel()
        popularTimesTitleLabel.font = ._16MontserratMedium
        popularTimesTitleLabel.textAlignment = .center
        popularTimesTitleLabel.textColor = .fitnessBlack
        popularTimesTitleLabel.sizeToFit()
        popularTimesTitleLabel.text = "POPULAR TIMES"
        contentView.addSubview(popularTimesTitleLabel)
        
        days = [.sunday, .monday, .tuesday, .wednesday, .thursday, .friday, .saturday]
        
        let data = gym.popularTimesList[Date().getIntegerDayOfWeekToday()]
        let todaysHours = gym.gymHoursToday
        
        popularTimesHistogram = Histogram(frame: CGRect(x: 0, y: 0, width: view.frame.width - 36, height: 0), data: data, todaysHours: todaysHours)
        contentView.addSubview(popularTimesHistogram)
        
        busynessFacilitiesSeparator = UIView()
        busynessFacilitiesSeparator.backgroundColor = .fitnessLightGrey
        contentView.addSubview(busynessFacilitiesSeparator)
    }
    
    // MARK: - CONSTRAINTS
    func setupConstraints() {
        //HEADER
        gymImageView.snp.updateConstraints {make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(-20)
            make.height.equalTo(360)
        }

        backButton.snp.updateConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(16)
            make.width.equalTo(23)
            make.height.equalTo(19)
        }

        starButton.snp.updateConstraints { make in
            make.right.equalToSuperview().offset(-21)
            make.top.equalToSuperview().offset(14)
            make.width.equalTo(23)
            make.height.equalTo(22)
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

        hoursBusynessSeparator.snp.updateConstraints {make in
            make.top.equalTo(hoursTableView.snp.bottom).offset(32)
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
        }

        //POPULAR TIMES
        popularTimesTitleLabel.snp.updateConstraints {make in
            make.top.equalTo(hoursBusynessSeparator.snp.bottom).offset(24)
            make.centerX.width.equalToSuperview()
            make.height.equalTo(19)
        }

        popularTimesHistogram.snp.updateConstraints {make in
            make.top.equalTo(popularTimesTitleLabel.snp.bottom).offset(24)
            make.left.equalToSuperview().offset(18)
            make.right.equalToSuperview().offset(-18)
            make.height.equalTo(101)
        }

        busynessFacilitiesSeparator.snp.updateConstraints {make in
            make.left.right.equalToSuperview()
            make.top.equalTo(popularTimesHistogram.snp.bottom).offset(24)
            make.height.equalTo(1)
        }

        //FACILITIES
        facilitiesTitleLabel.snp.updateConstraints {make in
            make.top.equalTo(busynessFacilitiesSeparator.snp.bottom).offset(24)
            make.centerX.width.equalToSuperview()
            make.height.equalTo(19)
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
            make.top.equalTo(facilitiesLabelArray.last!.snp.bottom).offset(24)
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
            make.height.equalTo(classesTableView.numberOfRows(inSection: 0) * 112)
        }

        var dropHoursHeight = 27
        if hoursData.isDropped {
            dropHoursHeight = 181
        }

        let facilitiesHeight = facilitiesData.count*20
        let todaysClassesHeight = classesTableView.numberOfRows(inSection: 0)*112

        //THIS MUST BE CHANGED IF ANY OF THE SCREEN'S HARD-CODED HEIGHTS ARE ALTERED
        let height = 427 + dropHoursHeight + 282 + facilitiesHeight + 137 + todaysClassesHeight
        scrollView.contentSize = CGSize(width: view.frame.width, height: CGFloat(height))
    }

    func getStringFromDailyHours(dailyGymHours: DailyGymHours) -> String {
        if dailyGymHours.openTime != dailyGymHours.closeTime {
            return "\(dailyGymHours.openTime.getStringOfDatetime(format: "h:m a")) - \(dailyGymHours.closeTime.getStringOfDatetime(format: "h:m a"))"
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

    @objc func favorite() {
        //TODO: Replace with favorite functionality
        print("favorite")
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
            return todaysClasses.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (tableView == hoursTableView) {
            let cell = tableView.dequeueReusableCell(withIdentifier: GymHoursCell.identifier, for: indexPath) as! GymHoursCell
            let date = Date()
            let day = (date.getIntegerDayOfWeekToday() + indexPath.row + 1)%7
            
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
            let cell = tableView.dequeueReusableCell(withIdentifier: ClassListCell.identifier, for: indexPath) as! ClassListCell

            let gymClassInstance = todaysClasses[indexPath.row]

            cell.classLabel.text = gymClassInstance.classDescription.name
            cell.timeLabel.text = gymClassInstance.startTime
            cell.timeLabel.text = cell.timeLabel.text?.removeLeadingZero()

            cell.instructorLabel.text = gymClassInstance.instructor.name

            cell.duration = Date.getMinutesFromDuration(duration: gymClassInstance.duration)
            cell.durationLabel.text = String(cell.duration) + " min"

            //location

            return cell
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
