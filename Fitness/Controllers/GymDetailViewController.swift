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
    var hoursBusynessSeparator: UIView!
    
    var popularTimesTitleLabel: UILabel!
    var popularTimesPlaceholder: UIView!
    var busynessFacilitiesSeparator: UIView!
    
    var facilitiesTitleLabel: UILabel!
    var facilitiesData: [String]!
    var facilitiesLabelArray: [UILabel]!
    var facilitiesClassesDivider: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        hoursData = HoursData(isDropped: false, data: [])
        facilitiesData = ["Pool", "Two-court Gymnasium", "Dance Studio", "16-lane Bowling Center"]
        
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
        
        popularTimesPlaceholder = UIView()
        contentView.addSubview(popularTimesPlaceholder)
        
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
        
        for i in 0..<facilitiesData.count{
            //
        }
        
        
        setupConstraints()
    }
    
    //MARK: - CONSTRAINTS
    func setupConstraints() {
        //HEADER
        gymImageView.snp.updateConstraints{make in
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
        
        titleLabel.snp.updateConstraints{make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(134)
            make.height.equalTo(57)
        }
        
        //HOURS
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
        
        hoursBusynessSeparator.snp.updateConstraints{make in
            make.top.equalTo(hoursTableView.snp.bottom).offset(32)
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
        }
        
        //POPULAR TIMES
        popularTimesTitleLabel.snp.updateConstraints{make in
            make.top.equalTo(hoursBusynessSeparator.snp.bottom).offset(24)
            make.centerX.width.equalToSuperview()
            make.height.equalTo(19)
        }
        
        popularTimesPlaceholder.snp.updateConstraints{make in
            make.top.equalTo(popularTimesTitleLabel.snp.bottom).offset(24)
            make.left.right.equalToSuperview()
            make.height.equalTo(101)
        }
        
        busynessFacilitiesSeparator.snp.updateConstraints{make in
            make.left.right.equalToSuperview()
            make.top.equalTo(popularTimesPlaceholder.snp.bottom).offset(24)
            make.height.equalTo(1)
        }
        
        //FACILITIES
        facilitiesTitleLabel.snp.updateConstraints{make in
            make.top.equalTo(busynessFacilitiesSeparator.snp.bottom).offset(24)
            make.centerX.width.equalToSuperview()
            make.height.equalTo(19)
        }
        
        for i in 0..<facilitiesData.count{
            
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
            (hoursTableView.headerView(forSection: 0) as! GymHoursHeaderView).downArrow.image = .none
            (hoursTableView.headerView(forSection: 0) as! GymHoursHeaderView).rightArrow.image = #imageLiteral(resourceName: "right-arrow-solid")
        }else{
            hoursData.isDropped = true
            hoursTableView.insertRows(at: modifiedIndices, with: .none)
            (hoursTableView.headerView(forSection: 0) as! GymHoursHeaderView).downArrow.image = #imageLiteral(resourceName: "down-arrow-solid")
            (hoursTableView.headerView(forSection: 0) as! GymHoursHeaderView).rightArrow.image = .none
        }
        
        hoursTableView.endUpdates()
        setupConstraints()
    }
}
