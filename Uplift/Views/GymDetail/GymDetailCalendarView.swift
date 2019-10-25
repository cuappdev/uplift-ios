//
//  GymDetailCalendarView.swift
//  Uplift
//
//  Created by Phillip OReggio on 10/23/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import UIKit

class GymDetailCalendarView: UIView {

    private let facility: Facility
    private var weekView: GymDetailWeekView!
    private var timeInfoView: GymDetailTimeInfoView!

    init(facility: Facility) {
        self.facility = facility
        super.init(frame: CGRect())

        setupViews()
        setupConstaints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        weekView = GymDetailWeekView()
        addSubview(weekView)
        timeInfoView = GymDetailTimeInfoView(facility: facility)
        addSubview(timeInfoView)
        weekView.delegate = timeInfoView
    }

    private func setupConstaints() {
        let headerHeight = 30
        let timesPadding = 16

        weekView.snp.makeConstraints { make in
            make.height.equalTo(headerHeight)
            make.leading.trailing.equalToSuperview()
        }

        timeInfoView.snp.makeConstraints { make in
            make.top.equalTo(weekView.snp.bottom).offset(timesPadding)
            make.leading.trailing.equalToSuperview()
        }
    }
}
