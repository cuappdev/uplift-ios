//
//  CourtView.swift
//  Uplift
//
//  Created by Phillip OReggio on 11/3/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import UIKit

class CourtView: UICollectionViewCell {

    // MARK: Gym
    private var facilityDetail: FacilityDetail!
    private var dailyGymHours: [DailyGymHours]!
    private var selectedDayIndex = 0

    // MARK: CollectionView
    private let courtsCollectionView: UICollectionView
    private var displayedHours: [FacilityHoursRange] = []
    private let collectionViewIdentifier = "court"

    // MARK: Display
    private static let courtSize = CGSize(width: 124, height: 192)

    override init(frame: CGRect) {
        let flowLayout = UICollectionViewFlowLayout()
        let spacing: CGFloat = -1 // Overlap Center Court Line
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = 10000
        flowLayout.minimumLineSpacing = spacing
        flowLayout.itemSize = CourtView.courtSize

        courtsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        courtsCollectionView.backgroundColor = .primaryWhite
        courtsCollectionView.isUserInteractionEnabled = false
        courtsCollectionView.allowsSelection = false
        courtsCollectionView.isScrollEnabled = false
        courtsCollectionView.register(CourtCell.self, forCellWithReuseIdentifier: collectionViewIdentifier)

        super.init(frame: frame)
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

    override func layoutSubviews() {
        centerCollectionView()
    }

    private func update(day: Int) {
        selectedDayIndex = day
        let hours = facilityDetail.times.filter { $0.dayOfWeek == selectedDayIndex }
        // Restrictions describe court
        displayedHours = hours.flatMap { $0.timeRanges }.filter { !$0.restrictions.isEmpty }

        centerCollectionView()
        courtsCollectionView.reloadData()
    }

    // MARK: - Helper
    /// Creates insets so collection view displays its contents in the center
    private func centerCollectionView() {
        let numElem = CGFloat(displayedHours.count)
        let inset = (frame.width - (CourtView.courtSize.width * numElem)) / 2
        courtsCollectionView.contentInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
    }

    // MARK: - Collection View Related
    func configure(facility: FacilityDetail, gymHours: [DailyGymHours]) {
        facilityDetail = facility
        dailyGymHours = gymHours
        update(day: selectedDayIndex)
    }

    static func getHeight() -> CGFloat {
        return courtSize.height
    }

}

// MARK: - UICOllectionViewDataSource
extension CourtView: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return displayedHours.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewIdentifier, for: indexPath) as? CourtCell else { return UICollectionViewCell() }
        cell.configure(
            facilityHours: displayedHours[indexPath.row],
            dailyGymHours: dailyGymHours.filter { $0.dayOfWeek == selectedDayIndex }
        )
        return cell
    }

}

// MARK: - Delegation
extension CourtView: WeekDelegate {

    func didChangeDay(day: WeekDay) {
        update(day: day.index - 1)
    }

}
