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

class GymDetailWeekView: UIView {

    // MARK: - Views
    private var weekdayCollectionView: UICollectionView!

    // MARK: - Info
    private var days: [WeekDay] = WeekDay.allCases

    // MARK: - Display
    private let daysSize = CGSize(width: 24, height: 24)

    // MARK: - Public
    var selectedDay: WeekDay?

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupCollectionView()
        setupConstraints()

        // Preselect Today
        let todayIndex = Calendar.current.component(.weekday, from: Date())
        weekdayCollectionView.selectItem(at: IndexPath(row: (todayIndex + 5) % 7, section: 0), animated: true, scrollPosition: .centeredHorizontally)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Center collection view in size of view
    override func layoutSubviews() {
        weekdayCollectionView.contentInset.top = (frame.height - daysSize.height) / 2
        super.updateConstraints()
    }

    private func setupCollectionView() {
        backgroundColor = .fitnessWhite

        let daySpacing: CGFloat = 19

        let weekdayFlowLayout = UICollectionViewFlowLayout()
        weekdayFlowLayout.itemSize = daysSize
        weekdayFlowLayout.minimumInteritemSpacing = daySpacing

        weekdayCollectionView = UICollectionView(frame: .zero, collectionViewLayout: weekdayFlowLayout)
        weekdayCollectionView.register(GymWeekCell.self, forCellWithReuseIdentifier: Identifiers.gymWeekCell)
        weekdayCollectionView.allowsSelection = true
        weekdayCollectionView.delegate = self
        weekdayCollectionView.dataSource = self
        weekdayCollectionView.isScrollEnabled = false
        weekdayCollectionView.backgroundColor = .clear
        addSubview(weekdayCollectionView)
    }
    
    private func setupConstraints() {
        let weekdayDisplayInset = 39.0
        let weekdayInterimPadding = 19.0

        weekdayCollectionView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalToSuperview()
            make.leading.equalToSuperview().inset(weekdayDisplayInset + weekdayInterimPadding)
            make.trailing.equalToSuperview().inset(weekdayDisplayInset - weekdayInterimPadding)
        }
    }
}

// MARK: - UICollectionViewDelegate
extension GymDetailWeekView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        guard let cell = collectionView.cellForItem(at: indexPath) as? GymWeekCell else { return }
        cell.update()
        selectedDay = days[indexPath.row]
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? GymWeekCell else { return }
        cell.update()
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
        cell.configure(weekday: days[indexPath.row])
        return cell
    }
}
