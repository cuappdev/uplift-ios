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
        

        tableView = UITableView(frame: view.frame)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        
        
        
        view.addSubview(tableView)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: (view.frame.height/3.0 - 20))
        
        //cell.backgroundColor = UIColor(white: 1, alpha: 50)
        
        if(indexPath.row == 0){
            cell.addSubview(OpenGymsView(frame: cell.frame))
        }else{
            cell.addSubview(TodaysClassesView(frame: cell.frame))
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        
        
        let welcomeMessage = UILabel(frame: CGRect(x: 16, y: 52, width: 299, height: 90))
        welcomeMessage.font = UIFont.boldSystemFont(ofSize: 32)
        welcomeMessage.lineBreakMode = .byWordWrapping
        welcomeMessage.numberOfLines = 0
        welcomeMessage.text = "Good Afternoon, Joe!"
        
        header.addSubview(welcomeMessage)
        header.backgroundColor = .yellow
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return (view.frame.height/3.0 - 40)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (view.frame.height/3.0 - 20)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    
    
    
}
