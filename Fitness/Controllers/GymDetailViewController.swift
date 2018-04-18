//
//  GymDetailViewController.swift
//  Fitness
//
//  Created by Joseph Fulgieri on 4/18/18.
//  Copyright © 2018 Keivan Shahida. All rights reserved.
//

import UIKit
import SnapKit

struct HoursData {
    var isDropped: Bool!
    var data: [String]!
}

class GymDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //MARK: - INITIALIZATION
    var scrollView: UIScrollView!
    var contentView: UIView!
    
    var backButton: UIButton!
    var starButton: UIButton!
    var gymImageView: UIImageView!
    var titleLabel: UILabel!
    
    var hoursTitleLabel: UILabel!
    var hoursTableView: UITableView!
    var hoursData: HoursData!
    var hoursBusynessDivider: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        hoursData = HoursData(isDropped: false, data: [])
        
        scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.isScrollEnabled = true
        scrollView.bounces = false
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height * 2)
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        contentView = UIView()
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.top).offset(20)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.bottom.equalTo(view.snp.bottom)
        }
        
        //HEADER
        gymImageView = UIImageView(image: #imageLiteral(resourceName: "Noyes"))
        gymImageView.contentMode = UIViewContentMode.scaleAspectFill
        gymImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(gymImageView)
        
        backButton = UIButton()
        backButton.setImage(#imageLiteral(resourceName: "back-arrow"), for: .normal)
        backButton.sizeToFit()
        contentView.addSubview(backButton)
        
        starButton = UIButton()
        starButton.setImage(#imageLiteral(resourceName: "white-star"), for: .normal)
        starButton.sizeToFit()
        contentView.addSubview(starButton)
        
        titleLabel = UILabel()
        titleLabel.font = ._48Bebas
        titleLabel.textAlignment = .center
        titleLabel.sizeToFit()
        titleLabel.textColor = .white
        titleLabel.text = "NOYES"
        contentView.addSubview(titleLabel)
        
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
        
        hoursTableView.register(GymHoursCell.self, forCellReuseIdentifier: "gymHoursCell")
        hoursTableView.register(GymHoursHeaderView.self, forHeaderFooterViewReuseIdentifier: "gymHoursHeaderView")
        
        hoursTableView.delegate = self
        hoursTableView.dataSource = self
        contentView.addSubview(hoursTableView)
        
        hoursBusynessDivider = UIView()
        hoursBusynessDivider.backgroundColor = .fitnessLightGrey
        contentView.addSubview(hoursBusynessDivider)
        
        setupConstraints()
    }
    
    //MARK: - CONSTRAINTS
    func setupConstraints() {
        gymImageView.snp.updateConstraints{make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(-20)
            make.height.equalTo(360)
        }
        
        backButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(16)
            make.width.equalTo(23)
            make.height.equalTo(19)
        }
        
        starButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-21)
            make.top.equalToSuperview().offset(14)
            make.width.equalTo(23)
            make.height.equalTo(22)
        }
        
        titleLabel.snp.updateConstraints{make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(134)
            make.height.equalTo(57)
        }
        
        hoursTitleLabel.snp.updateConstraints{make in
            make.centerX.equalToSuperview()
            make.top.equalTo(gymImageView.snp.bottom).offset(36)
            make.height.equalTo(19)
        }
        
        hoursTableView.snp.updateConstraints{make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.top.equalTo(hoursTitleLabel.snp.bottom).offset(12)
            if (hoursData.isDropped){
                make.height.equalTo(181)
            }else{
                make.height.equalTo(27)
            }
        }
        
        hoursBusynessDivider.snp.updateConstraints{make in
            make.top.equalTo(hoursTableView.snp.bottom).offset(32)
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    //MARK: - TABLE VIEW METHODS
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (hoursData.isDropped){
            return 6
        } else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gymHoursCell", for: indexPath) as! GymHoursCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "gymHoursHeaderView") as! GymHoursHeaderView
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.dropHours(sender:) ))
        header.addGestureRecognizer(gesture)
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.row == 5){
            return 19
        }
        return 27
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(hoursData.isDropped){
            return 27
        }else{
            return 19
        }
    }
    
    //DROP HOURS
    @objc func dropHours( sender:UITapGestureRecognizer){
        hoursTableView.beginUpdates()
        var modifiedIndices: [IndexPath] = []
        for i in 0..<6{
            modifiedIndices.append(IndexPath(row: i, section: 0))
        }
        
        if (hoursData.isDropped){
            hoursData.isDropped = false
            hoursTableView.deleteRows(at: modifiedIndices, with: .none)
        }else{
            hoursData.isDropped = true
            hoursTableView.insertRows(at: modifiedIndices, with: .none)
        }
        
        hoursTableView.endUpdates()
        setupConstraints()
    }
}
