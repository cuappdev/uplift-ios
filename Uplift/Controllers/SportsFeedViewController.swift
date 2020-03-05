//
//  SportsFeedViewController.swift
//  Uplift
//
//  Created by Cameron Hamidi on 2/15/20.
//  Copyright © 2020 Cornell AppDev. All rights reserved.
//

import SnapKit
import UIKit

protocol GameStatusDelegate: class {
    func didChangeStatus(id: Int, status: GameStatus)
}

class SportsFeedViewController: UIViewController {

    private let headerView = SportsFeedHeaderView()
    private var calendarCollectionView: UICollectionView!
    private var collectionView: UICollectionView!
    
    private var posts: [[Post]] = Array.init(repeating: [], count: 10)
    private var filteredPosts: [Post] = []
    private let sportIdentifier = "sportIdentifier"
    
    // MARK: - Calendar data vars
    private var calendarDatesList: [Date] = CalendarGenerator.getCalendarDates()
    private var calendarDateSelected: Date = CalendarGenerator.currDate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        setupConstraints()
        getSportsFor(date: calendarDateSelected)
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
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarGenerator.calendarCellIdentifier, for: indexPath) as! CalendarCell
            let dateForCell = calendarDatesList[indexPath.item]
            let dayOfWeek = CalendarGenerator.cal.component(.weekday, from: dateForCell) - 1
            let dayOfMonth = CalendarGenerator.cal.component(.day, from: dateForCell)

            var dateLabelCircleIsHidden = true
            var dateLabelFont = UIFont._12MontserratRegular
            var dateLabelTextColor: UIColor?
            var dayOfWeekLabelFont = UIFont._12MontserratRegular
            var dayOfWeekLabelTextColor: UIColor?

            if dateForCell < CalendarGenerator.currDate {
                dateLabelTextColor = .gray02
                dayOfWeekLabelTextColor = .gray02
            }

            if dateForCell == calendarDateSelected {
                dateLabelCircleIsHidden = false
                dateLabelFont = ._12MontserratBold
                dateLabelTextColor = .primaryBlack
                dayOfWeekLabelFont = ._12MontserratBold
                dayOfWeekLabelTextColor = .primaryBlack
            }

            cell.configure(for: "\(dayOfMonth)",
                dateLabelTextColor: dateLabelTextColor,
                dateLabelFont: dateLabelFont!,
                dayOfWeekLabelText: CalendarGenerator.daysOfWeek[dayOfWeek],
                dayOfWeekLabelTextColor: dayOfWeekLabelTextColor,
                dayOfWeekLabelFont: dayOfWeekLabelFont!,
                dateLabelCircleIsHidden: dateLabelCircleIsHidden
            )
            return cell
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
