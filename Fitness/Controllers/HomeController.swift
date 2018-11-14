//
//  HomeController.swift
//  Fitness
//
//  Created by Keivan Shahida on 2/24/18.
//  Copyright © 2018 Uplift. All rights reserved.
//
import UIKit
import SnapKit
import Alamofire
import AlamofireImage
import Kingfisher
import Crashlytics

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
    var didRegisterCategoryCell = false

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.fitnessWhite
        headerView = HomeScreenHeaderView()
        headerView.layer.shadowOffset = CGSize(width: 0.0, height: 9.0)
        headerView.layer.shadowOpacity = 0.25
        headerView.layer.shadowColor = UIColor.buttonShadow.cgColor
        headerView.layer.masksToBounds = false

        view.addSubview(headerView)
        headerView.snp.makeConstraints { make in
            make.leading.trailing.top.equalTo(view)
            make.height.equalTo(120)
        }

        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 6.0
        flowLayout.minimumLineSpacing = 12.0

        mainCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        mainCollectionView.contentInset = UIEdgeInsets(top: 11, left: 0, bottom: 0, right: 0)
        mainCollectionView.dataSource = self
        mainCollectionView.delegate = self
        mainCollectionView.backgroundColor = .white
        mainCollectionView.delaysContentTouches = false
        mainCollectionView.showsVerticalScrollIndicator = false

        mainCollectionView.register(HomeSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HomeSectionHeaderView.identifier)
        mainCollectionView.register(TodaysClassesHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TodaysClassesHeaderView.identifier)
        mainCollectionView.register(GymsCell.self, forCellWithReuseIdentifier: GymsCell.identifier)
        mainCollectionView.register(TodaysClassesCell.self, forCellWithReuseIdentifier: TodaysClassesCell.identifier)
        mainCollectionView.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.identifier)

        sections.insert(.allGyms, at: 0)
        sections.insert(.todaysClasses, at: 1)
        sections.insert(.lookingFor, at: 2)
        view.addSubview(mainCollectionView)

        mainCollectionView.snp.makeConstraints {make in
            make.top.equalTo(headerView.snp.bottom).offset(12)
            make.centerX.width.bottom.equalToSuperview()
        }

        statusBarBackgroundColor = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 21))
        statusBarBackgroundColor.backgroundColor = .fitnessWhite
        view.addSubview(statusBarBackgroundColor)

        // GET GYMS
        NetworkManager.shared.getGyms { (gyms) in
            self.gyms = gyms.sorted { $0.isOpen && !$1.isOpen }
            self.mainCollectionView.reloadSections(IndexSet(integer: 0))
        }

        // GET TODAY'S CLASSES

        let stringDate = Date.getNowString()
        print("TRACE: today: \(stringDate)")

        NetworkManager.shared.getGymClassesForDate(date: stringDate) { (gymClassInstances) in
            self.gymClassInstances = gymClassInstances.sorted { (first, second) in
                return first.startTime < second.startTime
            }
            self.mainCollectionView.reloadSections(IndexSet(integer: 1))
        }

        // GET TAGS
        NetworkManager.shared.getTags { tags in
            self.tags = tags
            self.mainCollectionView.reloadSections(IndexSet(integer: 2))
        }
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
            let classInstance = gymClassInstances[indexPath.row]
            let reuseIdentifier = classInstance.isCancelled ? ClassesCell.cancelledIdentifier : ClassesCell.identifier
            // swiftlint:disable:next force_cast
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ClassesCell
            let className = classInstance.className
            cell.className.text = className
            cell.locationName.text = classInstance.location
            cell.image.kf.setImage(with: classInstance.imageURL)

            //HOURS
            if !classInstance.isCancelled {
                var calendar = Calendar.current
                calendar.timeZone = TimeZone(abbreviation: "EDT")!
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "h:mm a"

                cell.hours.text = dateFormatter.string(from: classInstance.startTime) + " - " + dateFormatter.string(from: classInstance.endTime)
            } else {
                cell.classIsCancelled()

            }
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
            // swiftlint:disable:next force_cast
            let todayClassesCell = collectionView.dequeueReusableCell(withReuseIdentifier: TodaysClassesCell.identifier, for: indexPath) as! TodaysClassesCell
            todayClassesCell.collectionView.dataSource = self
            todayClassesCell.collectionView.delegate = self
            return todayClassesCell
        case .lookingFor:
            // swiftlint:disable:next force_cast
            let categoryCell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.identifier, for: indexPath) as! CategoryCell
            categoryCell.title.text = tags[indexPath.row].name

            let url = URL(string: tags[indexPath.row].imageURL)
            categoryCell.image.kf.setImage(with: url)
            return categoryCell
        }
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView != mainCollectionView { return 1 }
        return 3
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        if collectionView != mainCollectionView { return UICollectionReusableView() }

        switch kind {
        case UICollectionView.elementKindSectionHeader:
            switch sections[indexPath.section] {
            case .todaysClasses:
                // swiftlint:disable:next force_cast
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TodaysClassesHeaderView.identifier, for: indexPath) as! TodaysClassesHeaderView
                headerView.delegate = self
                return headerView
            case .lookingFor, .allGyms:
                // swiftlint:disable:next force_cast
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HomeSectionHeaderView.identifier, for: indexPath) as! HomeSectionHeaderView
                headerView.setTitle(title: sections[indexPath.section].rawValue)
                return headerView
            }
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
        if collectionView != mainCollectionView {
            return CGSize(width: 228.0, height: 195.0)}

        switch sections[indexPath.section] {
        case .allGyms:
            let spacingInsets: CGFloat = 32.0
            //12.0 is the spacing between each cell
            let totalWidth = collectionView.bounds.width - spacingInsets - 12.0
            return CGSize(width: totalWidth/2.0, height: 60.0)
        case .todaysClasses:
            return CGSize(width: collectionView.bounds.width, height: 227.0)
        case .lookingFor:
            let width = (collectionView.bounds.width-48)/2
            return CGSize(width: width, height: width*0.78)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch sections[section] {
        case .allGyms:
            return UIEdgeInsets(top: 0.0, left: 12.0, bottom: 32.0, right: 12.0)
        case .lookingFor:
            return UIEdgeInsets(top: 0.0, left: 16.0, bottom: 32.0, right: 16.0)
        case .todaysClasses:
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
            guard let cell = collectionView.cellForItem(at: indexPath) else { return }
            UIView.animate(withDuration: 0.35, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: [], animations: {
                cell.transform = CGAffineTransform(scaleX: 0.96, y: 0.96)
            }, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
            guard let cell = collectionView.cellForItem(at: indexPath) else { return }
            UIView.animate(withDuration: 0.35, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: [], animations: {
                cell.transform = .identity
            }, completion: nil)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView != mainCollectionView {
            // MARK: - Fabric
            Answers.logCustomEvent(withName: "Found Info on Homepage", customAttributes: [
                "Section": sections[indexPath.section].rawValue
                ])
            
            let classDetailViewController = ClassDetailViewController()
            classDetailViewController.gymClassInstance = gymClassInstances[indexPath.row]
            navigationController?.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(classDetailViewController, animated: true)
            return
        }

        switch sections[indexPath.section] {
        case .allGyms:
            let gymDetailViewController = GymDetailViewController()
            gymDetailViewController.gym = gyms[indexPath.row]
            navigationController?.pushViewController(gymDetailViewController, animated: true)
        case .lookingFor:
            let cal = Calendar.current
            let currDate = Date()
            guard let startDate = cal.date(bySettingHour: 0, minute: 0, second: 0, of: currDate) else { return }
            let endDate = cal.date(bySettingHour: 23, minute: 59, second: 0, of: currDate) ?? Date()

            let filterParameters = FilterParameters(applyFilter: true, startingTime: startDate,  endingTime: endDate, instructorsNames: [], classesNames: [], gymsIds: [], tagsNames: [tags[indexPath.row].name])

            guard let classNavigationController = tabBarController?.viewControllers?[1] as? UINavigationController else { return }
            guard let classListViewController = classNavigationController.viewControllers[0] as? ClassListViewController else { return }

            classListViewController.currentFilterParams = filterParameters
            classNavigationController.setViewControllers([classListViewController], animated: false)

            tabBarController?.selectedIndex = 1

        case .todaysClasses:
            let classDetailViewController = ClassDetailViewController()
            classDetailViewController.gymClassInstance = gymClassInstances[indexPath.row]
            navigationController?.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(classDetailViewController, animated: true)
        }
    }
}

// MARK: - NavigationDelegate
extension HomeController: NavigationDelegate {
    func viewTodaysClasses() {
        guard let classNavigationController = tabBarController?.viewControllers?[1] as? UINavigationController else { return }
        guard let classListViewController = classNavigationController.viewControllers[0] as? ClassListViewController else { return }
        
        classListViewController.calendarDateSelected = classListViewController.calendarDatesList[3]
        classListViewController.calendarCollectionView.reloadData()
        classListViewController.getClassesFor(date: classListViewController.calendarDateSelected)
        classListViewController.filterOptions(params: FilterParameters())
        
        classNavigationController.setViewControllers([classListViewController], animated: false)
        
        tabBarController?.selectedIndex = 1
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
            return "Opens at \(gymHoursTomorrow.openTime.getStringOfDatetime(format: "h a"))"
        } else if !isOpen {
            return "Opens at \(gymHoursToday.openTime.getStringOfDatetime(format: "h a"))"
        } else {
            return "Closes at \(gymHoursToday.closeTime.getStringOfDatetime(format: "h a"))"
        }
    }
}
