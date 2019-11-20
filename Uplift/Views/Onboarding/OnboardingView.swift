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

    // MARK: - Public vars
    var favorites: [String] = [] // User's selected favorite gyms/classes

    init(image: UIImage, text: String, gymNames: [String]? = nil, classNames: [String]? = nil) {
        super.init(frame: .zero)
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        addSubview(imageView)

        titleLabel.attributedText = generateAttributedString(for: text)
        titleLabel.numberOfLines = 3
        addSubview(titleLabel)

        if let data = gymNames ?? classNames {
            tableData = data
            showingClasses = tableData == classNames

            tableView = UITableView(frame: .zero, style: .plain)
            tableView?.delegate = self
            tableView?.dataSource = self
            tableView?.register(FavoriteGymCell.self, forCellReuseIdentifier: FavoriteGymCell.identifier)
            tableView?.isScrollEnabled = false
            tableView?.separatorStyle = .none
            tableView?.clipsToBounds = false
            self.addSubview(tableView!)
        }

        setUpConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUpConstraints() {

        let labelSideOffset: CGFloat = 37

        imageView.snp.makeConstraints { make in
            make.size.equalTo(imageView.image?.size ?? CGSize(width: 0, height: 0))
            make.top.centerX.equalToSuperview()
        }

        if let table = tableView { // With Table View

            let labelTopOffset: CGFloat = 187.2
            let labelHeight: CGFloat = 78

            let tableViewLeadingInset: CGFloat = 13
            let tableViewTrailingInset: CGFloat = 14
            let tableViewBottomOffset: CGFloat = 19
            let tableViewHeight: CGFloat = 282 // 4 Cells

            titleLabel.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.leading.trailing.equalToSuperview().inset(labelSideOffset)
                make.top.equalToSuperview().inset(labelTopOffset)
                make.height.equalTo(labelHeight)
            }

            table.snp.makeConstraints { make in
                make.top.equalTo(titleLabel.snp.bottom).offset(tableViewBottomOffset)
                make.leading.equalToSuperview().inset(tableViewLeadingInset)
                make.trailing.equalToSuperview().inset(tableViewTrailingInset)
                make.height.equalTo(tableViewHeight)
            }
        } else { // Without Table View
            let imageTextPadding: CGFloat = 20

            titleLabel.snp.makeConstraints { make in
                make.top.equalTo(imageView.snp.bottom).offset(imageTextPadding)
                make.leading.trailing.equalToSuperview().inset(labelSideOffset)
                make.centerX.equalToSuperview()
            }
        }
    }

    private func generateAttributedString(for string: String,
                                    color: UIColor = .primaryBlack) -> NSAttributedString {
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
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteGymCell.identifier, for: indexPath) as! FavoriteGymCell
        let gym = tableData?[indexPath.section] ?? ""
        cell.configure(with: gym, displaysClasses: showingClasses)
        cell.selectionStyle = .none
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return tableData?.count ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

}

extension OnboardingView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard
            let cell = tableView.cellForRow(at: indexPath) as? FavoriteGymCell,
            let data = tableData
        else { return }

        cell.toggleSelectedView(selected: !cell.isOn)

        if cell.isOn {
            favorites.append(data[indexPath.section])
        } else {
            favorites.removeAll { $0 == data[indexPath.section] }
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableViewCellHeight
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableViewCellSpacing
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let blankView = UIView()
        blankView.backgroundColor = .clear
        return blankView
    }

}

