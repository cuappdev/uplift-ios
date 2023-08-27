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
    var myGyms: [Gym] = []
    var gymClassInstances: [GymClassInstance] = []
    var gyms: [Gym] = []
    var habits: [Habit] = []
    var lookingForCategories: [Tag] = []
    var sections: [SectionType] = []
    var activities: [Activity] = []

    // MARK: - Private data vars
    private var gymLocations: [Int: String] = [:]
    private var numPendingNetworkRequests = 0

    enum Constants {
        static let gymsListCellIdentifier = "gymsListCellIdentifier"
        static let todaysClassesListCellIdentifier = "todaysClassesListCellIdentifier"
        static let todaysClassesEmptyCellIdentifier = "todaysClassesEmptyCellIdentifier"
        static let activitiesListCellIdentifier = "activitiesListCellIdentifier"
    }

    // MARK: - Enums
    enum SectionType: String {
        case todaysClasses = "Today's classes"
        case yourActivities = "Your Activities"
        case myGyms = "Gyms"
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // MARK: removed .lookingFor
        sections = [.todaysClasses, .yourActivities, .myGyms]
        
        activities = [Activity(name: "Lifting", image: ActivitiesImages.lifting),
                  Activity(name: "Basketball", image: ActivitiesImages.basketball),
                  Activity(name: "Bowling", image: ActivitiesImages.bowling),
                  Activity(name: "Swimming", image: ActivitiesImages.swimming),
                  Activity(name: "Lifting", image: ActivitiesImages.lifting),
                  Activity(name: "Basketball", image: ActivitiesImages.basketball)]

        view.backgroundColor = UIColor.primaryWhite

        setupViews()
        setupConstraints()

        // Get Gyms
            /*
        numPendingNetworkRequests += 1
        NetworkManager.shared.getGyms { gyms in
            self.gyms = gyms.sorted { $0.isOpen && !$1.isOpen }
            let gymNames = UserDefaults.standard.stringArray(forKey: Identifiers.favoriteGyms) ?? []
            self.updateFavorites(favorites: gymNames)
            // Reload All Gyms section
            self.collectionView.reloadSections(IndexSet(integer: 2))
            self.decrementNumPendingNetworkRequests()
        }*/

        // Get Today's Classes
        let stringDate = Date.getNowString()
        /*
        numPendingNetworkRequests += 1
        NetworkManager.shared.getGymClassesForDate(date: stringDate, completion: { (gymClassInstances) in
            self.gymClassInstances = gymClassInstances.sorted { (first, second) in
                return first.startTime < second.startTime
            }

            // Reload Today's Classes section
            self.collectionView.reloadSections(IndexSet(integer: 0))
            self.decrementNumPendingNetworkRequests()
        })
         */
        
        
        // These are dummy test data for dev and to test cancelled classes
        
//        var testGym1 = GymClassInstance(classDescription: "Testinggg", classDetailId: "ASDF", className: "asdfasdf", duration: 60, endTime: Date(timeIntervalSinceNow: TimeInterval(integerLiteral: 60)), gymId: "ud", imageURL: URL(string: "asdf")!, instructor: "Instructio", isCancelled: true, location: "Noyes", startTime: Date(timeIntervalSinceNow: TimeInterval(integerLiteral: 0)), tags: [])
//        
//        var testGym2 = GymClassInstance(classDescription: "Testinggg", classDetailId: "ASDF", className: "asdfasdf", duration: 60, endTime: Date(timeIntervalSinceNow: TimeInterval(integerLiteral: 60)), gymId: "ud", imageURL: URL(string: "asdf")!, instructor: "Instructio", isCancelled: false, location: "Noyes", startTime: Date(timeIntervalSinceNow: TimeInterval(integerLiteral: 0)), tags: [])
//        
//        var testGym3 = GymClassInstance(classDescription: "Testinggg", classDetailId: "ASDF", className: "asdfasdf", duration: 60, endTime: Date(timeIntervalSinceNow: TimeInterval(integerLiteral: 60)), gymId: "ud", imageURL: URL(string: "asdf")!, instructor: "Instructio", isCancelled: false, location: "Noyes", startTime: Date(timeIntervalSinceNow: TimeInterval(integerLiteral: 0)), tags: [])
//        self.gymClassInstances = [testGym1, testGym2, testGym3]

        presentAnnouncement(completion: nil)
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

    func decrementNumPendingNetworkRequests() {
        self.numPendingNetworkRequests -= 1
        if self.numPendingNetworkRequests == 0 {
            self.loadingHeader.isHidden = true
            self.loadingScrollView.isHidden = true
        }
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
        collectionView.register(TodaysClassesListCell.self, forCellWithReuseIdentifier: Constants.todaysClassesListCellIdentifier)
        collectionView.register(TodaysClassesEmptyCell.self, forCellWithReuseIdentifier: Constants.todaysClassesEmptyCellIdentifier)
        collectionView.register(ActivitiesListCell.self, forCellWithReuseIdentifier: Constants.activitiesListCellIdentifier)
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
