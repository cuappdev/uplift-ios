//
//  GymDetailCalendarView.swift
//  Uplift
//
//  Created by Phillip OReggio on 10/23/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import UIKit

class FacilitiesHoursCell: UICollectionViewCell {

    // MARK: - Public data vars
    static var baseHeight: CGFloat {
        return Constraints.headerHeight
    }

    // MARK: - Private view vars
    private let weekView = GymDetailWeekView()
    private let stackView = UIStackView()
    private let timeInfoView = GymDetailTimeInfoView()

    private enum Constraints {
        static let headerHeight: CGFloat = 24
        static let timesPadding: CGFloat = 16
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .primaryWhite
        setupViews()
        setupConstraints()
    }

    func configure(facilityDetail: FacilityDetail, dayIndex: Int, onChangeDay: ((Int) -> ())?) {
        weekView.configure(for: dayIndex)
        timeInfoView.configure(facilityDetail: facilityDetail, dayIndex: dayIndex, onChangeDay: onChangeDay)
    }

    static func getHeight(for facilityDetail: FacilityDetail, dayIndex: Int) -> CGFloat {
        return baseHeight + GymDetailTimeInfoView.getTimesHeight(for: facilityDetail.times[dayIndex])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        weekView.updateDayClosure = { day in
            self.timeInfoView.didChangeDay(day: day)
        }

        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.axis = .vertical
        contentView.addSubview(stackView)

        stackView.addArrangedSubview(weekView)
        stackView.setCustomSpacing(Constraints.timesPadding, after: weekView)
        stackView.addArrangedSubview(timeInfoView)
    }

    private func setupConstraints() {
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        weekView.snp.makeConstraints { make in
            make.height.equalTo(Constraints.headerHeight)
        }
    }

}
