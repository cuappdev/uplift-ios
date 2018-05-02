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
        
        cell.locationName.text = gyms[indexPath.row].name
        
        let isOpen = Date() < Date.getDateFromTime(time: gyms[indexPath.row].gymHours[Date().getIntegerDayOfWeek()!].closeTime)
        cell.status.text = isOpen ? "Open" : "Closed"
        cell.status.textColor = isOpen ? .fitnessGreen : .fitnessRed
        
       // cell.hours.text = "Closes at \(gymHour.closeTime)"
        //            cell.hours.text = "Reopens at 9 AM"
        cell.colorBar.backgroundColor = isOpen ? .fitnessYellow : .lightGray
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gyms.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (frame.width - 80)/2 , height: 48)
    }
}
