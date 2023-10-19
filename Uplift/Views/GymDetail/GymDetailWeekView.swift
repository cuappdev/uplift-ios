//
//  GymDetailCalendarView.swift
//  Uplift
//
//  The header calendar used to select which content to display based on day of the week
//
//  Created by Phillip OReggio on 10/2/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import UIKit
import SnapKit

// MARK: - Delegation
protocol WeekDelegate: AnyObject {
    func weekDidChange(with day: WeekDay)
}

class GymDetailWeekView: UIView {

    // MARK: - Public
    var onChangeDay: ((Int) -> Void)?
    var selectedDay: WeekDay = .sunday

    // MARK: - Display
    static let daysSize = CGSize(width: 24, height: 24)
    private let interitemSpace: CGFloat = 19
    private var weekdayCollectionView: UICollectionView!

    // MARK: - Info
    private var days: [WeekDay] = WeekDay.allCases
    private var selectedDayIndex: Int

    override init(frame: CGRect) {
        // Preselect Today
        selectedDayIndex = Calendar.current.component(.weekday, from: Date())
        selectedDay = days[selectedDayIndex - 1]

        super.init(frame: frame)

        setupCollectionView()
        setupConstraints()
    }

    func configure(for selectedDayIndex: Int, onChangeDay: ((Int) -> Void)?) {
        self.selectedDayIndex = selectedDayIndex
        self.onChangeDay = onChangeDay
        weekdayCollectionView.reloadData()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Center collection view in size of view
    override func layoutSubviews() {
        weekdayCollectionView.contentInset.top = (frame.height - GymDetailWeekView.daysSize.height) / 2
        super.layoutSubviews()
    }

    private func setupCollectionView() {
        backgroundColor = .primaryWhite

        let weekdayFlowLayout = UICollectionViewFlowLayout()
        weekdayFlowLayout.itemSize = GymDetailWeekView.daysSize
        weekdayFlowLayout.minimumInteritemSpacing = interitemSpace

        weekdayCollectionView = UICollectionView(frame: .zero, collectionViewLayout: weekdayFlowLayout)
        weekdayCollectionView.register(GymWeekCell.self, forCellWithReuseIdentifier: Identifiers.gymWeekCell)
        weekdayCollectionView.allowsSelection = true
        weekdayCollectionView.delegate = self
        weekdayCollectionView.dataSource = self
        weekdayCollectionView.isScrollEnabled = false
        weekdayCollectionView.backgroundColor = .clear
        addSubview(weekdayCollectionView)

        weekdayCollectionView.selectItem(at: IndexPath(row: selectedDayIndex - 1, section: 0), animated: true, scrollPosition: .centeredHorizontally)
    }

    private func setupConstraints() {
        let weekdayCollectionViewWidth: CGFloat = 282

        weekdayCollectionView.snp.makeConstraints { make in
            make.center.height.equalToSuperview()
            make.width.equalTo(weekdayCollectionViewWidth)
        }
    }
}

// MARK: - UICollectionViewDelegate
extension GymDetailWeekView: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedDay = days[indexPath.row]
        onChangeDay?(selectedDay.rawValue - 1)
    }

}

// MARK: - UICollectionViewDataSource
extension GymDetailWeekView: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return days.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.gymWeekCell, for: indexPath) as? GymWeekCell else {
            return UICollectionViewCell()
        }

        let isSelected = indexPath.row == selectedDayIndex
        cell.configure(weekDay: days[indexPath.row], isSelected: isSelected)
        return cell
    }

}
