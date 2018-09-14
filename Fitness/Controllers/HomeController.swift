//
//  HomeController.swift
//  Fitness
//
//  Created by Keivan Shahida on 2/24/18.
//  Copyright © 2018 Keivan Shahida. All rights reserved.
//
import UIKit
import SnapKit

enum SectionType {
    case allGyms
    case todaysClasses
    case lookingFor
}

class HomeController: UIViewController {
    
    // MARK: - INITIALIZATION
    var tableView: UITableView!
    var statusBarBackgroundColor: UIView!
    
    var sections: [SectionType] = []
    var gyms: [Gym] = []
    var gymClassInstances: [GymClassInstance] = []
    var gymLocations: [Int: String] = [:]
    var tags: [Tag] = []
    
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
        
        tableView.register(TodaysClassesCell.self, forCellReuseIdentifier: TodaysClassesCell.identifier)
        tableView.register(AllGymsCell.self, forCellReuseIdentifier: AllGymsCell.identifier)
        tableView.register(LookingForCell.self, forCellReuseIdentifier: LookingForCell.identifier)
        
        tableView.register(HomeScreenHeaderView.self, forHeaderFooterViewReuseIdentifier: HomeScreenHeaderView.identifier)
        tableView.register(HomeSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: HomeSectionHeaderView.identifier)
        
        sections.insert(.allGyms, at: 0)
        sections.insert(.todaysClasses, at: 1)
        sections.insert(.lookingFor, at: 2)
        
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
}

//MARK: TableViewDataSource
extension HomeController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch sections[indexPath.section] {
        case .allGyms:
            let cell = tableView.dequeueReusableCell(withIdentifier: AllGymsCell.identifier, for: indexPath) as! AllGymsCell
            cell.gyms = gyms
            cell.navigationController = navigationController
            return cell
        case .todaysClasses:
            let cell = tableView.dequeueReusableCell(withIdentifier: TodaysClassesCell.identifier, for: indexPath) as! TodaysClassesCell
            cell.gymClassInstances = gymClassInstances
            cell.gymLocations = gymLocations
            cell.navigationController = navigationController
            return cell
        case .lookingFor:
            let cell = tableView.dequeueReusableCell(withIdentifier: LookingForCell.identifier, for: indexPath) as! LookingForCell
            cell.tags = tags
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
}

//MARK: TableViewDelegate
extension HomeController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch sections[section] {
        case .allGyms:
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: HomeScreenHeaderView.identifier) as! HomeScreenHeaderView
            header.subHeader.titleLabel.text = "ALL GYMS"
            header.setName(name: "Joe")
            return header
        case .todaysClasses:
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: HomeSectionHeaderView.identifier) as! HomeSectionHeaderView
            header.titleLabel.text = "TODAY'S CLASSES"
            return header
        case .lookingFor:
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: HomeSectionHeaderView.identifier) as! HomeSectionHeaderView
            header.titleLabel.text = "I'M LOOKING FOR..."
            return header
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch sections[indexPath.section] {
        case .allGyms:
            return 180
        case .todaysClasses:
            return 207
        case .lookingFor:
            return CGFloat(143 * (tags.count / 2))
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch sections[section] {
        case .allGyms:
            return 155
        case .todaysClasses, .lookingFor:
            return 51
        }
    }
}
