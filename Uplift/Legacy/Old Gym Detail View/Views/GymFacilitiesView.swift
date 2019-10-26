//
//  GymFacilitiesView.swift
// Uplift
//
//  Created by Ji Hwan Seung on 4/28/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import UIKit

enum FacilityName {
    case appel
    case helenNewman
    case noyes
    case teagle
}

class FacilitiesGestureRecognizer: UITapGestureRecognizer {
    var title = String()
}

class GymFacilitiesTableView: UIView, UITableViewDataSource, UITableViewDelegate {

    let helenNewmanFacilities: [FacilityData] = [
        FacilityData(facility: "BASKETBALL COURT", isDropped: false, data: [
            ("10 AM - 12 AM", "MON"),
            ("10 AM - 12 AM", "TUE"),
            ("10 AM - 12 AM", "WED"),
            ("10 AM - 12 AM", "THU"),
            ("10 AM - 12 AM, 2 PM - 12 AM", "FRI"),
            ("10 AM - 12 AM, 2 PM - 12 AM", "SAT"),
            ("10 AM - 12 AM", "SUN")
            ]),
        FacilityData(facility: "BOWLING LANES", isDropped: false, data: [
            ("5:30 PM - 10 PM", "MON"),
            ("5:30 PM - 11 PM", "TUE"),
            ("8 PM - 11 PM", "WED"),
            ("5:30 PM - 11 PM", "THU"),
            ("5 PM - 11:30 PM", "FRI"),
            ("12 AM - 11:30 PM", "SAT"),
            ("CLOSED", "SUN")
            ]),
        FacilityData(facility: "SWIMMING POOL", isDropped: false, data: [
            ("7 AM - 8:45 AM, 11 AM - 1:30 PM, 5 PM - 6:30 PM", "MON"),
            ("6 AM - 8:45 AM, 11 AM - 1:30 PM, 5 - 6:30 PM, 10 - 11:15 PM", "TUE"),
            ("7 AM - 7:45 AM, 8 AM - 8:45 AM, 11 AM - 1:30 PM, 5 PM - 6:30 PM, 8:30 PM - 10 PM", "WED"),
            ("6 AM- 8:45 AM, 11 AM - 1:30 PM, 5 - 6:30 PM, 10 - 11:15 PM", "THU"),
            ("7 AM - 8:45 AM, 11 AM - 1:30 PM, 2 PM - 3: 15 PM, 5:30 PM - 7 PM", "FRI"),
            ("2 PM - 4 PM", "SAT"),
            ("CLOSED", "SUN")
            ])
    ]
    let teagleFacilities: [FacilityData] = [
        FacilityData(facility: "SWIMMING POOL", isDropped: false, data: [
            ("9:45 AM - 11:15 AM, 12:15 PM - 1:30 PM", "MON"),
            ("6 AM - 8:30 AM, 9:45 AM - 11:15 AM, 12:15 PM - 1:30 PM", "TUE"),
            ("6 AM - 8:30 AM, 8:45 AM - 11:15 AM, 12:15 PM - 1:30 PM", "WED"),
            ("9:45 AM - 11:15 AM, 12:15 PM - 1:30 PM", "THU"),
            ("6 AM - 8:30 AM, 9:45 AM - 11:15 AM, 12:15 PM - 1:30 PM", "FRI"),
            ("CLOSED", "SAT"),
            ("12 AM - 2 PM", "SUN")
            ])
    ]
    var facilityName: FacilityName!
    var facilityData: [FacilityData]!
    var facilityTableViews: [UITableView] = []

    var basketballSeparator: UIView?
    var basketballTableView: UITableView?
    var bowlingTableView: UITableView?
    var poolSeparator: UIView?
    var poolTableView: UITableView?

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    convenience init(facilityName: FacilityName) {
        self.init(frame: .zero)
        self.facilityName = facilityName
        switch facilityName {
        case .helenNewman:
            facilityData = helenNewmanFacilities
        case .teagle:
            facilityData = teagleFacilities
        case .noyes, .appel:
            facilityData = []
        }

        setupViews(facilityName: facilityName)
        setupConstraints()
    }

