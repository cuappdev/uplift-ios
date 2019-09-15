//
//  GymDetailHoursCell.swift
//  Fitness
//
//  Created by Yana Sang on 5/26/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import UIKit

protocol GymDetailHoursCellDelegate: class {
    func didDropHours(isDropped: Bool, completion: @escaping () -> Void)
}

class GymDetailHoursCell: UICollectionViewCell {

    // MARK: - Constraint constants
    private enum Constants {
        static let dividerHeight = 1
        static let dividerTopPadding = 32
        static let hoursTableViewDroppedHeight = 181
        static let hoursTableViewHeight = 19
        static let hoursTableViewTopPadding = 12
        static let hoursTitleLabelHeight = 19
        static let hoursTitleLabelTopPadding = 36
    }

    // MARK: - Public data vars
    static var baseHeight: CGFloat {
        var height = Constants.hoursTitleLabelTopPadding +
            Constants.hoursTitleLabelHeight +
            Constants.hoursTableViewTopPadding +
            Constants.dividerTopPadding +
            Constants.dividerHeight
        height = hoursData.isDropped
            ? height + Constants.hoursTableViewDroppedHeight
            : height + Constants.hoursTableViewHeight
        return CGFloat(height)
    }

    // MARK: - Private structs/classes
    private struct HoursData {
        var data: [String]!
        var isDropped: Bool!
    }

    // MARK: - Private data vars
    private enum Days {
        case sunday
        case monday
        case tuesday
        case wednesday
        case thursday
        case friday
        case saturday
    }

    private let days: [Days] = [.sunday, .monday, .tuesday, .wednesday, .thursday, .friday, .saturday]
    private weak var delegate: GymDetailHoursCellDelegate?
    private var hours: [DailyGymHours] = []
    private static var hoursData = HoursData(data: [], isDropped: false)
    private var hoursToday: DailyGymHours!
    private var isOpen: Bool = true

    // MARK: - Private view vars
    private let closedLabel = UILabel()
    private let dividerView = UIView()
    private var hoursTableView: UITableView!
    private let hoursTitleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public configure
    func configure(for delegate: GymDetailHoursCellDelegate, gym: Gym) {
        self.delegate = delegate
        self.hours = gym.gymHours
        self.hoursToday = gym.gymHoursToday
        self.isOpen = gym.isOpen
        DispatchQueue.main.async {
            // reload table view & remake constraints
            self.hoursTableView.reloadData()
            self.setupConstraints()
        }
    }

    // MARK: - Private helpers
    private func setupViews() {
        closedLabel.font = ._16MontserratSemiBold
        closedLabel.textColor = .white
        closedLabel.textAlignment = .center
        closedLabel.backgroundColor = .fitnessBlack
        closedLabel.text = "CLOSED"
        contentView.addSubview(closedLabel)

        hoursTitleLabel.font = ._16MontserratMedium
        hoursTitleLabel.textColor = .fitnessBlack
        hoursTitleLabel.textAlignment = .center
        hoursTitleLabel.text = "HOURS"
        contentView.addSubview(hoursTitleLabel)

        hoursTableView = UITableView(frame: .zero, style: .grouped)
        hoursTableView.bounces = false
        hoursTableView.showsVerticalScrollIndicator = false
        hoursTableView.separatorStyle = .none
        hoursTableView.backgroundColor = .clear
        hoursTableView.isScrollEnabled = false
        hoursTableView.allowsSelection = false
        hoursTableView.register(GymHoursCell.self, forCellReuseIdentifier: GymHoursCell.identifier)
        hoursTableView.register(GymHoursHeaderView.self, forHeaderFooterViewReuseIdentifier: GymHoursHeaderView.identifier)
        hoursTableView.delegate = self
        hoursTableView.dataSource = self
        contentView.addSubview(hoursTableView)

        dividerView.backgroundColor = .fitnessMutedGreen
        contentView.addSubview(dividerView)
    }

    private func setupConstraints() {
        hoursTitleLabel.snp.updateConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(closedLabel.snp.bottom).offset(Constants.hoursTitleLabelTopPadding)
            make.height.equalTo(Constants.hoursTitleLabelHeight)
        }

