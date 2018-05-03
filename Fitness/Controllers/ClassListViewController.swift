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
    var endTime: String!
    var instructorIds: [Int]!
    var classDescIds: [Int]!
    var gymIds: [Int]!
}

class ClassListViewController: UITableViewController, UISearchBarDelegate {
    
    // MARK: - INITIALIZATION
    var allGymClassInstances: [GymClassInstance]?
    var validGymClassInstances: [GymClassInstance]?
    
    var locations: [Int:String]!
    
    var selectedDate: String!
    
    var filterParameters: FilterParameters!
    
    var shouldFilterBySearchbar: Bool!
    var filterText: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/YYYY"
        selectedDate = dateFormatter.string(from: Date())
        
        filterParameters = FilterParameters(shouldFilter: false, startTime: "", endTime: "", instructorIds: [], classDescIds: [], gymIds: [])
        
        tableView = UITableView(frame: .zero, style: .grouped)
        tableView.bounces = false
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        
        tableView.register(ClassListHeaderView.self, forHeaderFooterViewReuseIdentifier: "classListHeader")
        tableView.register(ClassListCell.self, forCellReuseIdentifier: "classListCell")
        
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
        
        if (filterParameters.shouldFilter){
            //update gyms given filter
            filterParameters.shouldFilter = false
        }
       
        
    }
    
    func updateGymClasses() {
        AppDelegate.networkManager.getGymClassInstancesByDate(date: selectedDate) { (gymClassInstances) in
            self.allGymClassInstances = gymClassInstances
            self.validGymClassInstances = self.getValidGymClassInstances()
            
            self.locations = [:]
            self.getLocations()
            
            self.tableView.reloadData()
        }
    }
    
    func getLocations() {
        var gymRoomCache: [Gym] = []
        var roomIsInCache = false
        
        for gymClassInstance in self.allGymClassInstances!{
            let classDescId = gymClassInstance.classDescription.id
            
            //checking if room data has been fetched
            for gym in gymRoomCache{
                for classInstanceId in gym.classInstances{
                    if (classDescId == classInstanceId){
                        self.locations.updateValue(gym.name, forKey: classDescId)
                        roomIsInCache = true
                    }
                }
            }
            
            if(roomIsInCache == false){
                let gymId = gymClassInstance.gymId
                
                AppDelegate.networkManager.getGym(gymId: gymId, completion: { gym in
                    self.locations.updateValue(gym.name, forKey: classDescId)
                    gymRoomCache.append(gym)
                    self.tableView.reloadData()
                    
                })
            }
            roomIsInCache = false
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "classListCell", for: indexPath) as! ClassListCell
        
        if let gymClassInstance = validGymClassInstances?[indexPath.row]{
            
            cell.classLabel.text = gymClassInstance.classDescription.name
            cell.timeLabel.text = gymClassInstance.startTime
            if (cell.timeLabel.text?.hasPrefix("0"))!{
                cell.timeLabel.text = cell.timeLabel.text?.substring(from: String.Index(encodedOffset: 1))
            }
            cell.instructorLabel.text = gymClassInstance.instructor.name
            var duration = gymClassInstance.duration
            if duration.hasPrefix("0"){
                duration = duration.substring(from: String.Index(encodedOffset: 2))
            }else{
                let hours = duration.substring(to: String.Index(encodedOffset: duration.count-3))
                duration = duration.substring(from: String.Index(encodedOffset: 2))
                duration = String( Int(hours)!*60 + Int(duration)!)
            }
            cell.duration = Int(duration)
            duration = duration + " min"
            cell.durationLabel.text = duration
            
            cell.locationLabel.text = locations[gymClassInstance.classDescription.id]
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 112
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "classListHeader") as! ClassListHeaderView
        
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
        
        Alamofire.request(allGymClassInstances![indexPath.row].classDescription.imageURL!).responseImage { response in
            if let image = response.result.value {
                classDetailViewController.classImageView.image = image
            }
        }
        
        //DATE
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let day = dateFormatter.date(from: self.selectedDate)
        
        dateFormatter.dateFormat = "EEEE"
        var dateLabel = dateFormatter.string(from: day!)
        dateFormatter.dateFormat = "MMMM"
        dateLabel = dateLabel + ", " + dateFormatter.string(from: day!)
        dateFormatter.dateFormat = "d"
        dateLabel = dateLabel + " " + dateFormatter.string(from: day!)
        classDetailViewController.dateLabel.text = dateLabel
        
        //TIME
        var time = Date.getDateFromTime(time: classDetailViewController.gymClassInstance.startTime)
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: "EDT")!
 
        time = calendar.date(byAdding: .minute, value: cell.duration, to: time)!
        dateFormatter.dateFormat = "h:mm a"
        let endTime = dateFormatter.string(from: time)
        
        classDetailViewController.timeLabel.text = classDetailViewController.gymClassInstance.startTime + " - " + endTime
        
        navigationController!.pushViewController(classDetailViewController, animated: true)
    }
    
    
    //MARK: - SEARCHING
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if (searchText != ""){
            shouldFilterBySearchbar = true
        }
        filterText = searchText
        validGymClassInstances = getValidGymClassInstances()
        tableView.reloadData()
        shouldFilterBySearchbar = false
    }
    
    //Returns all valid gymClassInstances to display
    func getValidGymClassInstances() -> [GymClassInstance]{
        var validInstances: [GymClassInstance] = []
        
        if (shouldFilterBySearchbar == false){
            return allGymClassInstances!
        }
        
        for gymClassInstance in allGymClassInstances!{
            if gymClassInstance.classDescription.name.contains(filterText){
                validInstances.append(gymClassInstance)
            }
        }
        
        return validInstances
    }
    
    //called by header when new date is selected
    func updateDate(){
        updateGymClasses()
    }
    
    // MARK: - FILTER
    @objc func filter(){
        let filterViewController = FilterViewController()
        navigationController!.pushViewController(filterViewController, animated: true)
    }
    
    @objc func reset(){
        filterParameters.shouldFilter = false
        //update data
    }
}
