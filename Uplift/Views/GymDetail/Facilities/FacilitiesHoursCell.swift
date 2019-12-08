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

    func configure(facilityDetail: FacilityDetail, dayIndex: Int, onChangeDay: ((Int) -> Void)?) {
        weekView.configure(for: dayIndex, onChangeDay: onChangeDay)
        timeInfoView.configure(facilityDetail: facilityDetail, dayIndex: dayIndex)
    }

    static func getHeight(for facilityDetail: FacilityDetail) -> CGFloat {
        guard let selectedHoursRanges = facilityDetail.times.first(where: { $0.isSelected }) else { return 0}
        return baseHeight + GymDetailTimeInfoView.getTimesHeight(for: selectedHoursRanges)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
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
