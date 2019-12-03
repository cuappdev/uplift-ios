//
//  FacilitiesDropdownCollectionViewCell.swift
//  
//
//  Created by Cameron Hamidi on 11/6/19.
//

import UIKit

class FacilitiesDropdownCell: UICollectionViewCell {

    private let headerView = FacilitiesDropdownHeaderView(frame: .zero)
    private var collectionView: UICollectionView!
    private var dropdownView: DropdownView!
    private var facility: Facility!
    static let headerViewHeight: CGFloat = 52
    static let collectionViewSpacing: CGFloat = 16
    private var facilitiesIndex: Int!
    private var headerViewTapped: ((Int) -> ())?
    private let separatorView = UIView()
    private let separatorHeight: CGFloat = 1
    private let separatorSideOffset: CGFloat = 24
    static let dropdownViewBottomOffset: CGFloat = -12

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
        collectionView.register(EquipmentListCell.self, forCellWithReuseIdentifier: Identifiers.facilityEquipmentListCell)
        collectionView.register(FacilitiesHoursCell.self, forCellWithReuseIdentifier: Identifiers.facilityHoursCell)
        collectionView.register(PriceInformationCell.self, forCellWithReuseIdentifier: Identifiers.facilitiesPriceInformationCell)
        collectionView.register(MiscellaneousInfoCell.self, forCellWithReuseIdentifier: Identifiers.facilitiesMiscellaneousCell)

        headerView.delegate = self

        dropdownView = DropdownView(delegate: self,
                                    headerView: headerView,
                                    headerViewHeight: FacilitiesDropdownCell.headerViewHeight,
                                    contentView: collectionView,
                                    contentViewHeight: 0)
        dropdownView.backgroundColor = .white
        dropdownView.layer.masksToBounds = false
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
            make.leading.equalToSuperview().offset(separatorSideOffset)
            make.trailing.equalToSuperview().offset(-separatorSideOffset)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(for facility: Facility, index: Int, dropdownStatus: DropdownStatus, headerViewTapped: @escaping (Int) -> ()) {
        setNeedsUpdateConstraints()
        self.facility = facility
        self.facilitiesIndex = index
        self.headerViewTapped = headerViewTapped
        dropdownView.updateContentViewHeight(to: FacilitiesDropdownCell.getFacilityHeight(for: facility) - FacilitiesDropdownCell.headerViewHeight)
        headerView.configure(for: facility)
        if dropdownStatus == .open {
            dropdownView.openDropdown()
            headerView.rotateArrowDown()
        } else {
            dropdownView.closeDropdown()
            headerView.rotateArrowUp()
        }
        self.dropdownView.layoutIfNeeded()
        collectionView.reloadData()
    }

    static func getHeight(for facilityDetail: FacilityDetail) -> CGFloat {
        var height: CGFloat = 0
        switch facilityDetail.detailType {
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
        facility.details.forEach { facilityDetail in
            height += FacilitiesDropdownCell.getHeight(for: facilityDetail) + collectionViewSpacing
        }
        return height + -FacilitiesDropdownCell.dropdownViewBottomOffset
    }

}

extension FacilitiesDropdownCell: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return facility.details.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch facility.details[indexPath.row].detailType {
        case .equipment:
            //swiftlint:disable:next force_cast
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.facilityEquipmentListCell, for: indexPath) as! EquipmentListCell
            cell.configure(for: facility.details[indexPath.row].getEquipmentCategories())
            return cell
        case .hours:
            //swiftlint:disable:next force_cast
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.facilityHoursCell, for: indexPath) as! FacilitiesHoursCell
            cell.configure(facilityDetail: facility.details[indexPath.row], dayIndex: 0, onChangeDay: nil)
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

    func dropdownViewClosed(sender dropdownView: DropdownView) {}

    func dropdownViewOpen(sender dropdownView: DropdownView) {}

    func dropdownViewHalf(sender dropdownView: DropdownView) {}

}

extension FacilitiesDropdownCell: DropdownHeaderViewDelegate {

    func didTapHeaderView() {
        headerViewTapped?(facilitiesIndex)
    }

}
