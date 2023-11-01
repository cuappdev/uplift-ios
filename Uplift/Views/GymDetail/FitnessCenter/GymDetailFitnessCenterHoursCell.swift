//
//  GymDetailFitnessCenterHoursCell.swift
//  Uplift
//
//  Created by alden lamp on 10/23/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

protocol GymDetailFitnessCenterHoursCellDelegate: AnyObject {
    func didDropHours(isDropped: Bool, completion: @escaping () -> Void)
}

class GymDetailFitnessCenterHoursCell: UITableViewCell {

    static let reuseId = "GymDetailFitnessCenterHoursCellReuseId"

    enum LayoutConstants {
        static let hoursTableViewRowHeight: CGFloat = 27
        static let hoursTableViewBottomRowHeight: CGFloat = 19
        static let hoursTableViewTopPadding: CGFloat = 12
    }

    private var isDisclosed = false
    private var hours: OpenHours!
    private weak var delegate: GymDetailFitnessCenterHoursCellDelegate?

    private var tableViewHeight: ConstraintMakerEditable?

    // MARK: - Private view vars
    private let hoursTitleLabel = {
        let label = UILabel()
        label.font = ._16MontserratBold
        label.textColor = .primaryBlack
        label.textAlignment = .center
        label.text = ClientStrings.GymDetail.hoursLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var hoursTableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)

        // Layout
        tableView.translatesAutoresizingMaskIntoConstraints = false

        // Style
        tableView.bounces = false
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.isScrollEnabled = false
        tableView.allowsSelection = false

        // Cells
        tableView.register(GymHoursCell.self, forCellReuseIdentifier: GymHoursCell.identifier)
        tableView.register(GymHoursHeaderView.self, forHeaderFooterViewReuseIdentifier: GymHoursHeaderView.identifier)
        return tableView
    }()

    private let dividerView = {
        let view = UIView()
        view.backgroundColor = .gray01
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        hours = OpenHours(openHours: [])
        hoursTableView.delegate = self
        hoursTableView.dataSource = self
        self.contentView.addSubview(hoursTitleLabel)
        self.contentView.addSubview(hoursTableView)
        self.contentView.addSubview(dividerView)
        setupConstraints()
    }

    public func configure(delegate: GymDetailFitnessCenterHoursCellDelegate, hours: OpenHours, isDisclosed: Bool) {
        self.isDisclosed = isDisclosed
        self.delegate = delegate
        self.hours = hours
        DispatchQueue.main.async {
            // reload table view & remake constraints
            self.hoursTableView.reloadData()
            self.tableViewHeight?.constraint.deactivate()

            self.hoursTableView.snp.makeConstraints { make in
                self.tableViewHeight = make.height.equalTo(self.getTableViewHeight())
            }
            self.layoutIfNeeded()
        }
    }

    private func setupConstraints() {
        hoursTitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(GymDetailConstraints.verticalPadding)
            make.height.equalTo(GymDetailConstraints.titleLabelHeight)
        }

        hoursTableView.snp.makeConstraints { make in
            make.centerX.width.equalToSuperview()
            make.width.equalToSuperview()
            make.top.equalTo(hoursTitleLabel.snp.bottom).offset(LayoutConstants.hoursTableViewTopPadding)
            tableViewHeight = make.height.equalTo(getTableViewHeight())
        }

        dividerView.snp.makeConstraints { make in
            make.height.equalTo(GymDetailConstraints.dividerViewHeight)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }

    private func getTableViewHeight() -> CGFloat {
        if hours.isEmpty() {
            return 0.0
        }

        var height = LayoutConstants.hoursTableViewBottomRowHeight

        if isDisclosed {
         height += CGFloat(hours.getNumHoursLines() - 1) * LayoutConstants.hoursTableViewRowHeight
        }

        return height
    }

    public static func getHeight(isDisclosed: Bool, numLines: Int) -> CGFloat {
        var height = LayoutConstants.hoursTableViewBottomRowHeight
        if isDisclosed {
            height += CGFloat(numLines - 1) * LayoutConstants.hoursTableViewRowHeight
        }
        height += GymDetailConstraints.verticalPadding
        height += GymDetailConstraints.titleLabelHeight
        height += LayoutConstants.hoursTableViewTopPadding
        height += GymDetailConstraints.verticalPadding
        height += GymDetailConstraints.dividerViewHeight
        return height
    }

    @objc func dropHours(sender: UITapGestureRecognizer) {
        hoursTableView.beginUpdates()
        var modifiedIndices: [IndexPath] = []
        (0..<(hours.getNumHoursLines())).forEach { i in
            modifiedIndices.append(IndexPath(row: i, section: 0))
        }

        if isDisclosed { // collapsing details
            isDisclosed = false
            hoursTableView.deleteRows(at: modifiedIndices, with: .fade)
            // swiftlint:disable:next force_cast
            (hoursTableView.headerView(forSection: 0) as! GymHoursHeaderView).downArrow.image = .none
            // swiftlint:disable:next force_cast
            (hoursTableView.headerView(forSection: 0) as! GymHoursHeaderView).rightArrow.image = UIImage(named: ImageNames.rightArrowSolid)

            self.delegate?.didDropHours(isDropped: false) { () in
                UIView.animate(withDuration: 0.3) {
                    self.tableViewHeight?.constraint.deactivate()

                    self.hoursTableView.snp.makeConstraints { make in
                        self.tableViewHeight = make.height.equalTo(self.getTableViewHeight())
                    }
                    self.contentView.layoutIfNeeded()
                }
            }
        } else { // expanding details
            isDisclosed = true
            hoursTableView.insertRows(at: modifiedIndices, with: .fade)
            // swiftlint:disable:next force_cast
            (hoursTableView.headerView(forSection: 0) as! GymHoursHeaderView).downArrow.image = UIImage(named: ImageNames.downArrowSolid)
            // swiftlint:disable:next force_cast
            (hoursTableView.headerView(forSection: 0) as! GymHoursHeaderView).rightArrow.image = .none

            self.delegate?.didDropHours(isDropped: true) { () in
                UIView.animate(withDuration: 0.5) {
                    self.tableViewHeight?.constraint.deactivate()

                    self.hoursTableView.snp.makeConstraints { make in
                        self.tableViewHeight = make.height.equalTo(self.getTableViewHeight())
                    }
                    self.contentView.layoutIfNeeded()
                }
            }
        }
        hoursTableView.endUpdates()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension GymDetailFitnessCenterHoursCell: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isDisclosed ? hours.getNumHoursLines() : 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // swiftlint:disable:next force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: GymHoursCell.identifier, for: indexPath) as! GymHoursCell

        cell.hoursLabel.text = hours.getHoursFor(row: indexPath.row + 1)
        cell.dayLabel.text = hours.getDayAbbreviationFor(row: indexPath.row + 1)

        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // swiftlint:disable:next force_cast
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: GymHoursHeaderView.identifier) as! GymHoursHeaderView

        header.hoursLabel.text = hours.getHoursFor(row: 0)

        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.dropHours(sender:) ))
        header.addGestureRecognizer(gesture)

        return header
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == hours.getNumHoursLines() - 1 ? LayoutConstants.hoursTableViewBottomRowHeight : LayoutConstants.hoursTableViewRowHeight
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let height: CGFloat = isDisclosed ? LayoutConstants.hoursTableViewRowHeight : LayoutConstants.hoursTableViewBottomRowHeight
        return height - 1
    }

}
