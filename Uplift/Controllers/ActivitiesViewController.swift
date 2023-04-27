//
//  ActivitesViewController.swift
//  Uplift
//
//  Created by Elvis Marcelo on 4/26/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import Foundation
import UIKit
import SnapKit


class ActivitesViewController: UIViewController {

    private let headerView = ActivitesScreenHeaderView()
    var activitiesCollectionView: UICollectionView!
    var filterButton = UIButton()
    var activities = activityList.activites

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupViews()
        setupConstraints()
    }

    func setupViews() {
        headerView.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        headerView.layer.shadowOpacity = 0.4
        headerView.layer.shadowRadius = 10.0
        headerView.layer.shadowColor = UIColor.buttonShadow.cgColor
        headerView.layer.masksToBounds = false
        view.addSubview(headerView)

        let activitiesFlowLayout = UICollectionViewFlowLayout()
        activitiesFlowLayout.scrollDirection = .vertical
        activitiesFlowLayout.minimumInteritemSpacing = 150
        activitiesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: activitiesFlowLayout)

        activitiesCollectionView.register(ActivityCollectionViewCell.self, forCellWithReuseIdentifier: Identifiers.activitesReuseIdentifier)
        activitiesCollectionView.delegate = self
        activitiesCollectionView.dataSource = self
        view.addSubview(activitiesCollectionView)

        filterButton.setTitle("FILTER", for: .normal)
        filterButton.titleLabel?.font = ._16MontserratBold
        filterButton.setTitleColor(.black, for: .normal)
        filterButton.layer.shadowColor = UIColor.buttonShadow.cgColor
        filterButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        filterButton.layer.shadowRadius = 4
        filterButton.backgroundColor = .white
        filterButton.layer.cornerRadius = 20
        filterButton.layer.shadowOpacity = 1
        view.addSubview(filterButton)
    }

    func setupConstraints() {
        let bottomPadding = -100
        let headerViewHeight = 120
        let filterWidth = 100
        let filterHeight = 41
        let filterPadding = 15

        headerView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(headerViewHeight)
        }

        activitiesCollectionView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(headerView.snp.bottom)
            make.bottom.equalToSuperview().offset(bottomPadding)
        }

        filterButton.snp.makeConstraints { make in
            make.top.equalTo(activitiesCollectionView.snp.bottom).offset(filterPadding)
            make.width.equalTo(filterWidth)
            make.height.equalTo(filterHeight)
            make.centerX.equalToSuperview()
        }
    }

}

extension ActivitesViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 10
        return CGSize(width: (collectionView.bounds.width - padding*2), height: 60)
    }

    //SPACING BETWEEN ROWS
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
}

extension ActivitesViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        activities.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.activitesReuseIdentifier, for: indexPath) as? ActivityCollectionViewCell {
            cell.configure(for: activities[indexPath.item])
            return cell
        }
        else {
            return ActivityCollectionViewCell()
        }
    }

}
