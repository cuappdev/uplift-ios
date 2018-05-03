//
//  TodaysClassesCell.swift
//  Fitness
//
//  Created by Joseph Fulgieri on 3/18/18.
//  Copyright © 2018 Keivan Shahida. All rights reserved.
//
import UIKit
import SnapKit
import Alamofire
import AlamofireImage

class TodaysClassesCell: UITableViewCell, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    // MARK: - INITIALIZATION
    var collectionView: UICollectionView!
    var gymClassInstances: [GymClassInstance] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var gymLocations: [Int: String] = [:] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //COLLECTION VIEW LAYOUT
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16 )
        layout.minimumInteritemSpacing = 16
        layout.minimumLineSpacing = 12
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.register(ClassesCell.self , forCellWithReuseIdentifier: "classesCell")
        
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "classesCell", for: indexPath) as! ClassesCell
        let classInstance = gymClassInstances[indexPath.row]

        Alamofire.request(classInstance.classDescription.imageURL!).responseImage { response in
            if let image = response.result.value {
                cell.image.image = image
            }
        }
        
        cell.locationName.text = gymLocations[classInstance.gymId]
        cell.hours.text = classInstance.startTime
        cell.className.text = classInstance.classDescription.name
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gymClassInstances.count > 5 ? 5 : gymClassInstances.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 228 , height: 195)
    }
}
