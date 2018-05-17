//
//  OpenGymsCell.swift
//  Fitness
//
//  Created by Joseph Fulgieri on 3/18/18.
//  Copyright © 2018 Keivan Shahida. All rights reserved.
//
import UIKit
import SnapKit

class AllGymsCell: UITableViewCell, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    // MARK: - INITIALIZATION
    var collectionView: UICollectionView!
    var gyms: [Gym] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var navigationController: UINavigationController?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //COLLECTION VIEW LAYOUT
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 19, bottom: 12, right: 40 )
        layout.minimumInteritemSpacing = 20
        layout.minimumLineSpacing = 12
        
        collectionView = UICollectionView(frame:.zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        
        collectionView.register(GymsCell.self , forCellWithReuseIdentifier: "gymsCell")
        
        contentView.addSubview(collectionView)
        
        collectionView.snp.updateConstraints{make in
            make.center.equalToSuperview()
            make.size.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - COLLECTION VIEW
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gymsCell", for: indexPath) as! GymsCell
        
        let gymHoursToday = gyms[indexPath.row].gymHours.getGymHours(isTomorrow: false)
        let openTimeToday = gymHoursToday.openTime
        let closeTimeToday = gymHoursToday.closeTime
        
        let gymHoursTomorrow = gyms[indexPath.row].gymHours.getGymHours(isTomorrow: true)
        let openTimeTomorrow = gymHoursTomorrow.openTime
        
        var isOpen = (closeTimeToday == "") ? false : (Date() > Date.getDateFromTime(time: openTimeToday)) && (Date() < Date.getDateFromTime(time: closeTimeToday))
        
        if(gyms[indexPath.row].name == "Bartels"){
            isOpen = true
            cell.hours.text = "Always open"
        } else if (closeTimeToday == "") {
             cell.hours.text = "Opens at \(openTimeTomorrow), tomorrow"
        } else if (!isOpen && Date() > Date.getDateFromTime(time: closeTimeToday)) {
            cell.hours.text = "Opens at \(openTimeTomorrow), tomorrow"
        } else if (!isOpen && Date() < Date.getDateFromTime(time: openTimeToday)) {
            cell.hours.text = "Opens at \(openTimeToday)"
        } else {
            cell.hours.text = "Closes at \(closeTimeToday)"
        }
        
        cell.locationName.text = gyms[indexPath.row].name
        cell.status.text = isOpen ? "Open" : "Closed"
        cell.status.textColor = isOpen ? .fitnessGreen : .fitnessRed
        cell.colorBar.backgroundColor = isOpen ? .fitnessYellow : .lightGray
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gyms.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (frame.width - 80)/2 , height: 48)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let gymDetailViewController = GymDetailViewController()
        gymDetailViewController.gym = gyms[indexPath.row]
        
        navigationController!.pushViewController(gymDetailViewController, animated: true)
    }
    
    // MARK: - GYM SORTING
    func sortGyms() {
        var closedIndices = [Int]()
        var openIndices = [Int]()
        
        for i in 0..<gyms.count{
            
            let gymHoursToday = gyms[i].gymHours.getGymHours(isTomorrow: false)
            let openTimeToday = gymHoursToday.openTime
            let closeTimeToday = gymHoursToday.closeTime
            
            var isOpen = (closeTimeToday == "") ? false : (Date() > Date.getDateFromTime(time: openTimeToday)) && (Date() < Date.getDateFromTime(time: closeTimeToday))
            
            if(gyms[i].name == "Bartels"){
                isOpen = true
            }
            
            if (!isOpen){
                closedIndices.append(i)
            }else{
                openIndices.append(i)
            }
        }
        let gymsRefenceCopy = gyms
        gyms = []
        
        for openIndex in openIndices{
            gyms.append(gymsRefenceCopy[openIndex])
        }
        
        for closedIndex in closedIndices{
            gyms.append(gymsRefenceCopy[closedIndex])
        }
    }
}
