//
//  HomeController.swift
//  Fitness
//
//  Created by Keivan Shahida on 2/24/18.
//  Copyright © 2018 Keivan Shahida. All rights reserved.
//
import UIKit
import SnapKit
import Alamofire
import AlamofireImage

enum SectionType: String {
    case allGyms = "ALL GYMS"
    case todaysClasses = "TODAY'S CLASSES"
    case lookingFor = "I'M LOOKING FOR..."
}

class HomeController: UIViewController {

    // MARK: - INITIALIZATION
    var mainCollectionView: UICollectionView!
    var todayClassCollectionView: UICollectionView!

    var statusBarBackgroundColor: UIView!
    var headerView: HomeScreenHeaderView!

    var sections: [SectionType] = []
    var gyms: [Gym] = []
    var gymClassInstances: [GymClassInstance] = []
    var gymLocations: [Int: String] = [:]
    var tags: [Tag] = []
    var didSetupHeaderShadow = false

    override func viewDidLoad() {
        super.viewDidLoad()

        headerView = HomeScreenHeaderView()
        headerView.setName(name: "Austin")

        view.addSubview(headerView)
        headerView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(100)
        }

        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 6.0
        flowLayout.minimumLineSpacing = 6.0

        mainCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        mainCollectionView.dataSource = self
        mainCollectionView.delegate = self
        mainCollectionView.backgroundColor = .white
        mainCollectionView.showsVerticalScrollIndicator = false

        mainCollectionView.register(HomeSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: HomeSectionHeaderView.identifier)
        mainCollectionView.register(GymsCell.self, forCellWithReuseIdentifier: GymsCell.identifier)
        mainCollectionView.register(TodaysClassesCell.self, forCellWithReuseIdentifier: TodaysClassesCell.identifier)
        mainCollectionView.register(LookingForCell.self, forCellWithReuseIdentifier: LookingForCell.identifier)

        sections.insert(.allGyms, at: 0)
        sections.insert(.todaysClasses, at: 1)
        sections.insert(.lookingFor, at: 2)

        view.addSubview(mainCollectionView)

        mainCollectionView.snp.makeConstraints {make in
            make.top.equalTo(headerView.snp.bottom)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.bottom.equalToSuperview()
        }

        statusBarBackgroundColor = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 21))
        statusBarBackgroundColor.backgroundColor = .white
        view.addSubview(statusBarBackgroundColor)

        // GET GYMS
        NetworkManager.shared.getGyms { (gyms) in
            self.gyms = gyms.sorted { $0.isOpen && !$1.isOpen }
            self.mainCollectionView.reloadSections(IndexSet(integer: 0))
        }

        // GET TODAY'S CLASSES
        let date = Date()
        if let stringDate = date.getStringDate(date: date) {
            AppDelegate.networkManager.getGymClassInstancesByDate(date: stringDate) { (gymClassInstances) in
                self.gymClassInstances = gymClassInstances
                for gymClassInstance in gymClassInstances {
                    AppDelegate.networkManager.getGym(gymId: gymClassInstance.gymId, completion: { (gym) in
                        self.gymLocations[gymClassInstance.gymId] = gym.name
                        self.mainCollectionView.reloadSections(IndexSet(integer: 1))
                    })
                }
            }
        }

        // GET TAGS
        NetworkManager.shared.getTags { tags in
            self.tags = tags
            self.mainCollectionView.reloadSections(IndexSet(integer: 2))
        }
    }

    // MARK: - ViewDidLoad
    override func viewDidAppear(_ animated: Bool) {
//
//        let allGymsCell = tableView.cellForRow(at: IndexPath(row: 0, section: sections.index(of: .allGyms)!) ) as! AllGymsCell
//        allGymsCell.gyms = {allGymsCell.gyms}()
//
//        let todaysClassesCell = tableView.cellForRow(at: IndexPath(row: 0, section: sections.index(of: .todaysClasses)!) ) as! TodaysClassesCell
//        todaysClassesCell.gymClassInstances = {todaysClassesCell.gymClassInstances}()
    }
}

