//
//  HomeViewController.swift
//  Uplift
//
//  Created by Kevin Chan on 5/19/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import Alamofire
import Crashlytics
import SnapKit
import UIKit

class HomeViewController: UIViewController {

    // MARK: - Private view vars
    private var collectionView: UICollectionView!
    private let headerView = HomeScreenHeaderView()

    // MARK: - Public data vars
    var favoriteGyms: [Gym] = []
    var gymClassInstances: [GymClassInstance] = []
    var gyms: [Gym] = []
    var habits: [Habit] = []
    let pros = ProBio.getAllPros()
    var sections: [SectionType] = []

    // MARK: - Private data vars
    private var gymLocations: [Int: String] = [:]

    enum Constants {
        static let checkInsListCellIdentifier = "checkInsListCellIdentifier"
        static let gymsListCellIdentifier = "gymsListCellIdentifier"
        static let todaysClassesListCellIdentifier = "todaysClassesListCellIdentifier"
        static let prosListCellIdentifier = "prosListCellIdentifier"
    }

    // MARK: - Enums
    enum SectionType: String {
        case checkIns = "DAILY CHECK-INS"
        case allGyms = "ALL GYMS"
        case todaysClasses = "TODAY'S CLASSES"
        case pros = "LEARN FROM THE PROS"
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        sections = [.checkIns, .allGyms, .todaysClasses, .pros]

        view.backgroundColor = UIColor.fitnessWhite

        setupViews()
        setupConstraints()

        // Get Habits
        habits = Habit.getActiveHabits()
        // Reload Daily Check Ins section
        collectionView.reloadSections(IndexSet(integer: 0))

        // Get Gyms
        NetworkManager.shared.getGyms { gyms in
            self.gyms = gyms.sorted { $0.isOpen && !$1.isOpen }

            let gymNames = UserDefaults.standard.stringArray(forKey: Identifiers.favoriteGyms) ?? []
            self.updateFavorites(favorites: gymNames)

            // Reload All Gyms section
            self.collectionView.reloadSections(IndexSet(integer: 1))
        }

        // Get Today's Classes
        let stringDate = Date.getNowString()

        NetworkManager.shared.getGymClassesForDate(date: stringDate) { (gymClassInstances) in
            self.gymClassInstances = gymClassInstances.sorted { (first, second) in
                return first.startTime < second.startTime
            }
            // Reload Today's Classes section
            self.collectionView.reloadSections(IndexSet(integer: 2))
        }

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.tabBarController?.tabBar.isHidden = false

        let newHabits = Habit.getActiveHabits()
        if habits != newHabits {
            habits = newHabits
            collectionView.reloadSections(IndexSet(integer: 0))
        }
    }

}

// MARK: - Layout
extension HomeViewController {

    private func setupViews() {
        headerView.layer.shadowOffset = CGSize(width: 0.0, height: 9.0)
        headerView.layer.shadowOpacity = 0.25
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
        collectionView.register(HomeSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HomeSectionHeaderView.identifier)
        collectionView.register(CheckInsListCell.self, forCellWithReuseIdentifier: Constants.checkInsListCellIdentifier)
        collectionView.register(GymsListCell.self, forCellWithReuseIdentifier: Constants.gymsListCellIdentifier)
        collectionView.register(TodaysClassesListCell.self, forCellWithReuseIdentifier: Constants.todaysClassesListCellIdentifier)
        collectionView.register(ProsListCell.self, forCellWithReuseIdentifier: Constants.prosListCellIdentifier)
        view.addSubview(collectionView)
    }

    private func setupConstraints() {
        let collectionViewTopPadding = 12
        let headerViewHeight = 120

        headerView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(headerViewHeight)
        }

        collectionView.snp.makeConstraints { make in
            make.centerX.width.bottom.equalToSuperview()
            make.top.equalTo(headerView.snp.bottom).offset(collectionViewTopPadding)
        }
    }

}
