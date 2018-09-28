//
//  OpenGymsCell.swift
//  Fitness
//
//  Created by Joseph Fulgieri on 3/18/18.
//  Copyright © 2018 Keivan Shahida. All rights reserved.
//
import UIKit
import SnapKit

struct SortedGyms {
    var openGymsIndices: [Int]
    var closedGymsIndices: [Int]
}

class AllGymsCell: UITableViewCell, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    // MARK: - INITIALIZATION
    static let identifier = Identifiers.allGymsCell
    var collectionView: UICollectionView!
    var gyms: [Gym] = [] {
        didSet {
            gyms.sort { $0.isOpen && !$1.isOpen }
            collectionView.reloadData()
        }
    }

    var navigationController: UINavigationController?

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        //COLLECTION VIEW LAYOUT
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 19, bottom: 12, right: 40 )
        layout.minimumInteritemSpacing = 20
        layout.minimumLineSpacing = 12

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white

        collectionView.register(GymsCell.self, forCellWithReuseIdentifier: GymsCell.identifier)

        contentView.addSubview(collectionView)

        collectionView.snp.updateConstraints {make in
            make.center.equalToSuperview()
            make.size.equalToSuperview()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - COLLECTION VIEW
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GymsCell.identifier, for: indexPath) as! GymsCell
        let gym = gyms[indexPath.row]
        
        let now = Date()
        let isOpen = gym.isOpen

        let gymHoursToday = gym.gymHoursToday
        let gymHoursTomorrow = gym.gymHours[now.getIntegerDayOfWeekTomorrow()]
        
        if gyms[indexPath.row].name == "Bartels" {
            cell.hours.text = "Always open"
        } else if now > gymHoursToday.closeTime {
             cell.hours.text = "Opens at \(gymHoursTomorrow.openTime.getStringOfDatetime(format: "h a")), tomorrow"
        } else if !isOpen {
            cell.hours.text = "Opens at \(gymHoursToday.openTime.getStringOfDatetime(format: "h a"))"
        } else {
            cell.hours.text = "Closes at \(gymHoursToday.closeTime.getStringOfDatetime(format: "h a"))"
        }

        cell.locationName.text = gyms[indexPath.row].name
        cell.status.text = isOpen ? "Open" : "Closed"
        cell.status.textColor = isOpen ? .fitnessGreen : .fitnessRed
        cell.colorBar.backgroundColor = isOpen ? .fitnessYellow : .lightGray
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gyms.count
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (frame.width - 80)/2, height: 48)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let gymDetailViewController = GymDetailViewController()
        gymDetailViewController.gym = gyms[indexPath.row]

        navigationController!.pushViewController(gymDetailViewController, animated: true)
    }
}
