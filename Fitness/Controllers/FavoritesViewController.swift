//
//  FavoritesViewController.swift
//  Fitness
//
//  Created by Joseph Fulgieri on 4/13/18.
//  Copyright © 2018 Keivan Shahida. All rights reserved.
//

import UIKit
import SnapKit

class FavoritesViewController: UITableViewController {

    // MARK: - INITIALIZATION
    var titleLabel: UILabel!
    var navigationBackgroundView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        //NAVIGATION BAR
        navigationController?.navigationBar.clipsToBounds = false
        additionalSafeAreaInsets.top = 76

        navigationBackgroundView = UIView()
        navigationBackgroundView.backgroundColor = .white
        navigationController?.navigationBar.addSubview(navigationBackgroundView)

        titleLabel = UILabel()
        titleLabel.font = ._24MontserratBold
        titleLabel.textColor = .fitnessBlack
        titleLabel.text = "Favorites"
        navigationController?.navigationBar.addSubview(titleLabel)

        //TABLE VIEW
        tableView = UITableView(frame: .zero, style: .grouped)
        tableView.bounces = false
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .white

        tableView.register(FavoritesHeaderView.self, forHeaderFooterViewReuseIdentifier: FavoritesHeaderView.identifier)
        tableView.register(ClassListCell.self, forCellReuseIdentifier: ClassListCell.identifier)

        setupConstraints()
    }

    // MARK: - TABLEVIEW
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10 //temp
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ClassListCell.identifier, for: indexPath) as! ClassListCell
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 112
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: FavoritesHeaderView.identifier) as! FavoritesHeaderView
        return header
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 250
    }

    // MARK: - CONSTRAINTS
    func setupConstraints() {
        titleLabel.snp.updateConstraints {make in
            make.left.equalToSuperview().offset(24)
            make.top.equalToSuperview().offset(74)
            make.bottom.equalTo(titleLabel.snp.top).offset(26)
        }

        navigationBackgroundView.snp.updateConstraints {make in
            make.top.equalToSuperview().offset(-21)
            make.right.equalToSuperview()
            make.left.equalToSuperview()
            make.bottom.equalTo(titleLabel.snp.bottom).offset(20)
        }
    }
}
