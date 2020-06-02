//
//  SportsFilterSportsDropdownCollectionViewCell.swift
//  Uplift
//
//  Created by Cameron Hamidi on 5/16/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import UIKit

class SportsFilterSportsDropdownCollectionViewCell: UICollectionViewCell {

    var dropdownHeader: DropdownHeaderView!// = DropdownHeaderView(title: "TEST")
    private var dropdownView: DropdownView!// = DropdownView(delegate: self, headerView: dropdownHeader, headerViewHeight: <#T##CGFloat#>, contentView: <#T##UIView#>, contentViewHeight: <#T##CGFloat#>)

     var selectedSports: [String] = []

    var sportsTypeDropdownData: DropdownData!

    override init(frame: CGRect) {
        super.init(frame: frame)
        sportsTypeDropdownData = DropdownData(completed: false, dropStatus: .up, titles: [])

        // TODO: replace with networked sports.
        let sportsNames = ["Basketball", "Soccer", "Table Tennis", "Frisbee", "A", "B", "C"]
        sportsTypeDropdownData.titles.append(contentsOf: sportsNames)
//        sportsTypeDropdownData.titles.sort()
        sportsTypeDropdownData.completed = true
//        sportsTypeDropdown.reloadData()

        let dropdownContentView = UIView()
        dropdownContentView.backgroundColor = .green

        let halfOpenView = UIView()
        halfOpenView.backgroundColor = .red

        let halfCloseView = UIView()
        halfCloseView.backgroundColor = .purple

        dropdownHeader = DropdownHeaderView(title: "TEST")

//        dropdownView = DropdownView(delegate: self, headerView: dropdownHeader, headerViewHeight: 55, contentView: dropdownContentView, contentViewHeight: 400, halfDropdownEnabled: true, halfOpenView: halfOpenView, halfOpenViewHeight: 20, halfCloseView: halfCloseView, halfCloseViewHeight: 20, halfHeight: 200)
//
//        contentView.addSubview(dropdownView)
//
//        dropdownView.snp.makeConstraints { make in
//            make.leading.trailing.top.equalToSuperview()
//            make.height.equalTo(dropdownView.currentHeight)
//        }

        let tableView = UITableView()
        tableView.register(DropdownViewCell.self, forCellReuseIdentifier: DropdownViewCell.identifier)
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        contentView.addSubview(tableView)

        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension SportsFilterSportsDropdownCollectionViewCell: DropdownViewDelegate {

    func dropdownViewClosed(sender dropdownView: DropdownView) {
        return
    }

    func dropdownViewOpen(sender dropdownView: DropdownView) {
        return
    }

    func dropdownViewHalf(sender dropdownView: DropdownView) {
        return
    }

}
extension SportsFilterSportsDropdownCollectionViewCell: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sportsTypeDropdownData.titles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DropdownViewCell.identifier, for: indexPath) as! DropdownViewCell
        if indexPath.row < sportsTypeDropdownData.titles.count {
            print(sportsTypeDropdownData.titles[indexPath.row])
            cell.titleLabel.text = sportsTypeDropdownData.titles[indexPath.row]
            if selectedSports.contains(sportsTypeDropdownData.titles[indexPath.row]) {
                cell.checkBoxColoring.backgroundColor = .primaryYellow
            }
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
        var shouldAppend: Bool = cell.checkBoxColoring.backgroundColor == .primaryYellow

        cell.checkBoxColoring.backgroundColor = shouldAppend ? .white : .primaryYellow
        shouldAppend = !shouldAppend

        if shouldAppend {
            selectedSports.append(cell.titleLabel.text!)
        } else {
            for i in 0..<selectedSports.count {
                let name = selectedSports[i]
                if name == cell.titleLabel.text! {
                    selectedSports.remove(at: i)
//                    sportsTypeDropdownHeader.updateDropdownHeader(selectedFilters: selectedSports)
                    return
                }
            }
        }
//            sportsTypeDropdownHeader.updateDropdownHeader(selectedFilters: selectedSports)
    }

}
