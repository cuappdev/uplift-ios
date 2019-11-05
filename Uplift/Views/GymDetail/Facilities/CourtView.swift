//
//  CourtView.swift
//  Uplift
//
//  Created by Phillip OReggio on 11/3/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import UIKit

class CourtView: UIView {

    // MARK: Gym
    private let facilityDetail: FacilityDetail
    private let dailyGymHours: [DailyGymHours]
    private var selectedDayIndex = 0

    // MARK: CollectionView
    private let courtsCollectionView: UICollectionView
    private var displayedHours: [FacilityHoursRange] = []
    private let reuseIdentifier = "court"

    init(facility: FacilityDetail, gymHours: [DailyGymHours]) {
        facilityDetail = facility
        dailyGymHours = gymHours

        print("\n---Init with: ----------------------")
        print("facilityDeyail times: \(facilityDetail.times)")
        print("dailyGym: \(dailyGymHours)")
        print("------------------------------------\n")

        let flowLayout = UICollectionViewFlowLayout()
        let courtSize = CGSize(width: 124, height: 192)
        let spacing: CGFloat = 0
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = spacing
        flowLayout.itemSize = courtSize

        courtsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        courtsCollectionView.backgroundColor = .primaryWhite
        courtsCollectionView.isUserInteractionEnabled = false
        courtsCollectionView.allowsSelection = false
        courtsCollectionView.isScrollEnabled = false
        courtsCollectionView.register(CourtCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        super.init(frame: .zero)
        backgroundColor = .primaryWhite
        courtsCollectionView.dataSource = self
        addSubview(courtsCollectionView)

        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        courtsCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func update(day: Int) {
        selectedDayIndex = day
        let hours = facilityDetail.times.filter { $0.dayOfWeek == selectedDayIndex }
        // Restrictions describe court
        displayedHours = hours.flatMap { $0.timeRanges }.filter { !$0.restrictions.isEmpty }

        print("\n---Updating: -----------------------")
        print("selectedDay: \(selectedDayIndex)")
        print("dislpayedHours: \(displayedHours)")
        print("------------------------------------\n")

        courtsCollectionView.reloadData()
    }

}

// MARK: - UICOllectionViewDataSource
extension CourtView: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return displayedHours.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? CourtCell else { return UICollectionViewCell() }
        cell.configure(
            facilityHours: displayedHours[indexPath.row],
            dailyGymHours: dailyGymHours.filter { $0.dayOfWeek == selectedDayIndex }
        )
        return cell
    }

}

// Delegation
extension CourtView: WeekDelegate {
    func didChangeDay(day: WeekDay) {
        update(day: day.index - 1)
    }
}
