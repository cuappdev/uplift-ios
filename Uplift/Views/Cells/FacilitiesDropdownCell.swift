//
//  FacilitiesDropdownCollectionViewCell.swift
//  Uplift
//
//  Created by Cameron Hamidi on 11/6/19.
//  Copyright © 2019 Uplift. All rights reserved.
//

import UIKit

class FacilitiesDropdownCell: UICollectionViewCell {

    static let collectionViewSpacing: CGFloat = 16
    static let dropdownViewBottomOffset: CGFloat = -12
    static let headerViewHeight: CGFloat = 52

    private let headerView = FacilitiesDropdownHeaderView(frame: .zero)
    private var collectionView: UICollectionView!
    private var dropdownView: DropdownView!
    private var facility: Facility!
    private var facilitiesIndex: Int!
    private var headerViewTapped: ((Int?) -> Void)?
    private let separatorView = UIView()
    private let separatorHeight: CGFloat = 1
    private let separatorSideOffset: CGFloat = 24

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.backgroundColor = .white

        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.minimumInteritemSpacing = FacilitiesDropdownCell.collectionViewSpacing

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = .white
        collectionView.register(GymnasiumCollectionViewCell.self, forCellWithReuseIdentifier: Identifiers.facilityGymnasiumCell)
        collectionView.register(EquipmentListCell.self, forCellWithReuseIdentifier: Identifiers.facilityEquipmentListCell)
        collectionView.register(FacilitiesHoursCell.self, forCellWithReuseIdentifier: Identifiers.facilityHoursCell)
        collectionView.register(PriceInformationCell.self, forCellWithReuseIdentifier: Identifiers.facilitiesPriceInformationCell)
        collectionView.register(MiscellaneousInfoCell.self, forCellWithReuseIdentifier: Identifiers.facilitiesMiscellaneousCell)

        headerView.delegate = self

        dropdownView = DropdownView(headerView: headerView,
                                    headerViewHeight: FacilitiesDropdownCell.headerViewHeight,
                                    contentView: collectionView,
                                    contentViewHeight: 0)
        dropdownView.backgroundColor = .white
        dropdownView.layer.masksToBounds = false
        dropdownView.delegate = self
        contentView.addSubview(dropdownView)

        separatorView.backgroundColor = .gray01
        contentView.addSubview(separatorView)

        dropdownView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(FacilitiesDropdownCell.dropdownViewBottomOffset)
        }

        separatorView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.height.equalTo(separatorHeight)
            make.leading.trailing.equalToSuperview().inset(separatorSideOffset)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(for facilityDropdown: FacilityDropdown,
                   index: Int,
                   headerViewTapped: ((Int?) -> Void)?) {
        self.facility = facilityDropdown.facility
        self.facilitiesIndex = index
        self.headerViewTapped = headerViewTapped

        collectionView.reloadData()

        let contentViewHeight = FacilitiesDropdownCell.getFacilityHeight(for: facility) - FacilitiesDropdownCell.headerViewHeight
        dropdownView.updateContentViewHeight(to: contentViewHeight)
        headerView.configure(for: facility)

        let dropdownStatus = facilityDropdown.dropdownStatus
        if dropdownStatus == .open {
            dropdownView.openDropdown()
            headerView.rotateArrowDown()
        } else {
            dropdownView.closeDropdown()
            headerView.rotateArrowUp()
        }
    }

    static func getHeight(for facilityDetail: FacilityDetail) -> CGFloat {
        var height: CGFloat = 0
        switch facilityDetail.detailType {
        case .court:
            height = GymnasiumCollectionViewCell.getHeight()
        case .equipment:
            height = EquipmentListCell.getHeight(models: facilityDetail.getEquipmentCategories())
        case .hours:
            height = FacilitiesHoursCell.getHeight(for: facilityDetail)
        case .prices:
            height = PriceInformationCell.getHeight(for: facilityDetail.items)
        case .subfacilities:
            height = MiscellaneousInfoCell.getHeight(for: facilityDetail.subfacilities)
        }
        return height
    }

    static func getFacilityHeight(for facility: Facility) -> CGFloat {
        var height: CGFloat = headerViewHeight
        for i in 0..<facility.details.count {
            let facilityDetail = facility.details[i]
            height += FacilitiesDropdownCell.getHeight(for: facilityDetail) + collectionViewSpacing
        }
        return height - FacilitiesDropdownCell.dropdownViewBottomOffset
    }

}

extension FacilitiesDropdownCell: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return facility.details.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let facilityDetail = facility.details[indexPath.row]
        let detailType = facilityDetail.detailType

        // Get selected day index
        var selectedDayIndex = 0
        if let selectedHoursRanges = facilityDetail.times.first(where: { $0.isSelected }) {
            selectedDayIndex = selectedHoursRanges.dayOfWeek
        }

        switch detailType {
        case .court:
            // swiftlint:disable:next force_cast
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.facilityGymnasiumCell, for: indexPath) as! GymnasiumCollectionViewCell
            if let hoursFacilityDetail = facility.details.first(where: { $0.detailType == .hours }),
                let facilityHoursRanges = hoursFacilityDetail.times.first(where: { $0.dayOfWeek == selectedDayIndex }),
                let courtHoursRanges = facilityDetail.times.first(where: { $0.dayOfWeek == selectedDayIndex }) {
                cell.configure(
                    courtsHoursRanges: courtHoursRanges.timeRanges,
                    facilityHoursRanges: facilityHoursRanges.timeRanges
                )
            }
            return cell
        case .equipment:
            // swiftlint:disable:next force_cast
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.facilityEquipmentListCell, for: indexPath) as! EquipmentListCell
            cell.configure(for: facility.details[indexPath.row].getEquipmentCategories())
            return cell
        case .hours:
            let onChangeDay: (Int) -> Void = { newDayIndex in
                // Update all facility details with the new selected day index
                self.facility.details.forEach { facilityDetail in
                    facilityDetail.times.forEach { dailyHoursRanges in
                        dailyHoursRanges.isSelected = dailyHoursRanges.dayOfWeek == newDayIndex
                    }
                }
                self.headerViewTapped?(nil)
            }
            //swiftlint:disable:next force_cast
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.facilityHoursCell, for: indexPath) as! FacilitiesHoursCell
            cell.configure(facilityDetail: facilityDetail, dayIndex: selectedDayIndex, onChangeDay: onChangeDay)
            return cell
        case .prices:
            //swiftlint:disable:next force_cast
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.facilitiesPriceInformationCell, for: indexPath) as! PriceInformationCell
            cell.configure(items: facility.details[indexPath.row].items, prices: facility.details[indexPath.row].prices)
            return cell
        case .subfacilities:
            //swiftlint:disable:next force_cast
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.facilitiesMiscellaneousCell, for: indexPath) as! MiscellaneousInfoCell
            cell.configure(for: facility.details[indexPath.row].subfacilities)
            return cell
        }

    }

}

extension FacilitiesDropdownCell: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let height = FacilitiesDropdownCell.getHeight(for: facility.details[indexPath.row])
        return CGSize(width: width, height: height + FacilitiesDropdownCell.collectionViewSpacing)
    }

}

extension FacilitiesDropdownCell: DropdownViewDelegate {

    func dropdownStatusChanged(to status: DropdownStatus, with height: CGFloat) {}

}

extension FacilitiesDropdownCell: DropdownHeaderViewDelegate {

    func didTapHeaderView() {
        headerViewTapped?(facilitiesIndex)
    }

}
