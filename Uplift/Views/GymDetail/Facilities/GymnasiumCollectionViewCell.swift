//
//  GymnasiumCollectionViewCell.swift
//  Uplift
//
//  Created by Phillip OReggio on 11/3/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import UIKit

class GymnasiumCollectionViewCell: UICollectionViewCell {

    // MARK: - Private data vars
    private var facilityDetail: FacilityDetail!
    private var dailyGymHours: [OpenHours] = []
    private var selectedDayIndex = 0

    // MARK: Private view vars
    private let courtsCollectionView: UICollectionView
    private var facilityHoursRanges: [FacilityHoursRange] = []
    private var courtsHoursRanges: [FacilityHoursRange] = []

    // MARK: Display
    private let courtSize = CGSize(width: 124, height: 192)

    override init(frame: CGRect) {
        let flowLayout = UICollectionViewFlowLayout()
        courtsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        super.init(frame: frame)

        backgroundColor = .primaryWhite

        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = -1 // Overlap Center Court Line
        flowLayout.itemSize = courtSize

        courtsCollectionView.backgroundColor = .primaryWhite
        courtsCollectionView.isUserInteractionEnabled = false
        courtsCollectionView.allowsSelection = false
        courtsCollectionView.isScrollEnabled = false
        courtsCollectionView.register(CourtCollectionViewCell.self, forCellWithReuseIdentifier: Identifiers.courtCollectionViewCell)
        courtsCollectionView.dataSource = self
        contentView.addSubview(courtsCollectionView)

        courtsCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    // MARK: - Helper
    /// Creates insets so collection view displays its contents in the center
    private func centerCollectionView(for numCourts: Int) {
        let inset = (frame.width - (courtSize.width * CGFloat(numCourts))) / 2
        courtsCollectionView.contentInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
    }

    func configure(
        courtsHoursRanges: [FacilityHoursRange],
        facilityHoursRanges: [FacilityHoursRange]
    ) {
        self.courtsHoursRanges = courtsHoursRanges
        self.facilityHoursRanges = facilityHoursRanges
        centerCollectionView(for: courtsHoursRanges.count)
        courtsCollectionView.reloadData()
    }

    static func getHeight() -> CGFloat {
        return 192 // Same as courtSize height
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - UICollectionViewDataSource
extension GymnasiumCollectionViewCell: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return courtsHoursRanges.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.courtCollectionViewCell, for: indexPath) as? CourtCollectionViewCell else { return UICollectionViewCell() }
        let courtHoursRange = courtsHoursRanges[indexPath.row]
        cell.configure(
            courtsHoursRange: courtHoursRange,
            facilityHoursRanges: facilityHoursRanges,
            courtIndex: indexPath.row
        )
        return cell
    }

}
