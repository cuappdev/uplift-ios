//
//  ClassListHeaderView.swift
//  Fitness
//
//  Created by Keivan Shahida on 3/21/18.
//  Copyright © 2018 Keivan Shahida. All rights reserved.
//

import UIKit
import SnapKit

class ClassListHeaderView: UITableViewHeaderFooterView, UICollectionViewDataSource, UICollectionViewDelegate {

    // MARK: - INITIALIZATION
    var collectionView: UICollectionView!
    
    var currentDateLabel: UILabel!
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        layer.backgroundColor = UIColor.white.cgColor

        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 54, height: 97)
        flowLayout.scrollDirection = UICollectionViewScrollDirection.horizontal
        flowLayout.minimumInteritemSpacing = 0.0
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.layer.backgroundColor = UIColor.clear.cgColor
        collectionView.register(CalendarCell.self, forCellWithReuseIdentifier: "calendarCell")
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
        
        addSubview(collectionView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LAYOUT
    override open func layoutSubviews() {
        super.layoutSubviews()

        currentDateLabel = UILabel()
        currentDateLabel.text = "TODAY"
        currentDateLabel.font = ._14MontserratMedium
        currentDateLabel.textAlignment = .center
        currentDateLabel.textColor = .fitnessDarkGrey
        currentDateLabel.sizeToFit()
        addSubview(currentDateLabel)
        
        setConstraints()
    }
    
    // MARK: - CONSTRAINTS
    func setConstraints(){
        
        collectionView.snp.makeConstraints { make in
            make.left.equalTo(contentView)
            make.right.equalTo(contentView)
            make.top.equalTo(contentView)
            make.height.equalTo(97)
        }
        
        currentDateLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-32)
            make.height.equalTo(15)
        }
    }
    
    // MARK: - COLLECTION VIEW
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "calendarCell", for: indexPath) as! CalendarCell
        return cell
    }
}
