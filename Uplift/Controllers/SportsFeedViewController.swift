//
//  SportsFeedViewController.swift
//  Uplift
//
//  Created by Cameron Hamidi on 2/15/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import SideMenu
import SnapKit
import UIKit

protocol GameStatusDelegate: class {
    func didChangeStatus(id: Int, status: GameStatus)
}

class SportsFeedViewController: UIViewController {

    // MARK: - Views
    private let headerView = SportsFeedHeaderView()
    private let tintOverlay = UIView()

    private var calendarCollectionView: UICollectionView!
    private var collectionView: UICollectionView!
    private var sideMenu: SideMenuNavigationController!

    // MARK: - Calendar data vars
    private var calendarDatesList: [Date] = CalendarGenerator.getCalendarDates()
    lazy private var calendarDateSelected: Date = {
        return currDate
    }()
    private var currDate: Date!

    // MARK: - Other data
    private var posts: [[Post]] = Array.init(repeating: [], count: 10)

    var sideMenuWidth: CGFloat {
        return view.bounds.width * 320.0 / 375.0
    }

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
        headerView.profilePicPressed = {
            self.showProfileView()
        }
        view.addSubview(headerView)
        
        // TODO: Get rid of dummy data. This is temporary for testing purposes.
        let userZain = User(id: "0", name: "Zain Khoja", netId: "netId00", givenName: "Zain", familyName: "Khoja", email: "zk@uplift.com")
        let userYiHsin = User(id: "1", name: "Yi Hsin Wei", netId: "netId01", givenName: "Yi Hsin", familyName: "Wei", email: "ysw@uplift.com")
        let userWill = User(id: "2", name: "Will Bai", netId: "netId02", givenName: "Will", familyName: "Bai", email: "wb@uplift.com")
        let userAmanda = User(id: "3", name: "Amanda He", netId: "netId03", givenName: "Amanda", familyName: "He", email: "ah@uplift.com")
        let userYanlam = User(id: "4", name: "Yanlam Ko", netId: "netId04", givenName: "Yanlam", familyName: "Ko", email: "yk@uplift.com")
        let userCameron = User(id: "5", name: "Cameron Hamidi", netId: "netId05", givenName: "Cameron", familyName: "Hamidi", email: "ch@uplift.com")
        
        let comment1 = Comment(createdAt: Date(timeIntervalSince1970: 789), id: 0, postId: 0, text: "Hello World", userId: 1)
        let comment2 = Comment(createdAt: Date(timeIntervalSinceNow: -10), id: 1, postId: 1, text: "Hey, I have a meeting at 2PM. Can we push the game to 5?", userId: 2)
        let comment3 = Comment(createdAt: Date(), id: 2, postId: 2, text: "laksdjf;lkajsd;flkajsd;lfkajsd;lfkjasd;lkfjads;lkfjal;sdkjfa;lsdkfja;lsdkfja;lsdkjfa;lsdkjf;laksdjfal;ksdjf;laskdjf;laksdjfl;askdjfa;lskdjfl;askdjfl;askdjf;laksdjf;lkajdl;fkajs;dkfja;sdklfja;lsdkjf;laksdjf;laksdjf;laksdjfl;kadjf;lakdsjfl;akjsdf;lkajd;lkfjal;dkjf", userId: 3)
        let comment4 = Comment(createdAt: Date(), id: 3, postId: 2, text: "Some string", userId: 3)
        
        let players = [userZain, userYiHsin, userWill, userAmanda, userYanlam, userCameron]
        
        posts = [[], [], [], [
            Post(comment: [comment1], createdAt: Date(), id: 0, userId: 0, title: "Zain's Basketball Game", time: Date(), type: "Basketball", location: "Noyes Recreation Center", players: [userZain, userYiHsin, userWill], gameStatus: "JOINED"),
            Post(comment: [comment2], createdAt: Date(), id: 1, userId: 0, title: "Sports With Zain", time: Date(), type: "Soccer", location: "Zain's Backyard", players: [userZain, userCameron], gameStatus: "CREATED"),
            Post(comment: [comment3, comment4], createdAt: Date(), id: 2, userId: 1, title: "Open Game with Yi Hsin", time: Date(), type: "Tennis", location: "Zain's Tennis Court", players: [userZain, userYiHsin, userWill, userAmanda, userYanlam, userWill], gameStatus: "OPEN")
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
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 32.0, height: PickupGameCell.height)
        layout.sectionInset = .init(top: 0.0, left: 16.0, bottom: 0.0, right: 16.0)

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(PickupGameCell.self, forCellWithReuseIdentifier: Identifiers.pickupGameCell)
        view.addSubview(collectionView)

        sideMenu = SideMenuNavigationController(rootViewController: ProfileViewController(myGames: posts[3], joinedGames: posts[3], pastGames: posts[3]))
        sideMenu.leftSide = true
        sideMenu.menuWidth = sideMenuWidth
        sideMenu.statusBarEndAlpha = 0.0

        tintOverlay.backgroundColor = UIColor.gray04.withAlphaComponent(0.72)
        tintOverlay.isHidden = true
        view.addSubview(tintOverlay)

        setupConstraints()
        getSportsFor(date: calendarDateSelected)
    }

    func showProfileView() {
        present(sideMenu, animated: true)
    }

    private func setupConstraints() {
        let calendarCollectionViewHeight = 47
        let calendarCollectionViewTopPadding = 40
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
        
        tintOverlay.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func getSportsFor(date: Date) {
        // TODO: Filter posts.
        self.collectionView.reloadData()
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

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.pickupGameCell, for: indexPath) as! PickupGameCell
        let post = posts[index][indexPath.item]
        cell.configure(for: post)
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

extension SportsFeedViewController: SideMenuNavigationControllerDelegate {

    func sideMenuDidAppear(menu: SideMenuNavigationController, animated: Bool) {
        tintOverlay.isHidden = false
    }

    func sideMenuDidDisappear(menu: SideMenuNavigationController, animated: Bool) {
        tintOverlay.isHidden = true
    }

    func sideMenuWillAppear(menu: SideMenuNavigationController, animated: Bool) {
        tintOverlay.isHidden = false
    }

    func sideMenuWillDisappear(menu: SideMenuNavigationController, animated: Bool) {
        tintOverlay.isHidden = true
    }

}
