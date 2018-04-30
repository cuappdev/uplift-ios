//
//  ClassListViewController.swift
//  Fitness
//
//  Created by Keivan Shahida on 3/21/18.
//  Copyright © 2018 Keivan Shahida. All rights reserved.
//

import UIKit
import SnapKit

struct filterParameters {
    var shouldFilter: Bool!
    var times: String!
    var instructorIds: [Int]!
    var classDescIds: [Int]!
    var gymIds: [Int]!
}

class ClassListViewController: UITableViewController, UISearchBarDelegate {
    
    // MARK: - INITIALIZATION
    var allGymClassInstances: [GymClassInstance]?
    var validGymClassInstances: [GymClassInstance]?
    
    var locations: [String]!
    
    var selectedDate: String!
    
    var shouldFilterSearch: Bool!
    var filterText: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedDate = "4/30/2018"
        
        tableView = UITableView(frame: .zero, style: .grouped)
        tableView.bounces = false
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        
        tableView.register(ClassListHeaderView.self, forHeaderFooterViewReuseIdentifier: "classListHeader")
        tableView.register(ClassListCell.self, forCellReuseIdentifier: "classListCell")
        
        let searchBar = SearchBar.createSearchBar()
        searchBar.delegate = self
        shouldFilterSearch = false
        filterText = ""
        
        self.navigationItem.titleView = searchBar
        
        let filterBarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "filter"), style: .plain, target: self, action: #selector(filter))
        self.navigationItem.rightBarButtonItem = filterBarButton
        
        view.backgroundColor = .white
        
        AppDelegate.networkManager.getGymClassInstancesByDate(date: selectedDate) { (gymClassInstances) in
            self.allGymClassInstances = gymClassInstances
            self.validGymClassInstances = self.getValidGymClassInstances()
            self.tableView.reloadData()
            self.locations = []
            
            var gymRoomCache: [Gym] = []
            var roomIsInCache = false
            
            for gymClassInstance in self.allGymClassInstances!{
                let instanceId = gymClassInstance.classDescription.id
                
                //checking if room data has been fetched
                for gym in gymRoomCache{
                    for classInstanceId in gym.classInstances{
                        if (instanceId == classInstanceId){
                            self.locations!.append(gym.name)
                            roomIsInCache = true
                        }
                    }
                }
                
                if(roomIsInCache == false){
                    let gymId = gymClassInstance.gymId
                    
                    AppDelegate.networkManager.getGym(gymId: gymId, completion: { gym in
                        self.locations!.append(gym.name)
                        
                        gymRoomCache.append(gym)
                    })
                }
                roomIsInCache = false
            }
            
            
            
            self.tableView.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController!.isNavigationBarHidden = false
        tabBarController!.tabBar.isHidden = false
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
            duration = duration + " min"
            cell.durationLabel.text = duration
            
            if((locations!.count) > indexPath.row){
                cell.locationLabel.text = locations![indexPath.row]
            }
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
        classDetailViewController.gymClassInstance = allGymClassInstances![indexPath.row]
        classDetailViewController.durationLabel.text = (tableView.cellForRow(at: indexPath) as! ClassListCell).durationLabel.text?.uppercased()
        classDetailViewController.date = selectedDate
        navigationController!.pushViewController(classDetailViewController, animated: true)
    }
    
    
    //MARK: - SEARCHING
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if (searchText != ""){
            shouldFilterSearch = true
        }
        filterText = searchText
        validGymClassInstances = getValidGymClassInstances()
        tableView.reloadData()
        shouldFilterSearch = false
    }
    
    //Returns all valid gymClassInstances to display
    func getValidGymClassInstances() -> [GymClassInstance]{
        var validInstances: [GymClassInstance] = []
        
        if (shouldFilterSearch == false){
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
        let header = tableView.headerView(forSection: 0) as! ClassListHeaderView
    }
    
    // MARK: - FILTER
    @objc func filter(){
        let filterViewController = FilterViewController()
        navigationController!.pushViewController(filterViewController, animated: true)
    }
}
