//
//  HomeViewController.swift
//  Uplift
//
//  Created by Kevin Chan on 5/19/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import Alamofire
import AppDevAnnouncements
import SkeletonView
import SnapKit
import UIKit

class HomeViewController: UIViewController {

    // MARK: - Private view vars
    private var collectionView: UICollectionView!
    private let headerView = HomeScreenHeaderView()
    private let loadingHeader = LoadingHeaderView(frame: .zero)
    private var loadingScrollView: LoadingScrollView!

    // MARK: - Public data vars
    var sections: [SectionType] = []

    // MARK: - Private data vars
    private var gymLocations: [Int: String] = [:]
    private var numPendingNetworkRequests = 0

    enum Constants {
        static let gymsListCellIdentifier = "gymsListCellIdentifier"
        // TODO: - Add back other sections
//        static let todaysClassesListCellIdentifier = "todaysClassesListCellIdentifier"
//        static let todaysClassesEmptyCellIdentifier = "todaysClassesEmptyCellIdentifier"
//        static let activitiesListCellIdentifier = "activitiesListCellIdentifier"
    }

    // MARK: - Enums
    enum SectionType: String {
        // TODO: - Add back other sections
//        case todaysClasses = "Today's classes"
//        case yourActivities = "Your Activities"
        case fitnessCenters = "Gyms"
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // TODO: - Add back other sections
        sections = [.fitnessCenters]

        view.backgroundColor = UIColor.primaryWhite

        NotificationCenter.default.addObserver(self, selector: #selector(reloadUpliftData), name: Notification.Name.upliftFitnessCentersLoadedNotification, object: nil)

        setupViews()
        setupConstraints()

        reloadUpliftData()
        presentAnnouncement(completion: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.tabBarController?.tabBar.isHidden = false
    }

    @objc func reloadUpliftData() {
        guard FitnessCenterManager.shared.numFitnessCenters > 0 else { return }
        collectionView.reloadData()
        self.loadingHeader.isHidden = true
        self.loadingScrollView.isHidden = true
    }
}

// MARK: - Layout
extension HomeViewController {

    private func setupViews() {
        headerView.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        headerView.layer.shadowOpacity = 0.4
        headerView.layer.shadowRadius = 10.0
        headerView.layer.shadowColor = UIColor.buttonShadow.cgColor
        headerView.layer.masksToBounds = false

        view.addSubview(headerView)

        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 6.0
        flowLayout.minimumLineSpacing = 12.0

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.contentInset = UIEdgeInsets(top: 11, left: 0, bottom: 0, right: 0)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        collectionView.delaysContentTouches = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.layer.zPosition = -1

        collectionView.register(HomeSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HomeSectionHeaderView.identifier)

        // TODO: - Add back other sections
//        collectionView.register(TodaysClassesListCell.self, forCellWithReuseIdentifier: Constants.todaysClassesListCellIdentifier)
//        collectionView.register(TodaysClassesEmptyCell.self, forCellWithReuseIdentifier: Constants.todaysClassesEmptyCellIdentifier)
//        collectionView.register(ActivitiesListCell.self, forCellWithReuseIdentifier: Constants.activitiesListCellIdentifier)
        collectionView.register(GymsListCell.self, forCellWithReuseIdentifier: Constants.gymsListCellIdentifier)

        view.addSubview(collectionView)

        view.addSubview(loadingHeader)

        loadingScrollView = LoadingScrollView(frame: .zero, collectionViewWidth: view.bounds.width)
        view.addSubview(loadingScrollView)
    }

    private func setupConstraints() {
        let headerViewHeight = 120

        headerView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(headerViewHeight)
        }

        collectionView.snp.makeConstraints { make in
            make.centerX.width.bottom.equalToSuperview()
            make.top.equalTo(headerView.snp.bottom)
        }

        loadingHeader.snp.makeConstraints { make in
            make.edges.equalTo(headerView)
        }

        loadingScrollView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(headerView.snp.bottom)
        }
    }

}
