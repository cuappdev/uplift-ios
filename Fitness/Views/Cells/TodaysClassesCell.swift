//
//  TodaysClassesCell.swift
//  Fitness
//
//  Created by Joseph Fulgieri on 3/18/18.
//  Copyright © 2018 Keivan Shahida. All rights reserved.
//
import UIKit
import SnapKit
import Alamofire
import AlamofireImage

class TodaysClassesCell: UITableViewCell, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    // MARK: - INITIALIZATION
    static let identifier = Identifiers.todaysClassesCell
    var collectionView: UICollectionView!
    var gymClassInstances: [GymClassInstance] = [] {
        didSet {
            gymClassInstances = gymClassInstances.filter {
                Date() < Date.getDateFromTime(time: $0.startTime)
            }
            gymClassInstances.sort {
                Date.getDateFromTime(time: $0.startTime) < Date.getDateFromTime(time: $1.startTime)
            }
            
            // temp, for testing
            let desc = GymClassDescription(id: 0, description: "this is a class", name: "Spin", tags: [], gymClasses: [], imageURL: "http://tigerday.org/wp-content/uploads/2013/04/Siberischer_tiger.jpg")
            
            let gClass = GymClassInstance(gymClassInstanceId: 0, classDescription: desc, instructor: Instructor(id: 0, name: "joe", gymClassDescriptions: [desc], gymClasses: [0]), startTime: "10:00AM", gymId: 2, duration: "0:45")
            gymClassInstances.append(gClass)
            // end temp
            
            collectionView.reloadData()
        }
    }

    var gymLocations: [Int: String] = [:] {
        didSet {
            collectionView.reloadData()
        }
    }

    var navigationController: UINavigationController?

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        //COLLECTION VIEW LAYOUT
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16 )
        layout.minimumInteritemSpacing = 16
        layout.minimumLineSpacing = 12

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self

        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false

        collectionView.register(ClassesCell.self, forCellWithReuseIdentifier: ClassesCell.identifier)

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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ClassesCell.identifier, for: indexPath) as! ClassesCell
        let classInstance = gymClassInstances[indexPath.row]

        Alamofire.request(classInstance.classDescription.imageURL!).responseImage { response in
            if let image = response.result.value {
                cell.image.image = image
            }
        }

        cell.locationName.text = gymLocations[classInstance.gymId]

        //HOURS
        var time = Date.getDateFromTime(time: classInstance.startTime)
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: "EDT")!

        let dateFormatter = DateFormatter()
        let durationMinutes = Date.getMinutesFromDuration(duration: classInstance.duration)

        time = calendar.date(byAdding: .minute, value: durationMinutes, to: time)!
        dateFormatter.dateFormat = "h:mm a"
        let endTime = dateFormatter.string(from: time)

        cell.hours.text = classInstance.startTime + " - " + endTime
        cell.duration = durationMinutes
        cell.className.text = classInstance.classDescription.name
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let classDetailViewController = ClassDetailViewController()
        let cell = collectionView.cellForItem(at: indexPath) as! ClassesCell

        classDetailViewController.gymClassInstance = gymClassInstances[indexPath.row]
        classDetailViewController.durationLabel.text = String(cell.duration) + " MIN"
        classDetailViewController.locationLabel.text = cell.locationName.text
        classDetailViewController.location = cell.locationName.text
        classDetailViewController.classImageView.image = cell.image.image

        //DATE
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let day = Date()

        dateFormatter.dateFormat = "EEEE"
        var dateLabel = dateFormatter.string(from: day)
        dateFormatter.dateFormat = "MMMM"
        dateLabel += ", " + dateFormatter.string(from: day)
        dateFormatter.dateFormat = "d"
        dateLabel += " " + dateFormatter.string(from: day)
        classDetailViewController.dateLabel.text = dateLabel

        //TIME
        classDetailViewController.timeLabel.text = cell.hours.text

        navigationController!.pushViewController(classDetailViewController, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gymClassInstances.count > 5 ? 5 : gymClassInstances.count
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 228, height: 195)
    }
}
