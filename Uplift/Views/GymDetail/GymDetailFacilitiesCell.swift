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
    private var reloadGymDetailCollectionViewClosure: ((Int) -> ())?
    private var dropdownCellStatuses: [DropdownStatus] = []

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
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(for facilities: [Facility], dropdownStatuses: [DropdownStatus], reloadGymDetailCollectionViewClosure: @escaping ((Int) -> ())) {
        setNeedsUpdateConstraints()
        self.facilities = facilities
        self.dropdownCellStatuses = dropdownStatuses
        self.reloadGymDetailCollectionViewClosure = reloadGymDetailCollectionViewClosure
        collectionView.reloadData()
    }

    override func updateConstraints() {
        super.updateConstraints()
        collectionView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
    }

    static func getHeights(for facilities: [Facility], dropdownCellStatuses: [DropdownStatus]?) -> CGFloat {
        var height: CGFloat = 0
        for i in 0..<facilities.count {
            if dropdownCellStatuses?[i] == .open {
                height += FacilitiesDropdownCell.getHeights(for: facilities[i])
            } else {
                height += FacilitiesDropdownCell.headerViewHeight
            }
        }
        return height
    }
}

extension GymDetailFacilitiesCell: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = dropdownCellStatuses[indexPath.row] == .open ? FacilitiesDropdownCell.getHeights(for: facilities[indexPath.row]) : FacilitiesDropdownCell.headerViewHeight
        return CGSize(width: collectionView.bounds.width, height: height)
    }

}

extension GymDetailFacilitiesCell: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return facilities.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //swiftlint:disable:next force_cast
        let reloadFacilitiesCellClosure: (Int) -> () = { index in
            self.reloadGymDetailCollectionViewClosure?(index)
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.facilitiesDropdownCell, for: indexPath) as! FacilitiesDropdownCell
        cell.configure(for: facilities[indexPath.row], index: indexPath.row, dropdownStatus: dropdownCellStatuses[indexPath.row], headerViewTapped: reloadFacilitiesCellClosure)
        cell.isUserInteractionEnabled = true
        return cell
    }

}
