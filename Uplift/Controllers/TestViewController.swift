//
//  TestViewController.swift
//  Uplift
//
//  Created by Yana Sang on 11/10/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {

    var collectionView: UICollectionView!
    var gym: Gym!
    var selectedDayIndex: Int = Calendar.current.component(.weekday, from: Date()) - 1
    var calendarCellHeight: CGFloat = 500

    init(gym: Gym) {
        self.gym = gym
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .blue

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(GymDetailCalendarView.self, forCellWithReuseIdentifier: "calendar")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .accentTurquoise
        view.addSubview(collectionView)

        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

}

extension TestViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "calendar", for: indexPath) as! GymDetailCalendarView
//        let facilityDetail = gym.facilities[4].details[0] // Helen Newman
        let facilityDetail = gym.facilities[1].details[0]
        cell.configure(facilityDetail: facilityDetail, dayIndex: selectedDayIndex) { newHeight, newDayIndex in
            guard self.calendarCellHeight != newHeight else {
                return
            }
            self.calendarCellHeight = newHeight
            self.selectedDayIndex = newDayIndex

            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }

        return cell
    }

}

extension TestViewController: UICollectionViewDelegate {

}

extension TestViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width
        return CGSize(width: width, height: calendarCellHeight)
    }
}
