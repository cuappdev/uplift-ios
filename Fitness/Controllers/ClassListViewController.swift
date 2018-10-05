//
//  ClassListViewController.swift
//  Fitness
//
//  Created by Keivan Shahida on 3/21/18.
//  Copyright © 2018 Keivan Shahida. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire
import AlamofireImage

struct FilterParameters {
    var shouldFilter: Bool!
    var startTime: String!
    var encodedStartTime: Double!
    var endTime: String!
    var encodedEndTime: Double!
    var instructorNames: [String]!
    var classNames: [String]!
    var gymIds: [String]!
}

class ClassListViewController: UITableViewController, UISearchBarDelegate {

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
        dateFormatter.dateFormat = "MM/dd/YYYY"
        selectedDate = dateFormatter.string(from: Date())

        filterParameters = FilterParameters(shouldFilter: false, startTime: "6:00AM", encodedStartTime: 0, endTime: "10:00PM", encodedEndTime: 960, instructorNames: [], classNames: [], gymIds: [])

        tableView = UITableView(frame: .zero, style: .grouped)
        tableView.bounces = false
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

        header.delegate = self
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
        dateFormatter.dateFormat = "MM/dd/yyyy"
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
}