    private func setupViews(facilityName: FacilityName) {
        guard let unwrappedFacilityName = self.facilityName else {
            return
        }

        switch unwrappedFacilityName {
        case .helenNewman:
            bowlingTableView = UITableView(frame: .zero, style: .grouped)
            bowlingTableView!.bounces = false
            bowlingTableView!.showsVerticalScrollIndicator = false
            bowlingTableView!.separatorStyle = .none
            bowlingTableView!.backgroundColor = .clear
            bowlingTableView!.isScrollEnabled = false
            bowlingTableView!.allowsSelection = false

            bowlingTableView!.register(FacilityHoursCell.self, forCellReuseIdentifier: FacilityHoursCell.identifier)
            bowlingTableView!.register(FacilityHoursHeaderView.self, forHeaderFooterViewReuseIdentifier: FacilityHoursHeaderView.identifier)

            bowlingTableView!.delegate = self
            bowlingTableView!.dataSource = self
            addSubview(bowlingTableView!)

            basketballTableView = UITableView(frame: .zero, style: .grouped)
            basketballTableView!.bounces = false
            basketballTableView!.showsVerticalScrollIndicator = false
            basketballTableView!.separatorStyle = .none
            basketballTableView!.backgroundColor = .clear
            basketballTableView!.isScrollEnabled = false
            basketballTableView!.allowsSelection = false

            basketballTableView!.register(FacilityHoursCell.self, forCellReuseIdentifier: FacilityHoursCell.identifier)
            basketballTableView!.register(FacilityHoursHeaderView.self, forHeaderFooterViewReuseIdentifier: FacilityHoursHeaderView.identifier)

            basketballTableView!.delegate = self
            basketballTableView!.dataSource = self
            addSubview(basketballTableView!)

            poolTableView = UITableView(frame: .zero, style: .grouped)
            poolTableView!.bounces = false
            poolTableView!.showsVerticalScrollIndicator = false
            poolTableView!.separatorStyle = .none
            poolTableView!.backgroundColor = .clear
            poolTableView!.isScrollEnabled = false
            poolTableView!.allowsSelection = false

            poolTableView!.register(FacilityHoursCell.self, forCellReuseIdentifier: FacilityHoursCell.identifier)
            poolTableView!.register(FacilityHoursHeaderView.self, forHeaderFooterViewReuseIdentifier: FacilityHoursHeaderView.identifier)

            poolTableView!.delegate = self
            poolTableView!.dataSource = self
            addSubview(poolTableView!)

            basketballSeparator = UIView()
            basketballSeparator!.backgroundColor = .gray01
            addSubview(basketballSeparator!)

            poolSeparator = UIView()
            poolSeparator!.backgroundColor = .gray01
            addSubview(poolSeparator!)

        case .teagle:
            poolTableView = UITableView(frame: .zero, style: .grouped)
            poolTableView!.bounces = false
            poolTableView!.showsVerticalScrollIndicator = false
            poolTableView!.separatorStyle = .none
            poolTableView!.backgroundColor = .clear
            poolTableView!.isScrollEnabled = false
            poolTableView!.allowsSelection = false

            poolTableView!.register(FacilityHoursCell.self, forCellReuseIdentifier: FacilityHoursCell.identifier)
            poolTableView!.register(FacilityHoursHeaderView.self, forHeaderFooterViewReuseIdentifier: FacilityHoursHeaderView.identifier)

            poolTableView!.delegate = self
            poolTableView!.dataSource = self
            addSubview(poolTableView!)
        case .noyes, .appel:
            return
        }
    }