// MARK: CollectionViewDataSource
extension HomeController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView != mainCollectionView {
            return gymClassInstances.count
        }

        switch sections[section] {
        case .allGyms:
            return gyms.count
        case .todaysClasses:
            return 1
        case .lookingFor:
            return tags.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if collectionView != mainCollectionView {
            //set up today class cells
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.identifier, for: indexPath) as! CategoryCell

            Alamofire.request(tags[indexPath.row].imageURL).responseImage { response in
                if let image = response.result.value {
                    cell.image.image = image
                }
            }

            cell.title.text = tags[indexPath.row].name.capitalized
            return cell
        }

        switch sections[indexPath.section] {
        case .allGyms:
            let gym = gyms[indexPath.row]
            // swiftlint:disable:next force_cast
            let gymCell = collectionView.dequeueReusableCell(withReuseIdentifier: GymsCell.identifier, for: indexPath) as! GymsCell
            gymCell.setGymName(name: gym.name)
            gymCell.setGymStatus(isOpen: gym.isOpen)
            gymCell.setGymHours(hours: getHourString(gym: gym))
            return gymCell
        case .todaysClasses:
            let todayClassesCell = collectionView.dequeueReusableCell(withReuseIdentifier: TodaysClassesCell.identifier, for: indexPath) as! TodaysClassesCell
            todayClassesCell.collectionView.dataSource = self
            todayClassesCell.collectionView.delegate = self
            return todayClassesCell
        case .lookingFor:
            let lookingForCell = collectionView.dequeueReusableCell(withReuseIdentifier: LookingForCell.identifier, for: indexPath) as! LookingForCell
            return lookingForCell
        }
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        if collectionView != mainCollectionView { return UICollectionReusableView() }

        switch kind {
        case UICollectionElementKindSectionHeader:
            // swiftlint:disable:next force_cast
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: HomeSectionHeaderView.identifier, for: indexPath) as! HomeSectionHeaderView
            headerView.setTitle(title: sections[indexPath.section].rawValue)
            return headerView
        default:
            fatalError("Unexpected element kind")
        }
    }
}

// MARK: UICollectionViewDelegate
extension HomeController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if collectionView != mainCollectionView { return .zero }
        return CGSize(width: collectionView.bounds.width, height: 32.0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView != mainCollectionView { return CGSize(width: 228.0, height: 195.0)}

        switch sections[indexPath.section] {
        case .allGyms:
            let spacingInsets: CGFloat = 32.0
            //12.0 is the spacing between each cell
            let totalWidth = collectionView.bounds.width - spacingInsets - 12.0
            return CGSize(width: totalWidth/2.0, height: 60.0)
        case .todaysClasses:
            return CGSize(width: collectionView.bounds.width, height: 195.0)
        case .lookingFor:
            return CGSize(width: 164.0, height: 128.0)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch sections[section] {
        case .allGyms, .lookingFor:
            return UIEdgeInsets(top: 0.0, left: 16.0, bottom: 32.0, right: 16.0)
        case .todaysClasses:
            return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 32.0, right: 0.0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView != mainCollectionView {
            return
        }
        
        switch sections[indexPath.section] {
        case .allGyms:
            let gymDetailViewController = GymDetailViewController()
            gymDetailViewController.gym = gyms[indexPath.row]
            navigationController?.pushViewController(gymDetailViewController, animated: true)
        case .todaysClasses:
            print("SELECTED TODAY CLASSES")
        case .lookingFor:
            print("SELECTED LOOKING FOR")
        }
    }
}

extension HomeController {

    func getHourString(gym: Gym) -> String {
        let now = Date()
        let isOpen = gym.isOpen

        let gymHoursToday = gym.gymHoursToday
        let gymHoursTomorrow = gym.gymHours[now.getIntegerDayOfWeekTomorrow()]

        if gym.name == "Bartels" {
            return "Always open"
        } else if now > gymHoursToday.closeTime {
            return "Opens at \(gymHoursTomorrow.openTime.getStringOfDatetime(format: "h a")), tomorrow"
        } else if !isOpen {
            return "Opens at \(gymHoursToday.openTime.getStringOfDatetime(format: "h a"))"
        } else {
            return "Closes at \(gymHoursToday.closeTime.getStringOfDatetime(format: "h a"))"
        }
    }
}
