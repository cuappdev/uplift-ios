//
//  GymDetailCalendarView.swift
//  Uplift
//
//  Created by Phillip OReggio on 10/23/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import UIKit

class GymDetailCalendarView: UICollectionViewCell {

    private var facilityDetail: FacilityDetail!

    private let weekView = GymDetailWeekView()
    private var timeInfoView: GymDetailTimeInfoView!
    private let stackView = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: .zero)

        setupStack()
//        setupViews()
        setupConstraints()
    }

    func configure(facilityDetail: FacilityDetail) {
        self.facilityDetail = facilityDetail
        timeInfoView = GymDetailTimeInfoView(facilityDetail: facilityDetail)
        weekView.delegate = timeInfoView

        addViewsToStackView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupStack() {
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.axis = .vertical
        contentView.addSubview(stackView)
    }

    private func addViewsToStackView() {
        let timesPadding: CGFloat = 16

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
