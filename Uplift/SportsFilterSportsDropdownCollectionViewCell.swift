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

    private let bottomDivider = UIView()
    private let dropdownHeader = DropdownHeaderView(title: ClientStrings.Filter.selectSportsSection)
    private let tableView = UITableView()

    private var dropdownView: DropdownView!

    weak var dropdownDelegate: DropdownViewDelegate?

    var selectedSports: [String] = []

    var sportsTypeDropdownData: DropdownData!

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.isUserInteractionEnabled = true
        contentView.backgroundColor = .white//red

        dropdownHeader.delegate = self

        let halfOpenView = SportsDropdownHalfView()
        halfOpenView.isUserInteractionEnabled = true
        halfOpenView.setLabelText(to: ClientStrings.Filter.sportsDropdownShowSports)

        let halfCloseView = SportsDropdownHalfView()
        halfCloseView.setLabelText(to: ClientStrings.Filter.sportsDropdownHideSports)

        tableView.register(DropdownViewCell.self, forCellReuseIdentifier: Identifiers.dropdownViewCell)
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear

        dropdownView = DropdownView(headerView: dropdownHeader, headerViewHeight: 55, contentView: tableView, contentViewHeight: 0, halfDropdownEnabled: true, halfOpenView: halfOpenView, halfOpenViewHeight: 20, halfCloseView: halfCloseView, halfCloseViewHeight: 20, halfHeight: 32 * 3)

        contentView.addSubview(dropdownView)

        dropdownView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        bottomDivider.backgroundColor = .gray01
        contentView.addSubview(bottomDivider)

        bottomDivider.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(1)
        }

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(for dropdownData: DropdownData, dropdownDelegate: DropdownViewDelegate? = nil, selectedSports: [String] = []) {
        self.dropdownDelegate = dropdownDelegate
        dropdownView.delegate = dropdownDelegate
        sportsTypeDropdownData = dropdownData
        self.selectedSports = selectedSports
        dropdownView.updateContentViewHeight(to: CGFloat(32 * sportsTypeDropdownData.titles.count))
        dropdownView.setStatus(to: sportsTypeDropdownData.dropStatus)
        dropdownHeader.updateDropdownHeader(selectedFilters: selectedSports)
        tableView.reloadData()
    }

    func getDropdownHeight() -> CGFloat {
        return dropdownView.currentHeight
    }

}

extension SportsFilterSportsDropdownCollectionViewCell: DropdownHeaderViewDelegate {

    func didTapHeaderView() {
        dropdownView.openCloseDropdown()
//        if let vc = dropdownDelegate as? SportsFilterViewController {
//            vc.dropdownStatusChanged(to: .open, with: 0)
//        }
    }

}

extension SportsFilterSportsDropdownCollectionViewCell: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sportsTypeDropdownData.titles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.dropdownViewCell, for: indexPath) as! DropdownViewCell
        if indexPath.row < sportsTypeDropdownData.titles.count {
            print(indexPath.row)
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
