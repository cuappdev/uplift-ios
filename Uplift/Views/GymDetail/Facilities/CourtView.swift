//
//  CourtView.swift
//  Uplift
//
//  Created by Phillip OReggio on 11/3/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import UIKit

class CourtView: UIView {

    private let facilityDetail: FacilityDetail
    private let dailyGymHours: [DailyGymHours]

    private var selectedDayIndex = 0
    private var displayedHours: [FacilityHoursRange] = []

    private let courtsCollectionView = UICollectionView()
    private let reuseIdentifier = "court"

    init(facility: FacilityDetail, gymHours: [DailyGymHours]) {
        facilityDetail = facility
        dailyGymHours = gymHours
        super.init(frame: .zero)

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0

        courtsCollectionView.isUserInteractionEnabled = false
        courtsCollectionView.allowsSelection = false
        courtsCollectionView.isScrollEnabled = false
        courtsCollectionView.collectionViewLayout = layout
        courtsCollectionView.register(CourtCell.self, forCellWithReuseIdentifier: reuseIdentifier)
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

    private func update() {
        let hours = facilityDetail.times.filter { $0.dayOfWeek == selectedDayIndex }
        displayedHours = hours.flatMap { $0.timeRanges }.filter { !$0.restrictions.isEmpty}
        


    }

    // MARK: - Helper
    private func getName(hourRange: FacilityHoursRange) -> String {
        var str = "Court"
        let numberStrings = str.components(separatedBy: CharacterSet.decimalDigits.inverted)
        if !numberStrings.isEmpty { str.append(" #\(numberStrings.first ?? "0")") }
        return str
    }

    private func getSport(hourRange: FacilityHoursRange) -> String {

    }

    private func getTime(hourRange: FacilityHoursRange) -> String {

    }

}

extension CourtView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? CourtCell else { return UICollectionViewCell() }
        cell.configure(name: <#T##String#>, sport: <#T##String#>, time: <#T##String#>)
    }

}

extension CourtView: WeekDelegate {
    func didChangeDay(day: WeekDay) {
        selectedDayIndex = day.index - 1
        update()
    }
}


    // To Ask
    /**
        Display Cases
     -----
     1 Court : centered
     All Day(7am-12:45am) or 11am-2pm
     2 Court :side by side image
        All Day(6am - 12am) or After 6pm (6pm/18:00 - 12am)

     Time Cases
     --
     Mid time - closing time --> "After <midtime>"
     Open Time - Close Time --> "All Day"
     Mid-time - Mid-time --> "<midtime> - <midtime>"
     */
