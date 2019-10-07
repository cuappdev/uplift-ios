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

    // MARK: - Public
    var selectedDay: WeekDay = .sunday

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
        setupConstraints()
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
        weekdayFlowLayout.itemSize = CGSize(width: 24, height: 24)
        weekdayFlowLayout.minimumInteritemSpacing = daySpacing
        weekdayFlowLayout.sectionInset = .init(top: 0.0, left: 38.0, bottom: 0.0, right: 38.0)

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
        weekdayCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - UICollectionViewDelegate
extension GymDetailWeekView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("boutta reload")

        let item = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.gymWeekCell, for: indexPath)
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        collectionView.reloadItems(at: [indexPath])

//        item.isSelected = true

//        if let cell = item as? GymWeekCell {
//            cell.update()
//            cell.isSelected = true
//            print("is selected? \(cell.isSelected)")
//        }
//        collectionView.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
        <#code#>
    }

}


// MARK: - UICollectionViewDataSource
extension GymDetailWeekView: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.gymWeekCell, for: indexPath)
        if let cell = item as? GymWeekCell {
            cell.configure(weekday: days[indexPath.row], today: today)
        }
        return item
    }
}

// MARK: - Helper
enum WeekDay: String, CaseIterable {
    case sunday = DayAbbreviations.sunday
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
    func index() -> Int {
        switch self {
        case .sunday:       return 1
        case .monday:       return 2
        case .tuesday:      return 3
        case .wednesday:    return 4
        case .thursday:     return 5
        case .friday:       return 6
        case .saturday:     return 7
        }
    }
}
