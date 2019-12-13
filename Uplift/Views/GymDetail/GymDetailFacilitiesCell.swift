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

    // MARK: - Private view vars
    private var collectionView: UICollectionView!
    private var facilitiesLabel = UILabel()
    private var facilityDropdowns: [FacilityDropdown] = []
    private var reloadGymDetailCollectionViewClosure: ((Int?) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
        setupConstraints()
    }

    func configure(for facilityDropdowns: [FacilityDropdown],
                   reloadGymDetailCollectionViewClosure: @escaping ((Int?) -> Void)) {
        self.facilityDropdowns = facilityDropdowns
        self.reloadGymDetailCollectionViewClosure = reloadGymDetailCollectionViewClosure

        collectionView.reloadData()
    }

    private func setupViews() {
        facilitiesLabel.text = ClientStrings.GymDetail.facilitiesSection
        facilitiesLabel.font = ._16MontserratBold
        facilitiesLabel.textColor = .primaryBlack
        facilitiesLabel.textAlignment = .center
        contentView.addSubview(facilitiesLabel)

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
    }

    private func setupConstraints() {
        facilitiesLabel.snp.makeConstraints { make in
           make.centerX.equalToSuperview()
           make.top.equalToSuperview().offset(Constraints.verticalPadding)
           make.height.equalTo(Constraints.titleLabelHeight)
       }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(facilitiesLabel.snp.bottom).offset(Constraints.verticalPadding)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }

    static func getHeights(for facilityDropdowns: [FacilityDropdown]) -> CGFloat {
        var height: CGFloat = 0
        facilityDropdowns.forEach { facilityDropdown in
            let facility = facilityDropdown.facility
            let dropdownStatus = facilityDropdown.dropdownStatus
            if dropdownStatus == .open {
                height += FacilitiesDropdownCell.getFacilityHeight(for: facility)
            } else {
                height += FacilitiesDropdownCell.headerViewHeight
            }
        }
        return height
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GymDetailFacilitiesCell: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let facility = facilityDropdowns[indexPath.row].facility
        let dropdownStatus = facilityDropdowns[indexPath.row].dropdownStatus
        let height = dropdownStatus == .open
            ? FacilitiesDropdownCell.getFacilityHeight(for: facility)
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
        cell.configure(for: facilityDropdowns[indexPath.row],
                       index: indexPath.row,
                       headerViewTapped: reloadGymDetailCollectionViewClosure)
        cell.isUserInteractionEnabled = true
        return cell
    }

}
