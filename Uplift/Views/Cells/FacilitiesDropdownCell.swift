//
//  FacilitiesDropdownCollectionViewCell.swift
//  
//
//  Created by Cameron Hamidi on 11/6/19.
//

import UIKit

class FacilitiesDropdownCell: UICollectionViewCell {

    private enum FacilityName: String {
        case bowlingLanes = "BOWLING LANES"
        case equipment = "EQUIPMENT"
        case fitnessCenter = "FITNESS CENTER"
        case gymnasium = "GYMNASIUM"
        case swimmingPool = "SWIMMING POOL"
    }

    private let headerImageView = UIImageView()
    private let headerNameLabel = UILabel()
    private let headerOpenLabel = UILabel()
    private let headerView = DropdownHeaderView(frame: .zero, arrowImage: nil, arrowImageTrailingOffset: 0)

    private var collectionView: UICollectionView!
    private var collectionViewHeight: CGFloat = 0
    private var dropdownView: DropdownView!
    private var facility: Facility!
    private var height: CGFloat = 0

    override init(frame: CGRect) {
        super.init(frame: frame)

        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.minimumInteritemSpacing = 16

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.delegate = self
        collectionView.dataSource = self

        setupDropdownView()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(for facility: Facility) {
        self.facility = facility
        collectionView.reloadData()
    }

    func setupDropdownView() {
        let headerViewHeight: CGFloat = 52
        setupHeaderView(headerString: facility.name)

        // TODO: register facility cell classes once they're finished

        collectionViewHeight = 0 // TODO: once cell classes are finished, sum up their heights to get the total collection view height

        dropdownView = DropdownView(delegate: self,
                                    headerView: headerView,
                                    headerViewHeight: headerViewHeight,
                                    contentView: collectionView,
                                    contentViewHeight: collectionViewHeight)
    }

    func setupHeaderView(headerString: String) {
        var headerImage: UIImage?
        switch FacilityName(rawValue: headerString.uppercased()) {
        case .equipment, .fitnessCenter:
            headerImage = UIImage(named: ImageNames.equipment)
        case .gymnasium:
            headerImage = UIImage(named: ImageNames.basketball)
        case .swimmingPool:
            headerImage = UIImage(named: ImageNames.pool)
        case .bowlingLanes:
            headerImage = UIImage(named: ImageNames.bowling)
        default:
            headerImage = UIImage(named: ImageNames.misc)
        }

        headerImageView.image = headerImage
        headerView.addSubview(headerImageView)

        headerNameLabel.text = headerString
        headerNameLabel.font = ._16MontserratRegular
        headerNameLabel.textColor = .black
        headerNameLabel.textAlignment = .left
        headerView.addSubview(headerImageView)

        let isFacilityOpen = getIsFacilityOpen()
        headerOpenLabel.font = ._16MontserratRegular
        headerOpenLabel.text = isFacilityOpen ? ClientStrings.CommonStrings.open : ClientStrings.CommonStrings.closed
        headerOpenLabel.textColor = isFacilityOpen ? .accentOpen : .accentClosed
        headerOpenLabel.textAlignment = .center
        headerView.addSubview(headerOpenLabel)
    }

    func getIsFacilityOpen() -> Bool {
        let todaysDate = Date()
        let dayOfWeek = todaysDate.getIntegerDayOfWeekToday()
        for detail in facility.details {
            if !detail.times.isEmpty {
                for time in detail.times {
                    if time.dayOfWeek == dayOfWeek {
                        for timeRange in time.timeRanges {
                            if todaysDate > timeRange.openTime && todaysDate < timeRange.closeTime {
                                return true
                            }
                        }
                    }
                }
            }
        }
        return false
    }

    func setupConstraints() {
        let headerImageViewSize: CGFloat = 24
        let headerImageViewLeadingOffset: CGFloat = 25
        let headerImageViewNameLabelSpacing: CGFloat = 9
        let openLabelTrailingOffset: CGFloat = -45

        headerImageView.snp.makeConstraints { make in
            make.height.width.equalTo(headerImageViewSize)
            make.leading.equalToSuperview().offset(headerImageViewLeadingOffset)
            make.centerY.equalToSuperview()
        }

        headerNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(headerImageView.snp.trailing).offset(headerImageViewNameLabelSpacing)
            make.trailing.equalTo(headerOpenLabel.snp.leading).inset(headerImageViewNameLabelSpacing)
            make.centerY.equalToSuperview()
        }

        headerOpenLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(openLabelTrailingOffset)
        }
    }

}

extension FacilitiesDropdownCell: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return facility.details.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // TODO: once facility cells are finished
        return UICollectionViewCell(frame: .zero)
    }

}

extension FacilitiesDropdownCell: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // TODO: once facility cells are finished
        return .zero
    }

}

extension FacilitiesDropdownCell: DropdownViewDelegate {

    func dropdownViewClosed(sender dropdownView: DropdownView) {
        // TODO: Implement
    }

    func dropdownViewOpen(sender dropdownView: DropdownView) {
        // TODO: Implement
    }

    func dropdownViewHalf(sender dropdownView: DropdownView) {
        // TODO: Implement
    }

}
