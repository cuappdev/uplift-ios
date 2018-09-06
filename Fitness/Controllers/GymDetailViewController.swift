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

class GymDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - INITIALIZATION
    var scrollView: UIScrollView!
    var contentView: UIView!

    var backButton: UIButton!
    var starButton: UIButton!
    var gymImageView: UIImageView!
    var titleLabel: UILabel!

    var hoursTitleLabel: UILabel!
    var hoursTableView: UITableView!
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

        setupHeader()
        setupHoursAndPopularTimes()

        busynessFacilitiesSeparator = UIView()
        busynessFacilitiesSeparator.backgroundColor = .fitnessLightGrey
        contentView.addSubview(busynessFacilitiesSeparator)

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

        classesTableView.register(ClassListCell.self, forCellReuseIdentifier: "classListCell")

        classesTableView.delegate = self
        classesTableView.dataSource = self
        contentView.addSubview(classesTableView)

        //get gym class instances once branch merged

        setupConstraints()
    }


    // MARK: - HEADER VIEWS
    func setupHeader() {
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
    func setupHoursAndPopularTimes() {
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

        hoursTableView.register(GymHoursCell.self, forCellReuseIdentifier: "gymHoursCell")
        hoursTableView.register(GymHoursHeaderView.self, forHeaderFooterViewReuseIdentifier: "gymHoursHeaderView")

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

        var data: [Int]
        let date = Date()
        let todaysHours: DailyGymHours

        switch date.getIntegerDayOfWeekToday() {
        case 0:
            data = gym.popularTimesList.sunday
            todaysHours = gym.gymHours.zero ?? DailyGymHours(id: -1, dayOfWeek: 0, openTime: "", closeTime: "")
        case 1:
            data = gym.popularTimesList.monday
            todaysHours = gym.gymHours.one ?? DailyGymHours(id: -1, dayOfWeek: 1, openTime: "", closeTime: "")
        case 2:
            data = gym.popularTimesList.tuesday
            todaysHours = gym.gymHours.two ?? DailyGymHours(id: -1, dayOfWeek: 2, openTime: "", closeTime: "")
        case 3:
            data = gym.popularTimesList.wednesday
            todaysHours = gym.gymHours.three ?? DailyGymHours(id: -1, dayOfWeek: 3, openTime: "", closeTime: "")
        case 4:
            data = gym.popularTimesList.thursday
            todaysHours = gym.gymHours.four ?? DailyGymHours(id: -1, dayOfWeek: 4, openTime: "", closeTime: "")
        case 5:
            data = gym.popularTimesList.friday
            todaysHours = gym.gymHours.five ?? DailyGymHours(id: -1, dayOfWeek: 5, openTime: "", closeTime: "")
        case 6:
            data = gym.popularTimesList.saturday
            todaysHours = gym.gymHours.six ?? DailyGymHours(id: -1, dayOfWeek: 6, openTime: "", closeTime: "")
        default:
            data = gym.popularTimesList.sunday
            todaysHours = gym.gymHours.zero ?? DailyGymHours(id: -1, dayOfWeek: 0, openTime: "", closeTime: "")
        }

        popularTimesHistogram = Histogram(frame: CGRect(x: 0, y: 0, width: view.frame.width - 36, height: 0), data: data, todaysHours: todaysHours)
        contentView.addSubview(popularTimesHistogram)
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

    // MARK: - TABLE VIEW METHODS
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView == hoursTableView) {
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
        if(tableView == hoursTableView) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "gymHoursCell", for: indexPath) as! GymHoursCell
            let date = Date()
            let day = (date.getIntegerDayOfWeekToday()! + indexPath.row + 1)%7

            switch day {
            case 0:
                cell.dayLabel.text = "Su"
                if let gymHours = gym.gymHours.zero {
                    cell.hoursLabel.text = gymHours.openTime + " - " + gymHours.closeTime
                } else {
                    cell.hoursLabel.text = "Closed"
                }
            case 1:
                cell.dayLabel.text = "M"
                if let gymHours = gym.gymHours.one {
                    cell.hoursLabel.text = gymHours.openTime + " - " + gymHours.closeTime
                } else {
                    cell.hoursLabel.text = "Closed"
                }
            case 2:
                cell.dayLabel.text = "T"
                if let gymHours = gym.gymHours.two {
                    cell.hoursLabel.text = gymHours.openTime + " - " + gymHours.closeTime
                } else {
                    cell.hoursLabel.text = "Closed"
                }
            case 3:
                cell.dayLabel.text = "W"
                if let gymHours = gym.gymHours.three {
                    cell.hoursLabel.text = gymHours.openTime + " - " + gymHours.closeTime
                } else {
                    cell.hoursLabel.text = "Closed"
                }
            case 4:
                cell.dayLabel.text = "Th"
                if let gymHours = gym.gymHours.four {
                    cell.hoursLabel.text = gymHours.openTime + " - " + gymHours.closeTime
                } else {
                    cell.hoursLabel.text = "Closed"
                }
            case 5:
                cell.dayLabel.text = "F"
                if let gymHours = gym.gymHours.five {
                    cell.hoursLabel.text = gymHours.openTime + " - " + gymHours.closeTime
                } else {
                    cell.hoursLabel.text = "Closed"
                }
            case 6:
                cell.dayLabel.text = "Sa"
                if let gymHours = gym.gymHours.six {
                    cell.hoursLabel.text = gymHours.openTime + " - " + gymHours.closeTime
                } else {
                    cell.hoursLabel.text = "Closed"
                }
            default:
                cell.hoursLabel.text = ""
            }

            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "classListCell", for: indexPath) as! ClassListCell

            let gymClassInstance = todaysClasses[indexPath.row]

            cell.classLabel.text = gymClassInstance.classDescription.name
            cell.timeLabel.text = gymClassInstance.startTime

            if (cell.timeLabel.text?.hasPrefix("0"))! {
                cell.timeLabel.text = cell.timeLabel.text?.substring(from: String.Index(encodedOffset: 1))
            }
            cell.instructorLabel.text = gymClassInstance.instructor.name

            cell.duration = Date.getMinutesFromDuration(duration: gymClassInstance.duration)
            cell.durationLabel.text = String(cell.duration) + " min"

            //location

            return cell
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if(tableView == hoursTableView) {
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "gymHoursHeaderView") as! GymHoursHeaderView

            let date = Date()
            let currentDay = date.getIntegerDayOfWeekToday()

            switch currentDay {
            case 0:
                if let gymHours = gym.gymHours.zero {
                    header.hoursLabel.text = gymHours.openTime + " - " + gymHours.closeTime
                } else {
                    header.hoursLabel.text = "Closed Today"
                }
            case 1:
                if let gymHours = gym.gymHours.one {
                    header.hoursLabel.text = gymHours.openTime + " - " + gymHours.closeTime
                } else {
                    header.hoursLabel.text = "Closed Today"
                }
            case 2:
                if let gymHours = gym.gymHours.two {
                    header.hoursLabel.text = gymHours.openTime + " - " + gymHours.closeTime
                } else {
                    header.hoursLabel.text = "Closed Today"
                }
            case 3:
                if let gymHours = gym.gymHours.three {
                    header.hoursLabel.text = gymHours.openTime + " - " + gymHours.closeTime
                } else {
                    header.hoursLabel.text = "Closed Today"
                }
            case 4:
                if let gymHours = gym.gymHours.four {
                    header.hoursLabel.text = gymHours.openTime + " - " + gymHours.closeTime
                } else {
                    header.hoursLabel.text = "Closed Today"
                }
            case 5:
                if let gymHours = gym.gymHours.five {
                    header.hoursLabel.text = gymHours.openTime + " - " + gymHours.closeTime
                } else {
                    header.hoursLabel.text = "Closed Today"
                }
            case 6:
                if let gymHours = gym.gymHours.six {
                    header.hoursLabel.text = gymHours.openTime + " - " + gymHours.closeTime
                } else {
                    header.hoursLabel.text = "Closed Today"
                }
            default:
                header.hoursLabel.text = ""
            }

            let gesture = UITapGestureRecognizer(target: self, action: #selector(self.dropHours(sender:) ))
            header.addGestureRecognizer(gesture)

            return header
        } else {
            return nil
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(tableView == hoursTableView) {
            if (indexPath.row == 5) {
                return 19
            }
                return 27
        } else {
            return 112
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (tableView == hoursTableView) {
            if(hoursData.isDropped) {
                return 27
            } else {
                return 19
                }
        } else {
            return 0
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
        print("favorite")
    }
}
