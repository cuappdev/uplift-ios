//
//  SportsFilterViewController.swift
//  Uplift
//
//  Created by Artesia Ko on 4/11/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import SnapKit
import UIKit

protocol SportsFilterDelegate: class {

    func filterOptions(params: SportsFilterParameters?)

}

class SportsFilterViewController: UIViewController {

    private let filterSections: [SportsFilterSection] = [.gym, .startTime, .numPlayers, .sports]

    private var filterOptionsCollectionView: UICollectionView!

    weak var delegate: SportsFilterDelegate?

    var selectedSports: [String] = []
    var sportsTypeDropdownData: DropdownData!

    init(currentFilterParams: SportsFilterParameters?) {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        view.backgroundColor = .white

        // NAVIGATION BAR
        setupNavBar()

        let layout = UICollectionViewFlowLayout()
        filterOptionsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        filterOptionsCollectionView.register(SportsFilterGymCollectionViewCell.self, forCellWithReuseIdentifier: Identifiers.sportsFilterGymCell)
        filterOptionsCollectionView.register(SportsFilterStartTimeCollectionViewCell.self, forCellWithReuseIdentifier: Identifiers.sportsFilterStartTimeCell)
        filterOptionsCollectionView.register(SportsFilterNumPlayersCollectionViewCell.self, forCellWithReuseIdentifier: Identifiers.sportsFilterNumPlayersCell)
        filterOptionsCollectionView.register(SportsFilterSportsDropdownCollectionViewCell.self, forCellWithReuseIdentifier: Identifiers.sportsFilterSportsDropdownCell)
        filterOptionsCollectionView.delegate = self
        filterOptionsCollectionView.dataSource = self
        filterOptionsCollectionView.backgroundColor = .clear
        view.addSubview(filterOptionsCollectionView)

        setupConstraints()

        sportsTypeDropdownData = DropdownData(completed: false, dropStatus: .closed, titles: [])

        // TODO: replace with networked sports.
        let sportsNames = ["Basketball", "Soccer", "Table Tennis", "Frisbee", "A", "B", "C"]
        sportsTypeDropdownData.titles.append(contentsOf: sportsNames)
        sportsTypeDropdownData.completed = true
    }

    func setupNavBar() {
        let titleView = UILabel()
        titleView.text = ClientStrings.Filter.vcTitleLabel
        titleView.font = ._14MontserratBold
        self.navigationItem.titleView = titleView

        // Color Navigation Bar White if Dark Mode
        if #available(iOS 13, *) {
            navigationItem.standardAppearance = .init()
            navigationItem.compactAppearance = .init()
            navigationItem.compactAppearance?.backgroundColor = .primaryWhite
            navigationItem.standardAppearance?.backgroundColor = .primaryWhite
            titleView.textColor = .primaryBlack
        }

        let doneBarButton = UIBarButtonItem(title: ClientStrings.Filter.doneButton, style: .plain, target: self, action: #selector(done))
        doneBarButton.tintColor = .primaryBlack
        doneBarButton.setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont._14MontserratMedium as Any
        ], for: .normal)
        self.navigationItem.rightBarButtonItem = doneBarButton

        let resetBarButton = UIBarButtonItem(title: ClientStrings.Filter.resetButton, style: .plain, target: self, action: #selector(reset))
        resetBarButton.tintColor = .primaryBlack
        resetBarButton.setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont._14MontserratMedium as Any
        ], for: .normal)
        self.navigationItem.leftBarButtonItem = resetBarButton
    }

    @objc func done() {
        dismiss(animated: true, completion: nil)
        // TODO - call delegate and networking functions to perform the search
    }

    @objc func reset() {
        dismiss(animated: true, completion: nil)
    }

    func setupConstraints() {
        filterOptionsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}

extension SportsFilterViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterSections.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch filterSections[indexPath.row] {
        case .gym:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.sportsFilterGymCell, for: indexPath) as! SportsFilterGymCollectionViewCell
            return cell
        case .startTime:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.sportsFilterStartTimeCell, for: indexPath) as! SportsFilterStartTimeCollectionViewCell
            return cell
        case .numPlayers:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.sportsFilterNumPlayersCell, for: indexPath) as! SportsFilterNumPlayersCollectionViewCell
            return cell
        case .sports:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.sportsFilterSportsDropdownCell, for: indexPath) as! SportsFilterSportsDropdownCollectionViewCell
            cell.dropdownDelegate = self
            cell.configure(for: sportsTypeDropdownData, dropdownDelegate: self, selectedSports: selectedSports)
            return cell
        }
    }

}

extension SportsFilterViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        var height: CGFloat = 0
        switch filterSections[indexPath.row] {
        case .gym:
            height = SportsFilterGymCollectionViewCell.height
        case .startTime:
            height = SportsFilterStartTimeCollectionViewCell.height
        case .numPlayers:
            height = SportsFilterNumPlayersCollectionViewCell.height
        case .sports:
            if let cell = collectionView.cellForItem(at: indexPath) as? SportsFilterSportsDropdownCollectionViewCell {
                height = cell.getDropdownHeight()
            } else {
                height = SportsFilterSportsDropdownCollectionViewCell.initialHeight
            }
        }
        return CGSize(width: width, height: height)
    }

}

extension SportsFilterViewController: DropdownViewDelegate {

    func dropdownStatusChanged(to status: DropdownStatus, with height: CGFloat) {
        sportsTypeDropdownData.dropStatus = status
        (0..<filterSections.count).forEach { index in
            if filterSections[index] == .sports {
                let indexPath = IndexPath(item: index, section: 0)
                if let cell = filterOptionsCollectionView.cellForItem(at: indexPath) as? SportsFilterSportsDropdownCollectionViewCell {
                    selectedSports = cell.getSelectedSports()
                }
                UIView.performWithoutAnimation {
                    filterOptionsCollectionView.reloadItems(at: [indexPath])
                }
            }
        }
    }

}
