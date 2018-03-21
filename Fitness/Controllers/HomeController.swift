//
//  HomeController.swift
//  Fitness
//
//  Created by Keivan Shahida on 2/24/18.
//  Copyright © 2018 Keivan Shahida. All rights reserved.
//

import UIKit

class HomeController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var tableView: UITableView!
    var backgroundColor: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        tableView = UITableView(frame: view.frame, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TodaysClassesCell.self, forCellReuseIdentifier: "TodaysClassesCell")
        tableView.register(AllGymsCell.self, forCellReuseIdentifier: "AllGymsCell")
        tableView.register(LookingForCell.self, forCellReuseIdentifier: "LookingForCell")
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        view.addSubview(tableView)
        
        
        //to avoid an issue where you could see the contents of the tableview under the status bar when scrolling down
        let statusBG = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 21))
        statusBG.backgroundColor = .white
        view.addSubview(statusBG)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AllGymsCell", for: indexPath) as! AllGymsCell
            cell.updateFrame(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 175)) //should I bother to make the updateFrame part of a protocol and mmake the cells conform to it? is it worth it just for this fcn?
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TodaysClassesCell", for: indexPath) as! TodaysClassesCell
            cell.updateFrame(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 258))
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "LookingForCell", for: indexPath) as! LookingForCell
            cell.updateFrame(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 371))
            return cell
        default:
            return UITableViewCell()
        }

    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return HomeScreenHeaderView(reuseIdentifier: "HomeScreenHeaderView" , name: "Joe")
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return (100)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var height: CGFloat
        
        switch indexPath.row {
        case 0:
            height = 175
        case 1:
            height = 258
        case 2:
            height = 371
        default:
            height = 0
        }
        
        return height
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    
    
    
}
