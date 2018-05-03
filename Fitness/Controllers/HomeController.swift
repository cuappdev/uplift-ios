//
//  HomeController.swift
//  Fitness
//
//  Created by Keivan Shahida on 2/24/18.
//  Copyright © 2018 Keivan Shahida. All rights reserved.
//
import UIKit
import SnapKit

class HomeController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - INITIALIZATION
    var tableView: UITableView!
    var statusBarBackgroundColor: UIView!
    
    var gyms = [Gym]()
    var gymClassInstances = [GymClassInstance]()
    var gymLocations = [Int: String]()
    var tags = [Tag]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView(frame: .zero, style: .grouped)
        tableView.bounces = false
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.sectionFooterHeight = 0.0
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        
        tableView.register(TodaysClassesCell.self, forCellReuseIdentifier: "todaysClassesCell")
        tableView.register(AllGymsCell.self, forCellReuseIdentifier: "allGymsCell")
        tableView.register(LookingForCell.self, forCellReuseIdentifier: "lookingForCell")
        
        view.addSubview(tableView)
        
        tableView.snp.updateConstraints{make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.bottom.equalToSuperview().offset(-49)
        }
        
        statusBarBackgroundColor = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 21))
        statusBarBackgroundColor.backgroundColor = .white
        view.addSubview(statusBarBackgroundColor)
        
        // GET GYMS
        AppDelegate.networkManager.getGyms { (gyms) in
            self.gyms = gyms
            self.tableView.reloadData()
        }
        
        // GET TODAY'S CLASSES
        let date = Date()
        if let stringDate = date.getStringDate(date: date) {
            AppDelegate.networkManager.getGymClassInstancesByDate(date: stringDate) { (gymClassInstances) in
                self.gymClassInstances = gymClassInstances
                for gymClassInstance in gymClassInstances {
                    AppDelegate.networkManager.getGym(gymId: gymClassInstance.gymId, completion: { (gym) in
                        self.gymLocations[gymClassInstance.gymId] = gym.name
                        self.tableView.reloadData()
                    })
                }
            }
        }
        
        // GET TAGS
        AppDelegate.networkManager.getTags { (tags) in
            self.tags = tags
            self.tableView.reloadData()
        }
    }
    
    // MARK: - TABLE VIEW
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "allGymsCell", for: indexPath) as! AllGymsCell
            cell.gyms = gyms
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "todaysClassesCell", for: indexPath) as! TodaysClassesCell
            cell.gymClassInstances = gymClassInstances
            cell.gymLocations = gymLocations
            cell.navigationController = navigationController ?? nil
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "lookingForCell", for: indexPath) as! LookingForCell
            cell.tags = tags
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        switch section {
        case 0:
            let header = HomeScreenHeaderView(reuseIdentifier: "homeScreenHeaderView", name: "Joe")
            header.subHeader.titleLabel.text = "ALL GYMS"
            return header
        case 1:
            let header = HomeSectionHeaderView(frame: view.frame)
            header.titleLabel.text = "TODAY'S CLASSES"
            return header
        case 2:
            let header = HomeSectionHeaderView(frame: view.frame)
            header.titleLabel.text = "I'M LOOKING FOR..."
            return header
        default:
            return UIView()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        var height: CGFloat
        
        switch section {
        case 0:
            height = 155
        case 1:
            height = 51
        case 2:
            height = 51
        default:
            height = 0
        }
        
        return height
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var height: CGFloat
        
        switch indexPath.section {
        case 0:
            height = 180
        case 1:
            height = 207
        case 2:
            height = CGFloat(143 * (tags.count / 2))
        default:
            height = 0
        }
        
        return height
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
}
