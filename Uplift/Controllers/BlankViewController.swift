//
//  BlankViewController.swift
//  Uplift
//
//  Created by Phillip OReggio on 11/3/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import UIKit

class BlankViewController: UIViewController {

    // Cell Info
    var facilityDetails: FacilityDetail!
    var gymHours: [DailyGymHours]!

    // Views
    var calendar: GymDetailWeekView!
    var collectionView: UICollectionView!
    let reuse = "b"

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray02

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 2
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 194)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(CourtView.self, forCellWithReuseIdentifier: reuse)
        collectionView.backgroundColor = .primaryWhite
        collectionView.dataSource = self

        NetworkManager.shared.getGym(id: GymIds.helenNewman) { gym in
            self.facilityDetails = gym.facilities[2].details.first!
            self.gymHours = gym.gymHours

            self.calendar = GymDetailWeekView()

            self.view.addSubview(self.calendar)
            self.view.addSubview(self.collectionView)
            self.setupConstraints()
        }
    }

    func setupConstraints() {
        calendar.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.leading.trailing.equalToSuperview()
            make.centerY.equalToSuperview().offset(-140)
        }

        collectionView.snp.makeConstraints { make in
            make.height.equalTo(194)
            make.top.equalTo(calendar.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview()
            make.centerX.equalToSuperview()
        }
    }

}

extension BlankViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuse, for: indexPath) as? CourtView else { return UICollectionViewCell() }
        print("got past guard")
        cell.configure(facility: facilityDetails, gymHours: gymHours)
        calendar.delegate = cell
        return cell
    }

}
