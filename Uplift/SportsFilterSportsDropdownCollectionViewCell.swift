//
//  SportsFilterSportsDropdownCollectionViewCell.swift
//  Uplift
//
//  Created by Cameron Hamidi on 5/16/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import UIKit

class SportsFilterSportsDropdownCollectionViewCell: UICollectionViewCell {

    var sportsTypeDropdownData: SportsDropdownData

    override init(frame: CGRect) {
        super.init(frame: frame)
        sportsTypeDropdownData = SportsDropdownData(completed: false, dropStatus: .up, titles: [])

        // TODO: replace with networked sports.
        let sportsNames = ["Basketball", "Soccer", "Table Tennis", "Frisbee", "A", "B", "C"]
        sportsTypeDropdownData.titles.append(contentsOf: sportsNames)
        sportsTypeDropdownData.titles.sort()
        sportsTypeDropdownData.completed = true
//        sportsTypeDropdown.reloadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
