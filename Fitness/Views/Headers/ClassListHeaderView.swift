//
//  ClassListHeaderView.swift
//  Fitness
//
//  Created by Keivan Shahida on 3/21/18.
//  Copyright © 2018 Keivan Shahida. All rights reserved.
//

import UIKit
import SnapKit

class ClassListHeaderView: UITableViewHeaderFooterView, UICollectionViewDataSource, UICollectionViewDelegate {

    // MARK: - INITIALIZATION
    static let identifier = Identifiers.classListHeaderView
    var collectionView: UICollectionView!

    var currentWeekDay: Int!
    var calendar: Calendar!
    var selectedDayIndex: Int!
    var currentDateLabel: UILabel!

    var delegate: ClassListViewController!

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        layer.backgroundColor = UIColor.white.cgColor

        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 54, height: 97)
        flowLayout.scrollDirection = UICollectionViewScrollDirection.horizontal
        flowLayout.minimumInteritemSpacing = 0.0
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.layer.backgroundColor = UIColor.clear.cgColor
        collectionView.register(CalendarCell.self, forCellWithReuseIdentifier: CalendarCell.identifier)

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()

        addSubview(collectionView)

        selectedDayIndex = 3

        calendar = Calendar.current

        currentWeekDay = Date.getIntegerDayOfWeekToday(Date())()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LAYOUT
    override open func layoutSubviews() {
        super.layoutSubviews()

        currentDateLabel = UILabel()
        currentDateLabel.text = "TODAY"
        currentDateLabel.font = ._14MontserratMedium
        currentDateLabel.textAlignment = .center
        currentDateLabel.textColor = .fitnessDarkGrey
        currentDateLabel.sizeToFit()
        addSubview(currentDateLabel)

        setConstraints()
    }

    // MARK: - CONSTRAINTS
    func setConstraints() {

        collectionView.snp.makeConstraints { make in
            make.left.equalTo(contentView)
            make.right.equalTo(contentView)
            make.top.equalTo(contentView)
            make.height.equalTo(97)
        }

        currentDateLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-32)
            make.height.equalTo(15)
        }
    }

    // MARK: - COLLECTION VIEW
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if(indexPath.row == selectedDayIndex) {
            let calendarCell = cell as! CalendarCell

            calendarCell.shapeLayer.fillColor = UIColor.fitnessBlack.cgColor
            calendarCell.dateLabel.textColor = .white
        }
    }

    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if(indexPath.row == selectedDayIndex) {
            let calendarCell = cell as! CalendarCell

            calendarCell.shapeLayer.fillColor = UIColor.white.cgColor

            if(indexPath.row < 3) {
                calendarCell.dateLabel.textColor = .fitnessMediumGrey
            } else {
                calendarCell.dateLabel.textColor = .fitnessBlack
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let oldCell = collectionView.cellForItem(at: IndexPath(row: selectedDayIndex, section: indexPath.section)) as? CalendarCell {
            oldCell.shapeLayer.fillColor = UIColor.white.cgColor

            if(selectedDayIndex < 3) {
                oldCell.dateLabel.textColor = .fitnessMediumGrey
            } else {
                oldCell.dateLabel.textColor = .fitnessBlack
            }
        }

        selectedDayIndex = indexPath.row

        let cell = collectionView.cellForItem(at: indexPath) as! CalendarCell

        cell.dateLabel.textColor = .white
        cell.shapeLayer.fillColor = UIColor.fitnessBlack.cgColor
        delegate.selectedDate = cell.date

        delegate.updateDate()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarCell.identifier, for: indexPath) as! CalendarCell

        let offset = indexPath.row - 3

        let day = calendar.date(byAdding: .day, value: offset, to: Date())
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"

        cell.dateLabel.text = String(dateFormatter.string(from: day!))

        dateFormatter.dateFormat = "MM/dd/YYYY"
        cell.date = dateFormatter.string(from: day!)

        if(indexPath.row < 3) {
            cell.dateLabel.textColor = UIColor(red: 206/255, green: 206/255, blue: 206/255, alpha: 1.0)
            cell.dayOfWeekLabel.textColor = UIColor(red: 206/255, green: 206/255, blue: 206/255, alpha: 1.0)
        } else {
            cell.dateLabel.textColor = .fitnessBlack
            cell.dayOfWeekLabel.textColor = .fitnessBlack
        }

        if(indexPath.row == selectedDayIndex) {
            cell.dateLabel.textColor = .white
            cell.shapeLayer.fillColor = UIColor.fitnessBlack.cgColor
            delegate.selectedDate = cell.date
        }

        switch (offset + currentWeekDay)%7 {
        case 0:
            cell.dayOfWeekLabel.text = "Su"
        case 1:
            cell.dayOfWeekLabel.text = "M"
        case 2:
            cell.dayOfWeekLabel.text = "T"
        case 3:
            cell.dayOfWeekLabel.text = "W"
        case 4:
            cell.dayOfWeekLabel.text = "Th"
        case 5:
            cell.dayOfWeekLabel.text = "F"
        case 6:
            cell.dayOfWeekLabel.text = "Sa"
        default:
            cell.dayOfWeekLabel.text = ""
        }

        return cell
    }
}
