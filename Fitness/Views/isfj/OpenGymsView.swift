//
//  OpenGymsView.swift
//  Fitness
//
//  Created by Joseph Fulgieri on 3/7/18.
//  Copyright © 2018 Keivan Shahida. All rights reserved.
//

import UIKit

class OpenGymsView: UIView, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    var collectionView: UICollectionView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        
        
        collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        
        collectionView.register(OpenGymsCell.self , forCellWithReuseIdentifier: "OpenGymsCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.addSubview(collectionView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OpenGymsCell", for: indexPath) as! OpenGymsCell
            
        cell.image.image = #imageLiteral(resourceName: "download")
        cell.locName.text = "Helen Newman"
        cell.hours.text = "Open until 9:00 PM"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150 , height: frame.height)
    }
  
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake( 8, 8, 8, 8)
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
