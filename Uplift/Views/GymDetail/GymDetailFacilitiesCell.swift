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
    private var collectionView: UICollectionView!
    private var facilityDropdowns: [FacilityDropdown] = []
    private var reloadGymDetailCollectionViewClosure: ((Int?, [[Int: Int]]) -> Void)?
    private var calendarSelectedIndices: [[Int: Int]] = []

    override init(frame: CGRect) {
        super.init(frame: frame)

        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.minimumLineSpacing = 0

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)

        backgroundColor = .white
        isUserInteractionEnabled = true

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(FacilitiesDropdownCell.self, forCellWithReuseIdentifier: Identifiers.facilitiesDropdownCell)
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = .white
        contentView.addSubview(collectionView)

        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(for facilityDropdowns: [FacilityDropdown],
                   calendarSelectedIndices: [[Int: Int]],
                   reloadGymDetailCollectionViewClosure: @escaping ((Int?, [[Int: Int]]) -> Void)) {
        self.facilityDropdowns = facilityDropdowns
        self.calendarSelectedIndices = calendarSelectedIndices
        self.reloadGymDetailCollectionViewClosure = reloadGymDetailCollectionViewClosure

        while self.calendarSelectedIndices.count < self.facilityDropdowns.count {
            self.calendarSelectedIndices.append([:])
        }

        collectionView.reloadData()
    }

    static func getHeights(for facilityDropdowns: [FacilityDropdown], calendarSelectedIndices: [[Int: Int]]) -> CGFloat {
        var height: CGFloat = 0
        facilityDropdowns.enumerated().forEach { index, facilityDropdown in
            let facility = facilityDropdown.facility
            let dropdownStatus = facilityDropdown.dropdownStatus
            if dropdownStatus == .open {
                height += FacilitiesDropdownCell.getFacilityHeight(for: facility, calendarSelectedIndices: calendarSelectedIndices[index])
            } else {
                height += FacilitiesDropdownCell.headerViewHeight
            }
        }
        return height
    }
}

extension GymDetailFacilitiesCell: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let facility = facilityDropdowns[indexPath.row].facility
        let dropdownStatus = facilityDropdowns[indexPath.row].dropdownStatus
        let height = dropdownStatus == .open
            ? FacilitiesDropdownCell.getFacilityHeight(for: facility, calendarSelectedIndices: calendarSelectedIndices[indexPath.row])
            : FacilitiesDropdownCell.headerViewHeight
        return CGSize(width: collectionView.bounds.width, height: height)
    }

}

extension GymDetailFacilitiesCell: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return facilityDropdowns.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //swiftlint:disable:next force_cast
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.facilitiesDropdownCell, for: indexPath) as! FacilitiesDropdownCell
        let facility = facilityDropdowns[indexPath.row].facility
        let dropdownStatus = facilityDropdowns[indexPath.row].dropdownStatus
        let reloadFacilitiesCellClosure: (Int?, [Int: Int]) -> Void = { index, calendarIndices in
            self.calendarSelectedIndices[indexPath.row] = calendarIndices
            self.reloadGymDetailCollectionViewClosure?(index, self.calendarSelectedIndices)
        }
        cell.configure(for: facility,
                       index: indexPath.row,
                       dropdownStatus: dropdownStatus,
                       calendarSelectedIndices: calendarSelectedIndices[indexPath.row],
                       headerViewTapped: reloadFacilitiesCellClosure)
        cell.isUserInteractionEnabled = true
        return cell
    }

}
