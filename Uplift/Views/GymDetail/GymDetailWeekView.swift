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
    private var days: [WeekDay] = [.sunday, .monday, .tuesday, .wednesday, .thursday, .friday, .saturday]

    /// Current Day of today
    private var today: WeekDay {
        get {
            let weekdayIndex = Calendar.current.component(.weekday, from: Date())
            return WeekDay(index: weekdayIndex)
        }
    }

    // MARK: - Display
    private let daysSize = CGSize(width: 24, height: 24)

    // MARK: - Public
    var selectedDay: WeekDay = .sunday

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
        setupConstraints()
        weekdayCollectionView.selectItem(at: IndexPath(row: today.index - 1, section: 0), animated: true, scrollPosition: .centeredHorizontally)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        // Spacing Constants
        let daySpacing: CGFloat = 19

        self.backgroundColor = .fitnessWhite

        // CollectionView Flow Layout
        let weekdayFlowLayout = UICollectionViewFlowLayout()
        weekdayFlowLayout.itemSize = daysSize
        weekdayFlowLayout.minimumInteritemSpacing = daySpacing
//        weekdayFlowLayout.sectionInset = .init(top: 0.0, left: 52.0/*39.0*/, bottom: 0.0, right: 39.0)

        // CollectionView
        weekdayCollectionView = UICollectionView(frame: .zero, collectionViewLayout: weekdayFlowLayout)
        weekdayCollectionView.register(GymWeekCell.self, forCellWithReuseIdentifier: Identifiers.gymWeekCell)
        weekdayCollectionView.allowsSelection = true
        weekdayCollectionView.delegate = self
        weekdayCollectionView.dataSource = self
        weekdayCollectionView.isScrollEnabled = false
        weekdayCollectionView.backgroundColor = .clear

        self.addSubview(weekdayCollectionView)
    }
    
    private func setupConstraints() {
        let weekdayDisplayInset = 39.0
        let weekdayInterimPadding = 19.0
        self.snp.makeConstraints { make in
            make.height.equalTo(daysSize.height)
        }

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
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? GymWeekCell else { return }
        cell.update()
    }
}


// MARK: - UICollectionViewDataSource
extension GymDetailWeekView: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // TODO replace with guard let
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.gymWeekCell, for: indexPath) as? GymWeekCell else {
            return UICollectionViewCell()
        }
        cell.configure(weekday: days[indexPath.row], today: today)
        return cell
    }
}

// MARK: - Helper
enum WeekDay: String, CaseIterable {
    //TODO replace with constants
    case sunday = "Su"
    case monday = "M"
    case tuesday = "T"
    case wednesday = "W"
    case thursday = "Th"
    case friday = "F"
    case saturday = "Sa"

    /// Constructs enum from index
    init(index: Int) {
        self = WeekDay.allCases[index - 1]
    }

    /// Constructs enum from Weekday String
    init(day: String) {
        let d = day.lowercased()
        if d == "sunday" {
            self = .sunday
        } else if d == "monday" {
            self = .monday
        } else if d == "tuesday" {
            self = .tuesday
        } else if d == "wednesday" {
            self = .wednesday
        } else if d == "thursday" {
            self = .thursday
        } else if d == "friday" {
            self = .friday
        } else if d == "saturday" {
            self = .saturday
        } else {
            print("Invalid Day String was passed: \(day) doesn't correspond to anything")
            self = .sunday
        }
    }

    /**
     Maps each enum case to index corresponding to ones returned by
     Calendar.current.component(.weekDay, from: Date())
     */
    var index: Int { get {
        switch self {
        case .sunday:       return 1
        case .monday:       return 2
        case .tuesday:      return 3
        case .wednesday:    return 4
        case .thursday:     return 5
        case .friday:       return 6
        case .saturday:     return 7
        default: return -1
        }}
    }
}
