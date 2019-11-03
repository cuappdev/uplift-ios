//
//  GymDetailCalendarView.swift
//  Uplift
//
//  Created by Phillip OReggio on 10/23/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import UIKit

class GymDetailCalendarView: UIView {

    private let facilityDetail: FacilityDetail

    private let weekView = GymDetailWeekView()
    private let timeInfoView: GymDetailTimeInfoView
    private let stackView = UIStackView()

    init(facilityDetail: FacilityDetail) {
        self.facilityDetail = facilityDetail
        timeInfoView = GymDetailTimeInfoView(facilityDetail: facilityDetail)

        super.init(frame: .zero)
        backgroundColor = .primaryWhite

        setupStack()
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupStack() {
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.axis = .vertical
        addSubview(stackView)
    }

    private func setupViews() {
        let timesPadding: CGFloat = 16

        weekView.delegate = timeInfoView

        stackView.addArrangedSubview(weekView)
        stackView.setCustomSpacing(timesPadding, after: weekView)
        stackView.addArrangedSubview(timeInfoView)
    }

    private func setupConstraints() {
        let headerHeight = 24

        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        weekView.snp.makeConstraints { make in
            make.height.equalTo(headerHeight)
        }
    }
}
