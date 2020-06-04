//
//  SportsFilterSportsDropdownCollectionViewCell.swift
//  Uplift
//
//  Created by Cameron Hamidi on 5/16/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import UIKit

class SportsFilterSportsDropdownCollectionViewCell: UICollectionViewCell {

    static let initialHeight: CGFloat = 55

    private let tableView = UITableView()
    private let dropdownHeader = DropdownHeaderView(title: ClientStrings.Filter.selectSportsSection)

    private var dropdownView: DropdownView!

    weak var dropdownDelegate: DropdownViewDelegate?
    weak var dropdownHeaderDelegate: DropdownHeaderViewDelegate?

    var selectedSports: [String] = []

    var sportsTypeDropdownData: DropdownData!

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.isUserInteractionEnabled = true
        contentView.backgroundColor = .white//red

        dropdownHeader.delegate = dropdownHeaderDelegate

        let halfOpenView = SportsDropdownHalfView()
        halfOpenView.setLabelText(to: ClientStrings.Filter.sportsDropdownShowSports)

        let halfCloseView = SportsDropdownHalfView()
        halfCloseView.setLabelText(to: ClientStrings.Filter.sportsDropdownHideSports)

        tableView.register(DropdownViewCell.self, forCellReuseIdentifier: Identifiers.dropdownViewCell)
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear

        dropdownView = DropdownView(delegate: dropdownDelegate, headerView: dropdownHeader, headerViewHeight: 55, contentView: tableView, contentViewHeight: CGFloat(32 * sportsTypeDropdownData.titles.count), halfDropdownEnabled: true, halfOpenView: halfOpenView, halfOpenViewHeight: 20, halfCloseView: halfCloseView, halfCloseViewHeight: 20, halfHeight: 32 * 3)

        contentView.addSubview(dropdownView)

        dropdownView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(for dropdownData: DropdownData) {
        sportsTypeDropdownData = dropdownData
        dropdownView.setStatus(to: sportsTypeDropdownData.dropStatus)
    }

    func getDropdownHeight() -> CGFloat {
        return dropdownView.currentHeight
    }

}

//extension SportsFilterSportsDropdownCollectionViewCell: DropdownHeaderViewDelegate {
//
//    func didTapHeaderView() {
//        dropdownView.openCloseDropdown()
//        dropdownHeightChanged()
//    }
//
//}

extension SportsFilterSportsDropdownCollectionViewCell: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sportsTypeDropdownData.titles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.dropdownViewCell, for: indexPath) as! DropdownViewCell
        if indexPath.row < sportsTypeDropdownData.titles.count {
            let isSelected = selectedSports.contains(sportsTypeDropdownData.titles[indexPath.row])
            cell.configure(for: sportsTypeDropdownData.titles[indexPath.row], selected: isSelected)
        }
        return cell
    }

}

extension SportsFilterSportsDropdownCollectionViewCell: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 32
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! DropdownViewCell
        print(cell.wasSelected)
        if !cell.wasSelected {
            selectedSports.append(cell.getTitle())
        } else {
            for i in 0..<selectedSports.count {
                let name = selectedSports[i]
                if name == cell.getTitle() {
                    selectedSports.remove(at: i)
                    break
                }
            }
        }
        cell.select()
        dropdownHeader.updateDropdownHeader(selectedFilters: selectedSports)
    }

}
