//
//  GymDetailFacilitiesCell.swift
//  Uplift
//
//  Created by Yana Sang on 9/5/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import UIKit
import SnapKit

class GymDetailFacilitiesCell: UICollectionViewCell {
    private let collectionView: UICollectionView!
    private var facilities: [Facility] = []
    private var reloadGymDetailCollectionViewClosure: ((Int?, [[Int: Int]]) -> ())?
    private var dropdownCellStatuses: [DropdownStatus] = []
    private var calendarSelectedIndices: [[Int: Int]] = []

    override init(frame: CGRect) {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.minimumLineSpacing = 0

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)

        super.init(frame: frame)
        
        backgroundColor = .white
        isUserInteractionEnabled = true

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(FacilitiesDropdownCell.self, forCellWithReuseIdentifier: Identifiers.facilitiesDropdownCell)
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = .white
        contentView.addSubview(collectionView)

        collectionView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(for facilities: [Facility],
                   dropdownStatuses: [DropdownStatus],
                   calendarSelectedIndices: [[Int: Int]],
                   reloadGymDetailCollectionViewClosure: @escaping ((Int?, [[Int: Int]]) -> ())) {
        setNeedsUpdateConstraints()
        self.facilities = facilities
        self.dropdownCellStatuses = dropdownStatuses
        self.calendarSelectedIndices = calendarSelectedIndices
        self.reloadGymDetailCollectionViewClosure = reloadGymDetailCollectionViewClosure
        
        while self.calendarSelectedIndices.count < self.facilities.count {
            self.calendarSelectedIndices.append([:])
        }

        collectionView.reloadData()
    }

    static func getHeights(for facilities: [Facility], dropdownCellStatuses: [DropdownStatus]?, calendarSelectedIndices: [[Int: Int]]) -> CGFloat {
        var height: CGFloat = 0
        for i in 0..<facilities.count {
            if dropdownCellStatuses?[i] == .open {
                height += FacilitiesDropdownCell.getFacilityHeight(for: facilities[i], calendarSelectedIndices: calendarSelectedIndices[i])
            } else {
                height += FacilitiesDropdownCell.headerViewHeight
            }
        }
        return height
    }
}

extension GymDetailFacilitiesCell: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = dropdownCellStatuses[indexPath.row] == .open ? FacilitiesDropdownCell.getFacilityHeight(for: facilities[indexPath.row], calendarSelectedIndices: calendarSelectedIndices[indexPath.row]) : FacilitiesDropdownCell.headerViewHeight
        return CGSize(width: collectionView.bounds.width, height: height)
    }

}

extension GymDetailFacilitiesCell: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return facilities.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //swiftlint:disable:next force_cast
        let reloadFacilitiesCellClosure: (Int?, [Int: Int]) -> () = { index, calendarIndices in
            self.calendarSelectedIndices[indexPath.row] = calendarIndices
            self.reloadGymDetailCollectionViewClosure?(index, self.calendarSelectedIndices)
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.facilitiesDropdownCell, for: indexPath) as! FacilitiesDropdownCell
        cell.configure(for: facilities[indexPath.row],
                       index: indexPath.row,
                       dropdownStatus: dropdownCellStatuses[indexPath.row],
                       calendarSelectedIndices: calendarSelectedIndices[indexPath.row],
                       headerViewTapped: reloadFacilitiesCellClosure)
        cell.isUserInteractionEnabled = true
        return cell
    }

}
