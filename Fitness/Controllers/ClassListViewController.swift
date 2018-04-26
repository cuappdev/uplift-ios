//
//  ClassListViewController.swift
//  Fitness
//
//  Created by Keivan Shahida on 3/21/18.
//  Copyright © 2018 Keivan Shahida. All rights reserved.
//

import UIKit
import SnapKit

class ClassListViewController: UITableViewController, UISearchBarDelegate {
    
    // MARK: - INITIALIZATION
    var gymClassInstances: [GymClassInstance]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView(frame: .zero, style: .grouped)
        tableView.bounces = false
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        
        tableView.register(ClassListHeaderView.self, forHeaderFooterViewReuseIdentifier: "classListHeader")
        tableView.register(ClassListCell.self, forCellReuseIdentifier: "classListCell")
        
        let searchBar = SearchBar.createSearchBar()
        searchBar.delegate = self
        self.navigationItem.titleView = searchBar
        
        let filterBarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "filter"), style: .plain, target: self, action: #selector(filter))
        self.navigationItem.rightBarButtonItem = filterBarButton
        
        view.backgroundColor = .white
        
        AppDelegate.networkManager.getGymClassInstancesByDate(date: "4/26/2018") { (gymClassInstances) in
            self.gymClassInstances = gymClassInstances
            self.tableView.reloadData()
        }
    }
    
    // MARK: - TABLEVIEW
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let numberOfRows = gymClassInstances?.count {
            return numberOfRows
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "classListCell", for: indexPath) as! ClassListCell
        
        if let gymClassInstance = gymClassInstances?[indexPath.row]{
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
            
            cell.durationLabel.text = duration + " min"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 112
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "classListHeader") as! ClassListHeaderView
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 155
    }
    
    // MARK: - SEARCH BAR
    @objc func filter(){
        let filterViewController = FilterViewController()
        navigationController!.pushViewController(filterViewController, animated: false)
    }
}
