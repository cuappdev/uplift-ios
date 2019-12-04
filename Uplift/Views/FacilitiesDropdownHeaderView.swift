//
//  FacilitiesDropdownHeaderView.swift
//  Alamofire
//
//  Created by Cameron Hamidi on 11/26/19.
//

import UIKit

class FacilitiesDropdownHeaderView: DropdownHeaderView {

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

    init(frame: CGRect) {
        super.init(frame: frame, arrowImage: UIImage(named: ImageNames.rightArrowSolid))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(for facility: Facility) {
        var headerImage: UIImage?
        switch facility.facilityType {
        case .fitnessCenter:
            headerImage = UIImage(named: ImageNames.equipment)
        case .gymnasium:
            headerImage = UIImage(named: ImageNames.basketball)
        case .pool:
            headerImage = UIImage(named: ImageNames.pool)
        case .bowling:
            headerImage = UIImage(named: ImageNames.bowling)
        default:
            headerImage = UIImage(named: ImageNames.misc)
        }

        headerImageView.image = headerImage
        addSubview(headerImageView)

        headerNameLabel.text = facility.facilityType.rawValue
        headerNameLabel.font = ._16MontserratRegular
        headerNameLabel.textColor = .black
        headerNameLabel.textAlignment = .left
        addSubview(headerNameLabel)

        headerOpenLabel.font = ._16MontserratRegular
        headerOpenLabel.textAlignment = .center
        addSubview(headerOpenLabel)

        if let isFacilityOpen = getIsFacilityOpen(for: facility) {
            headerOpenLabel.text = isFacilityOpen ? ClientStrings.CommonStrings.open : ClientStrings.CommonStrings.closed
            headerOpenLabel.textColor = isFacilityOpen ? .accentOpen : .accentClosed
        }

        setupConstraints()
    }

    func getIsFacilityOpen(for facility: Facility) -> Bool? {
        let todaysDate = Date()
        let dayOfWeek = todaysDate.getIntegerDayOfWeekToday()
        for detail in facility.details where !detail.times.isEmpty {
            for time in detail.times {
                if time.dayOfWeek == dayOfWeek {
                    for timeRange in time.timeRanges {
                        if todaysDate > timeRange.openTime && todaysDate < timeRange.closeTime {
                            return true
                        } else {
                            return false
                        }
                    }
                }
            }
        }
        return nil
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
