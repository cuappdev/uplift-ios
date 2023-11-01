//
//  GymDetailHoursCell.swift
//  Uplift
//
//  Created by Yana Sang on 5/26/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import UIKit

protocol GymDetailHoursCellDelegate: AnyObject {
    func didDropHours(isDropped: Bool, completion: @escaping () -> Void)
}

class GymDetailHoursCell: UICollectionViewCell {

    static let reuseId = "gymDetailHoursCellIdentifier"

    // MARK: - Constraint constants
    enum LayoutConstants {
        static let hoursTableViewRowHeight: CGFloat = 27
        static let hoursTableViewBottomRowHeight: CGFloat = 19
        static let hoursTableViewTopPadding: CGFloat = 12
    }

    private var isDisclosed = false
    private weak var delegate: GymDetailHoursCellDelegate?
    private var hours: OpenHours!

    // MARK: - Private view vars
    private let dividerView = UIView()
    private var hoursTableView: UITableView!
    private let hoursTitleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        hours = OpenHours(openHours: [])
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public configure
    func configure(for delegate: GymDetailHoursCellDelegate, hours: OpenHours, isDisclosed: Bool) {
        self.isDisclosed = isDisclosed
        self.delegate = delegate
        self.hours = hours
        DispatchQueue.main.async {
            // reload table view & remake constraints
            self.hoursTableView.reloadData()
            self.setupConstraints()
        }
    }

    // MARK: - Private helpers
    private func setupViews() {
        hoursTitleLabel.font = ._16MontserratBold
        hoursTitleLabel.textColor = .primaryBlack
        hoursTitleLabel.textAlignment = .center
        hoursTitleLabel.text = ClientStrings.GymDetail.hoursLabel
        hoursTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(hoursTitleLabel)

        hoursTableView = UITableView(frame: .zero, style: .grouped)
        hoursTableView.bounces = false
        hoursTableView.showsVerticalScrollIndicator = false
        hoursTableView.showsHorizontalScrollIndicator = false
        hoursTableView.separatorStyle = .none
        hoursTableView.backgroundColor = .clear
        hoursTableView.isScrollEnabled = false
        hoursTableView.allowsSelection = false
        hoursTableView.register(GymHoursCell.self, forCellReuseIdentifier: GymHoursCell.identifier)
        hoursTableView.register(GymHoursHeaderView.self, forHeaderFooterViewReuseIdentifier: GymHoursHeaderView.identifier)
        hoursTableView.delegate = self
        hoursTableView.dataSource = self
        hoursTableView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(hoursTableView)

        // TODO: - Fix layout to match designs
        dividerView.backgroundColor = .gray01
//        dividerView.backgroundColor = .clear
        dividerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(dividerView)
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

    private func setupConstraints() {
        hoursTitleLabel.snp.updateConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(GymDetailConstraints.verticalPadding)
            make.height.equalTo(GymDetailConstraints.titleLabelHeight)
        }

        hoursTableView.snp.updateConstraints { make in
            make.centerX.width.equalToSuperview()
            make.width.equalToSuperview()
            make.top.equalTo(hoursTitleLabel.snp.bottom).offset(LayoutConstants.hoursTableViewTopPadding)
            make.height.equalTo(getTableViewHeight())
        }

        dividerView.snp.updateConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(GymDetailConstraints.dividerViewHeight)
        }

        self.setNeedsLayout()
    }

    // MARK: - Targets
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
                    self.setupConstraints()
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
                    self.setupConstraints()
                    self.contentView.layoutIfNeeded()
                }
            }
        }
        hoursTableView.endUpdates()
    }

    // TODO: - self sizing cells
//    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
//        super.preferredLayoutAttributesFitting(layoutAttributes)
//        print(layoutAttributes.frame)
//        if let width = self.contentView.superview?.superview?.frame.size.width {
//            layoutAttributes.frame.size.width = width
//        }
//        let height = GymDetailHoursCell.getHeight(isDisclosed: self.isDisclosed, numLines: self.hours.getNumHoursLines())
//        layoutAttributes.frame.size.height = GymDetailHoursCell.getHeight(isDisclosed: self.isDisclosed, numLines: self.hours.getNumHoursLines())
//        return layoutAttributes
//    }

}

extension GymDetailHoursCell: UITableViewDelegate, UITableViewDataSource {

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
        return height
    }

}
