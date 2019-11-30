//
//  OnboardingView.swift
//  Uplift
//
//  Created by Phillip OReggio on 11/18/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import UIKit

class OnboardingView: UIView {

    // MARK: - Private vars
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private var tableView: UITableView?

    private var tableData: [String]?
    private var showingClasses = false

    private let tableViewCellHeight: CGFloat = 60
    private let tableViewCellSpacing: CGFloat = 14

    // MARK: = Delegation
    var favoritesSelectedDelegate: (([String]) -> Void)?

    // MARK: - Public vars
    var favorites: [String] = [] // User's selected favorite gyms/classes
    var hasTableView = false

    init(image: UIImage?, text: String, gymNames: [String]? = nil, classNames: [String]? = nil) {
        super.init(frame: .zero)

        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        addSubview(imageView)

        titleLabel.attributedText = generateAttributedString(for: text)
        titleLabel.numberOfLines = 3
        addSubview(titleLabel)

        if let data = gymNames ?? classNames {
            hasTableView = true
            tableData = data
            showingClasses = tableData == classNames

            let tableView = UITableView(frame: .zero, style: .plain)
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(FavoriteCell.self, forCellReuseIdentifier: FavoriteCell.identifier)
            tableView.isScrollEnabled = false
            tableView.clipsToBounds = false
            tableView.separatorStyle = .none
            self.tableView = tableView
            self.addSubview(tableView)
        }

        setUpConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func getSize() -> CGSize {
        let width = 388
        return hasTableView ?
            CGSize(width: width, height: 700) :
            CGSize(width: width, height: 269)
    }

    private func setUpConstraints() {
        let imageSize = hasTableView ? CGSize(width: 214, height: 183) : CGSize(width: 295, height: 222.3)
        let labelWidth: CGFloat = 301

        imageView.snp.makeConstraints { make in
            make.size.equalTo(imageSize)
            make.top.centerX.equalToSuperview()
        }

        if let table = tableView { // With Table View
            let labelHeight: CGFloat = 80
            let labelTopOffset: CGFloat = 174

            let tableViewBottomOffset: CGFloat = 17
            let tableViewSize = CGSize(width: 388, height: 308)

            titleLabel.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.width.equalTo(labelWidth)
                make.height.equalTo(labelHeight)
                make.top.equalToSuperview().inset(labelTopOffset)
            }

            table.snp.makeConstraints { make in
                make.top.equalTo(titleLabel.snp.bottom).offset(tableViewBottomOffset)
                make.size.equalTo(tableViewSize)
                make.centerX.equalTo(titleLabel)
            }
        } else { // Without Table View
            let imageTextPadding: CGFloat = 20

            titleLabel.snp.makeConstraints { make in
                make.top.equalTo(imageView.snp.bottom).offset(imageTextPadding)
                make.width.equalTo(labelWidth)
                make.centerX.equalToSuperview()
            }
        }
    }

    private func generateAttributedString(
        for string: String,
        color: UIColor = .primaryBlack
    ) -> NSAttributedString {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 3
        style.alignment = .center
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont._20MontserratBold!,
            .paragraphStyle: style,
            .foregroundColor: color
        ]

        return NSAttributedString(string: string, attributes: attributes)
    }
}

extension OnboardingView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteCell.identifier, for: indexPath) as? FavoriteCell else { return UITableViewCell() }
        let data = tableData?[indexPath.section] ?? ""
        cell.configure(with: data, displaysClasses: showingClasses)
        cell.selectionStyle = .none
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

}

extension OnboardingView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard
            let cell = tableView.cellForRow(at: indexPath) as? FavoriteCell,
            let data = tableData
        else { return }

        cell.toggleSelectedView(selected: !cell.currentlySelected)

        if cell.currentlySelected {
            favorites.append(data[indexPath.section])
        } else {
            favorites.removeAll { $0 == data[indexPath.section] }
        }

        favoritesSelectedDelegate?(favorites)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableViewCellHeight
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableViewCellSpacing
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }

}