        hoursTableView.snp.updateConstraints { make in
            make.centerX.width.equalToSuperview()
            make.top.equalTo(hoursTitleLabel.snp.bottom).offset(Constants.hoursTableViewTopPadding)
            if hours.isEmpty || hoursToday == nil {
                make.height.equalTo(0)
            } else {
                if GymDetailHoursCell.hoursData.isDropped {
                    make.height.equalTo(Constants.hoursTableViewDroppedHeight)
                } else {
                    make.height.equalTo(Constants.hoursTableViewHeight)
                }
            }
        }

        dividerView.snp.updateConstraints {make in
            make.top.equalTo(hoursTableView.snp.bottom).offset(Constants.dividerTopPadding)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(Constants.dividerHeight)
        }
    }

    func getStringFromDailyHours(dailyGymHours: DailyGymHours) -> String {
        let openTime = dailyGymHours.openTime.getStringOfDatetime(format: "h:mm a")
        let closeTime = dailyGymHours.closeTime.getStringOfDatetime(format: "h:mm a")

        if dailyGymHours.openTime != dailyGymHours.closeTime {
            return "\(openTime) - \(closeTime)"
        }
        
        return "Closed"
    }

    // MARK: - Targets
    @objc func dropHours(sender: UITapGestureRecognizer) {
        hoursTableView.beginUpdates()
        var modifiedIndices: [IndexPath] = []
        (0..<6).forEach { i in
            modifiedIndices.append(IndexPath(row: i, section: 0))
        }

        if GymDetailHoursCell.hoursData.isDropped { // collapsing details
            GymDetailHoursCell.hoursData.isDropped = false
            hoursTableView.deleteRows(at: modifiedIndices, with: .fade)
            // swiftlint:disable:next force_cast
            (hoursTableView.headerView(forSection: 0) as! GymHoursHeaderView).downArrow.image = .none
            // swiftlint:disable:next force_cast
            (hoursTableView.headerView(forSection: 0) as! GymHoursHeaderView).rightArrow.image = UIImage(named: "right-arrow-solid")

            self.delegate?.didDropHours(isDropped: false) { () in
                UIView.animate(withDuration: 0.3) {
                    self.setupConstraints()
                    self.contentView.layoutIfNeeded()
                }
            }
        } else { // expanding details
            GymDetailHoursCell.hoursData.isDropped = true
            hoursTableView.insertRows(at: modifiedIndices, with: .fade)
            // swiftlint:disable:next force_cast
            (hoursTableView.headerView(forSection: 0) as! GymHoursHeaderView).downArrow.image = UIImage(named: "down-arrow-solid")
            // swiftlint:disable:next force_cast
            (hoursTableView.headerView(forSection: 0) as! GymHoursHeaderView).rightArrow.image = .none

            self.delegate?.didDropHours(isDropped: true) { () in
                UIView.animate(withDuration: 0.5) {
                    self.setupConstraints()
                    self.contentView.layoutIfNeeded()
                }
            }
        }
        hoursTableView.endUpdates()
    }
}

extension GymDetailHoursCell: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numRows = GymDetailHoursCell.hoursData.isDropped ? 6 : 0
        return numRows
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // swiftlint:disable:next force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: GymHoursCell.identifier, for: indexPath) as! GymHoursCell

        let date = Date()
        let day = (date.getIntegerDayOfWeekToday() + indexPath.row + 1) % 7
        cell.hoursLabel.text = getStringFromDailyHours(dailyGymHours: hours[day])

        switch days[day] {
        case .sunday:
            cell.dayLabel.text = DayAbbreviations.sunday
        case .monday:
            cell.dayLabel.text = DayAbbreviations.monday
        case .tuesday:
            cell.dayLabel.text = DayAbbreviations.tuesday
        case .wednesday:
            cell.dayLabel.text = DayAbbreviations.wednesday
        case .thursday:
            cell.dayLabel.text = DayAbbreviations.thursday
        case .friday:
            cell.dayLabel.text = DayAbbreviations.friday
        case .saturday:
            cell.dayLabel.text = DayAbbreviations.saturday
        }

        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // swiftlint:disable:next force_cast
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: GymHoursHeaderView.identifier) as! GymHoursHeaderView

        header.hoursLabel.text = getStringFromDailyHours(dailyGymHours: hoursToday)

        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.dropHours(sender:) ))
        header.addGestureRecognizer(gesture)

        return header
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == 5 ? 19 : 27
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let height: CGFloat = GymDetailHoursCell.hoursData.isDropped ? 27 : 19
        return height
    }
}