    func setupConstraints() {
        guard let unwrappedFacilityName = self.facilityName else {
            return
        }

        let basketballSeparatorHeight = 1
        let basketballSeparatorHorizontalPadding = 24
        let basketballTableViewDroppedHeight = 260
        let basketballTableViewHeight = 42
        let bowlingTableViewDroppedHeight = 260
        let bowlingTableViewHeight = 42
        let poolSeparatorHeight = 1
        let poolSeparatorHorizontalPadding = 24
        let poolTableViewDroppedHeight = 260
        let poolTableViewHeight = 42

        switch unwrappedFacilityName {
        case .helenNewman:
            basketballTableView!.snp.updateConstraints {make in
                make.width.centerX.top.equalToSuperview()
                if facilityData[0].isDropped {
                    make.height.equalTo(basketballTableViewDroppedHeight)
                } else {
                    make.height.equalTo(basketballTableViewHeight)
                }
            }

            basketballSeparator!.snp.updateConstraints {make in
                make.top.equalTo(basketballTableView!.snp.bottom).offset(16)
                make.leading.equalToSuperview().offset(basketballSeparatorHorizontalPadding)
                make.trailing.equalToSuperview().offset(-basketballSeparatorHorizontalPadding)
                make.height.equalTo(basketballSeparatorHeight)
            }

            bowlingTableView!.snp.updateConstraints {make in
                make.width.centerX.equalToSuperview()
                make.top.equalTo(basketballSeparator!.snp.bottom).offset(16)
                if facilityData[1].isDropped {
                    make.height.equalTo(bowlingTableViewDroppedHeight)
                } else {
                    make.height.equalTo(bowlingTableViewHeight)
                }
            }

            poolSeparator!.snp.updateConstraints {make in
                make.top.equalTo(bowlingTableView!.snp.bottom).offset(16)
                make.leading.equalToSuperview().offset(poolSeparatorHorizontalPadding)
                make.trailing.equalToSuperview().offset(-poolSeparatorHorizontalPadding)
                make.height.equalTo(poolSeparatorHeight)
            }

            poolTableView!.snp.updateConstraints {make in
                make.width.centerX.bottom.equalToSuperview()
                make.top.equalTo(poolSeparator!.snp.bottom).offset(16)
                if facilityData[2].isDropped {
                    make.height.equalTo(poolTableViewDroppedHeight)
                } else {
                    make.height.equalTo(poolTableViewHeight)
                }
            }
        case .teagle:
            poolTableView!.snp.updateConstraints {make in
                make.width.centerX.bottom.top.equalToSuperview()
                if facilityData[0].isDropped {
                    make.height.equalTo(poolTableViewDroppedHeight)
                } else {
                    make.height.equalTo(poolTableViewHeight)
                }
            }

        default:
            return
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func dropFacilityHours(sender: FacilitiesGestureRecognizer) {
        guard let unwrappedFacilityName = self.facilityName else {
            return
        }

        switch unwrappedFacilityName {
        case .helenNewman:
            if sender.title == "basketball" {
                basketballTableView!.beginUpdates()
                var modifiedIndices: [IndexPath] = []
                for i in 0..<7 {
                    modifiedIndices.append(IndexPath(row: i, section: 0))
                }

                if facilityData[0].isDropped {
                    facilityData[0].isDropped = false
                    basketballTableView!.deleteRows(at: modifiedIndices, with: .fade)
                    //swiftlint:disable:next force_cast
                    let headerView = basketballTableView!.headerView(forSection: 0) as! FacilityHoursHeaderView
                    headerView.downArrow.image = .none
                    headerView.upArrow.image = UIImage(named: ImageNames.downArrow)

                    self.setupConstraints()
                    self.layoutIfNeeded()
                } else {
                    facilityData[0].isDropped = true
                    basketballTableView!.insertRows(at: modifiedIndices, with: .fade)
                    //swiftlint:disable:next force_cast
                    let headerView = basketballTableView!.headerView(forSection: 0) as! FacilityHoursHeaderView
                    headerView.downArrow.image = UIImage(named: ImageNames.downArrow)
                    headerView.upArrow.image = .none

                    self.setupConstraints()
                    self.layoutIfNeeded()
                }
                basketballTableView!.endUpdates()
            } else if sender.title == "bowling" {

                bowlingTableView!.beginUpdates()
                var modifiedIndices: [IndexPath] = []
                for i in 0..<7 {
                    modifiedIndices.append(IndexPath(row: i, section: 0))
                }

                if facilityData[1].isDropped {
                    facilityData[1].isDropped = false
                    bowlingTableView!.deleteRows(at: modifiedIndices, with: .fade)
                    //swiftlint:disable:next force_cast
                    let headerView = bowlingTableView!.headerView(forSection: 0) as! FacilityHoursHeaderView
                    headerView.downArrow.image = .none
                    headerView.upArrow.image = UIImage(named: ImageNames.downArrow)

                    self.setupConstraints()
                    self.layoutIfNeeded()
                } else {
                    facilityData[1].isDropped = true
                    bowlingTableView!.insertRows(at: modifiedIndices, with: .fade)
                    //swiftlint:disable:next force_cast
                    let headerView = bowlingTableView!.headerView(forSection: 0) as! FacilityHoursHeaderView
                    headerView.downArrow.image = UIImage(named: ImageNames.downArrow)
                    headerView.upArrow.image = .none

                    self.setupConstraints()
                    self.layoutIfNeeded()
                }
                bowlingTableView!.endUpdates()
            } else {
                poolTableView!.beginUpdates()
                var modifiedIndices: [IndexPath] = []
                for i in 0..<7 {
                    modifiedIndices.append(IndexPath(row: i, section: 0))
                }

                if facilityData[2].isDropped {
                    facilityData[2].isDropped = false
                    poolTableView!.deleteRows(at: modifiedIndices, with: .fade)
                    if let headerView = poolTableView!.headerView(forSection: 0) as? FacilityHoursHeaderView {
                        headerView.downArrow.image = .none
                        headerView.upArrow.image = UIImage(named: ImageNames.downArrow)
                    }

                    self.setupConstraints()
                    self.layoutIfNeeded()
                } else {
                    facilityData[2].isDropped = true
                    poolTableView!.insertRows(at: modifiedIndices, with: .fade)
                    if let headerView = poolTableView!.headerView(forSection: 0) as? FacilityHoursHeaderView {
                        headerView.downArrow.image = UIImage(named: ImageNames.downArrow)
                        headerView.upArrow.image = .none
                    }

                    self.setupConstraints()
                    self.layoutIfNeeded()
                }
                poolTableView!.endUpdates()
            }
        case .teagle:
            poolTableView!.beginUpdates()
            var modifiedIndices: [IndexPath] = []
            for i in 0..<7 {
                modifiedIndices.append(IndexPath(row: i, section: 0))
            }

            if facilityData[0].isDropped {
                facilityData[0].isDropped = false
                poolTableView!.deleteRows(at: modifiedIndices, with: .fade)
                if let headerView = poolTableView!.headerView(forSection: 0) as? FacilityHoursHeaderView {
                    headerView.downArrow.image = .none
                    headerView.upArrow.image = UIImage(named: ImageNames.downArrow)
                }

                self.setupConstraints()
                self.layoutIfNeeded()
            } else {
                facilityData[0].isDropped = true
                poolTableView!.insertRows(at: modifiedIndices, with: .fade)
                if let headerView = poolTableView!.headerView(forSection: 0) as? FacilityHoursHeaderView {
                    headerView.downArrow.image = UIImage(named: ImageNames.downArrow)
                    headerView.upArrow.image = .none
                }

                self.setupConstraints()
                self.layoutIfNeeded()
            }
            poolTableView!.endUpdates()
        default:
            return
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let unwrappedFacilityName = self.facilityName else {
            return 0
        }

        switch unwrappedFacilityName {
        case .helenNewman:
            if tableView == basketballTableView! {
                return facilityData[0].isDropped ? 7 : 0
            } else if tableView == bowlingTableView! {
                return facilityData[1].isDropped ? 7 : 0
            } else {
                return facilityData[2].isDropped ? 7 : 0
            }
        case .teagle:
            return facilityData[0].isDropped ? 7 : 0
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let unwrappedFacilityName = self.facilityName else {
            return UITableViewCell()
        }

        switch unwrappedFacilityName {
        case .helenNewman:
            //swiftlint:disable:next force_cast
            let cell = tableView.dequeueReusableCell(withIdentifier: FacilityHoursCell.identifier, for: indexPath) as! FacilityHoursCell

            if tableView == basketballTableView {
                cell.hoursLabel.text = facilityData[0].data[indexPath.row].0
                cell.dayLabel.text = facilityData[0].data[indexPath.row].1

                return cell
            } else if tableView == bowlingTableView {
                cell.hoursLabel.text = facilityData[1].data[indexPath.row].0
                cell.dayLabel.text = facilityData[1].data[indexPath.row].1

                return cell
            } else {
                cell.hoursLabel.text = facilityData[2].data[indexPath.row].0
                cell.dayLabel.text = facilityData[2].data[indexPath.row].1

                return cell
            }
        case .teagle:
            //swiftlint:disable:next force_cast
            let cell = tableView.dequeueReusableCell(withIdentifier: FacilityHoursCell.identifier, for: indexPath) as! FacilityHoursCell
            cell.hoursLabel.text = facilityData[0].data[indexPath.row].0
            cell.dayLabel.text = facilityData[0].data[indexPath.row].1

            return cell
        default:
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let unwrappedFacilityName = self.facilityName else {
            return nil
        }

        switch unwrappedFacilityName {
        case .helenNewman:
            //swiftlint:disable:next force_cast
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: FacilityHoursHeaderView.identifier) as! FacilityHoursHeaderView
            var gesture: FacilitiesGestureRecognizer!

            if tableView == basketballTableView {
                header.iconImageView.image = UIImage(named: ImageNames.basketball)
                header.facilityNameLabel.text = facilityData[0].facility
                gesture = FacilitiesGestureRecognizer(target: self, action: #selector(self.dropFacilityHours(sender:) ))
                gesture.title = "basketball"

            } else if tableView == bowlingTableView {
                header.iconImageView.image = UIImage(named: ImageNames.bowling)
                header.facilityNameLabel.text = facilityData[1].facility
                gesture = FacilitiesGestureRecognizer(target: self, action: #selector(self.dropFacilityHours(sender:) ))
                gesture.title = "bowling"
            } else {
                header.iconImageView.image = UIImage(named: ImageNames.pool)
                header.facilityNameLabel.text = facilityData[2].facility
                gesture = FacilitiesGestureRecognizer(target: self, action: #selector(self.dropFacilityHours(sender:) ))
                gesture.title = "pool"
            }

            header.addGestureRecognizer(gesture)

            return header
        case .teagle:
            //swiftlint:disable:next force_cast
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: FacilityHoursHeaderView.identifier) as! FacilityHoursHeaderView
            header.iconImageView.image = UIImage(named: ImageNames.pool)
            header.facilityNameLabel.text = facilityData[0].facility
            let gesture = FacilitiesGestureRecognizer(target: self, action: #selector(self.dropFacilityHours(sender:) ))
            header.addGestureRecognizer(gesture)

            return header
        default:
            return nil
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 28
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let unwrappedFacilityName = self.facilityName else {
            return 0
        }

        switch unwrappedFacilityName {
        case .helenNewman, .teagle:
            return 36
        default:
            return 0
        }
    }
}
