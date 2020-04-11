//
//  SportsFeedViewController.swift
//  Uplift
//
//  Created by Cameron Hamidi on 2/15/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import SnapKit
import UIKit

struct SportsFilterParameters {
    var endTime: Date
    var gymIds: [String]
    var maxPlayers: Int
    var minPlayers: Int
    var shouldFilter: Bool
    var sportsNames: [String]
    var startTime: Date
    var tags: [String]

    init(endTime: Date = Date(),
         gymIds: [String] = [],
         maxPlayers: Int = 10,
         minPlayers: Int = 2,
         shouldFilter: Bool = false,
         sportsNames: [String] = [],
         startTime: Date = Date(),
         tags: [String] = []) {
        self.endTime = endTime
        self.gymIds = gymIds
        self.maxPlayers = maxPlayers
        self.minPlayers = minPlayers
        self.shouldFilter = shouldFilter
        self.sportsNames = sportsNames
        self.startTime = startTime
        self.tags = tags
    }
}

protocol GameStatusDelegate: class {
    func didChangeStatus(id: Int, status: GameStatus)
}

class SportsFeedViewController: UIViewController {
    
    private var calendarCollectionView: UICollectionView!
    private var collectionView: UICollectionView!
    private var filterButton: UIButton!
    private let headerView = SportsFeedHeaderView()
    
    private var currentFilterParams: SportsFilterParameters?
    
    private var posts: [[Post]] = Array.init(repeating: [], count: 10)
    private let sportIdentifier = "sportIdentifier"
    
    // MARK: - Calendar data vars
    private var calendarDatesList: [Date] = CalendarGenerator.getCalendarDates()
    lazy private var calendarDateSelected: Date = {
        return currDate
    }()
    
    private var currDate: Date!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currDate = calendarDatesList[3]
        
        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true

        headerView.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        headerView.layer.shadowOpacity = 0.4
        headerView.layer.shadowRadius = 10.0
        headerView.layer.shadowColor = UIColor.buttonShadow.cgColor
        headerView.layer.masksToBounds = false
        view.addSubview(headerView)
        
        // Fill with dummy data for now.
        posts = [[], [], [], [
            Post(comment: [], createdAt: Date(), id: 0, userId: 0, title: "Zain's Basketball Game", time: "5:00 PM", type: "Basketball", location: "Noyes Recreation Center", players: 10, gameStatus: "JOINED"),
            Post(comment: [], createdAt: Date(), id: 1, userId: 0, title: "Sports With Zain", time: "7:00 PM", type: "Soccer", location: "Zain's Backyard", players: 2, gameStatus: "CREATED"),
            Post(comment: [], createdAt: Date(), id: 2, userId: 0, title: "Open Game with Zain", time: "4:00 PM", type: "Tennis", location: "Zain's Tennis Court", players: 0, gameStatus: "OPEN")
        ], [], [], [], [], [], []]
        
        let calendarFlowLayout = CalendarGenerator.getCalendarFlowLayout()
        
        calendarCollectionView = UICollectionView(frame: .zero, collectionViewLayout: calendarFlowLayout)
        calendarCollectionView.delegate = self
        calendarCollectionView.dataSource = self
        calendarCollectionView.showsHorizontalScrollIndicator = false
        calendarCollectionView.backgroundColor = .white
        calendarCollectionView.register(CalendarCell.self, forCellWithReuseIdentifier: CalendarGenerator.calendarCellIdentifier)
        calendarCollectionView.layer.zPosition = -1
        view.addSubview(calendarCollectionView)
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 12.0
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 32.0, height: 100.0)
        layout.sectionInset = .init(top: 0.0, left: 16.0, bottom: 0.0, right: 16.0)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(PickupGameCell.self, forCellWithReuseIdentifier: sportIdentifier)
        view.addSubview(collectionView)
        
        filterButton = UIButton()
        filterButton.setTitle(ClientStrings.Filter.applyFilterLabel, for: .normal)
        filterButton.titleLabel?.font = ._14MontserratBold
        filterButton.layer.cornerRadius = 24.0
        filterButton.setTitleColor(.black, for: .normal)
        filterButton.backgroundColor = .primaryWhite
        filterButton.addTarget(self, action: #selector(filterPressed), for: .touchUpInside)
        filterButton.layer.shadowColor = UIColor.buttonShadow.cgColor
        filterButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        filterButton.layer.shadowRadius = 4.0
        filterButton.layer.shadowOpacity = 1.0
        filterButton.layer.masksToBounds = false
        view.addSubview(filterButton)
        
        setupConstraints()
        getSportsFor(date: calendarDateSelected)
    }

    private func setupConstraints() {
        let calendarCollectionViewHeight = 47
        let calendarCollectionViewTopPadding = 40
        let filterButtonBottomPadding = 18
        let filterButtonSize = CGSize(width: 164, height: 46)
        let headerViewHeight = 120
        let sportCollectionViewTopPadding = 18

        headerView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(headerViewHeight)
        }
        calendarCollectionView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
                .offset(calendarCollectionViewTopPadding)
            make.height.equalTo(calendarCollectionViewHeight)
            make.leading.trailing.equalToSuperview()
        }
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(calendarCollectionView.snp.bottom).offset(sportCollectionViewTopPadding)
        }
        filterButton.snp.makeConstraints { make in
            make.size.equalTo(filterButtonSize)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(filterButtonBottomPadding)
            make.centerX.equalToSuperview()
        }
    }
    
    private func getSportsFor(date: Date) {
        // TODO: Filter posts.
        self.collectionView.reloadData()
    }
}

extension SportsFeedViewController: SportsFilterDelegate {
    @objc func filterPressed() {
        let filterVC = SportsFilterViewController(currentFilterParams: currentFilterParams)
        filterVC.delegate = self
        let filterNavController = UINavigationController(rootViewController: filterVC)
        tabBarController?.present(filterNavController, animated: true, completion: nil)
    }
    
    func filterOptions(params: SportsFilterParameters) {
        // TODO
    }
}

extension SportsFeedViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView {
            guard let indexOfSelectedDate = calendarDatesList.firstIndex(of: calendarDateSelected) else { return 0 }
            
            let selectedDaysSports = posts[indexOfSelectedDate]
            
            return selectedDaysSports.count
        }
        if collectionView == calendarCollectionView {
            return calendarDatesList.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == calendarCollectionView {
            return CalendarGenerator.getCalendarCell(collectionView, indexPath: indexPath, calendarDatesList: calendarDatesList, currDate: currDate, calendarDateSelected: calendarDateSelected)
        }

        guard let index = calendarDatesList.firstIndex(of: calendarDateSelected) else { return UICollectionViewCell() }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: sportIdentifier, for: indexPath) as! PickupGameCell
        let post = posts[index][indexPath.item]
        cell.configure(post: post)
        cell.gameStatusDelegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == calendarCollectionView {
            calendarDateSelected = calendarDatesList[indexPath.item]
            calendarCollectionView.reloadData()
            getSportsFor(date: calendarDateSelected)
        } else if collectionView == self.collectionView {
            guard let index = calendarDatesList.firstIndex(of: calendarDateSelected) else { return }
            let sportsDetailView = SportsDetailViewController(post: posts[index][indexPath.item])
            self.navigationController?.pushViewController(sportsDetailView, animated: true)
        }
    }
}

extension SportsFeedViewController: GameStatusDelegate {
    func didChangeStatus(id: Int, status: GameStatus) {
        // TODO: perform network request and update collection view.
    }
}
