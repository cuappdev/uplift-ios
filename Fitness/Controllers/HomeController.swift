//
//  HomeController.swift
//  Fitness
//
//  Created by Keivan Shahida on 2/24/18.
//  Copyright © 2018 Uplift. All rights reserved.
//
import Alamofire
import AlamofireImage
import Crashlytics
import Kingfisher
import SnapKit
import UIKit

enum SectionType: String {
    case checkIns = "DAILY CHECK-INS"
    case allGyms = "ALL GYMS"
    case lookingFor = "I'M LOOKING FOR..."
    case todaysClasses = "TODAY'S CLASSES"
}

class HomeController: UIViewController {

    // MARK: - INITIALIZATION
    var mainCollectionView: UICollectionView!
    
    var todayClassCollectionView: UICollectionView?
    var allGymsCollectionView: UICollectionView?

    var headerView: HomeScreenHeaderView!
    var statusBarBackgroundColor: UIView!

    var didRegisterCategoryCell = false
    var didSetupHeaderShadow = false
    var gymClassInstances: [GymClassInstance] = []
    var gymLocations: [Int: String] = [:]
    var gyms: [Gym] = []
    var favoriteGyms: [Gym] = []
    var habits: [Habit] = []
    var sections: [SectionType] = []
    var tags: [Tag] = []

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
        mainCollectionView.register(HomeSectionEditButtonHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HomeSectionEditButtonHeaderView.identifier)
        
        mainCollectionView.register(NoHabitsCell.self, forCellWithReuseIdentifier: NoHabitsCell.identifier)
        mainCollectionView.register(HabitTrackerCheckinCell.self, forCellWithReuseIdentifier: HabitTrackerCheckinCell.identifier)
//        mainCollectionView.register(GymsCell.self, forCellWithReuseIdentifier: GymsCell.identifier)
        mainCollectionView.register(AllGymsCell.self, forCellWithReuseIdentifier: AllGymsCell.identifier)
        mainCollectionView.register(TodaysClassesCell.self, forCellWithReuseIdentifier: TodaysClassesCell.identifier)
        mainCollectionView.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.identifier)

        
        sections = [.checkIns, .allGyms, .todaysClasses, .lookingFor]
        view.addSubview(mainCollectionView)

        mainCollectionView.snp.makeConstraints {make in
            make.top.equalTo(headerView.snp.bottom).offset(12)
            make.centerX.width.bottom.equalToSuperview()
        }

        statusBarBackgroundColor = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 21))
        statusBarBackgroundColor.backgroundColor = .fitnessWhite
        view.addSubview(statusBarBackgroundColor)
        
        // GET HABITS
        habits = Habit.getActiveHabits()
        mainCollectionView.reloadSections(IndexSet(integer: 0))

        // GET GYMS
        NetworkManager.shared.getGyms { gyms in
            self.gyms = gyms.sorted { $0.isOpen && !$1.isOpen }
            
            let gymNames: [String] = []     // TODO --GET FAVORITE GYMS ONCE MERGED
            
            for favoriteGym in gymNames {
                for gym in self.gyms {
                    if gym.name == favoriteGym {
                        self.favoriteGyms.append(gym)
                    }
                }
            }
            
            self.mainCollectionView.reloadSections(IndexSet(integer: 1))
        }

        // GET TODAY'S CLASSES
        let stringDate = Date.getNowString()

        NetworkManager.shared.getGymClassesForDate(date: stringDate) { (gymClassInstances) in
            self.gymClassInstances = gymClassInstances.sorted { (first, second) in
                return first.startTime < second.startTime
            }
            self.mainCollectionView.reloadSections(IndexSet(integer: 2))
        }

        // GET TAGS
        NetworkManager.shared.getTags { tags in
            self.tags = tags
            self.mainCollectionView.reloadSections(IndexSet(integer: 3))
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        for cell in allGymsCollectionView?.visibleCells ?? [] {
            if let cell = cell as? GymsCell, let indexPath = mainCollectionView.indexPath(for: cell) {
                cell.setGymStatus(isOpen: favoriteGyms[indexPath.item].isOpen)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.tabBarController?.tabBar.isHidden = false
        
        let newHabits = Habit.getActiveHabits()
        if habits != newHabits {
            habits = newHabits
            mainCollectionView.reloadSections(IndexSet(integer: 0))
        }
    }
}

// MARK: CollectionViewDataSource
extension HomeController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == todayClassCollectionView {
            return gymClassInstances.count
        } else if collectionView == allGymsCollectionView {
            return favoriteGyms.count
        }

        switch sections[section] {
        case .checkIns:
            return habits.count == 3 ? 3 : 1
        case .allGyms:
            return 1
        case .todaysClasses:
            return 1
        case .lookingFor:
            return tags.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Today's classes cells
        if collectionView == todayClassCollectionView {
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
        } else if collectionView == allGymsCollectionView {
            // Gym cells
            let gym = favoriteGyms[indexPath.row]
            // swiftlint:disable:next force_cast
            let gymCell = collectionView.dequeueReusableCell(withReuseIdentifier: GymsCell.identifier, for: indexPath) as! GymsCell
            gymCell.setGymName(name: gym.name)
            gymCell.setGymStatus(isOpen: gym.isOpen)
            gymCell.setGymHours(hours: getHourString(gym: gym))
            return gymCell
        }

        switch sections[indexPath.section] {
        case .checkIns:
            if habits.count == 0 {
                let noHabitsCell = collectionView.dequeueReusableCell(withReuseIdentifier: NoHabitsCell.identifier, for: indexPath) as! NoHabitsCell
                return noHabitsCell
            } else {
                let habitCell = collectionView.dequeueReusableCell(withReuseIdentifier: HabitTrackerCheckinCell.identifier, for: indexPath) as! HabitTrackerCheckinCell
                
                habitCell.configure(habit: habits[indexPath.row])
                return habitCell
            }
        case .allGyms:
            let allGymsCell = collectionView.dequeueReusableCell(withReuseIdentifier: AllGymsCell.identifier, for: indexPath) as! AllGymsCell
            
            allGymsCollectionView = allGymsCell.collectionView
            allGymsCell.collectionView.dataSource = self
            allGymsCell.collectionView.delegate = self
            return allGymsCell
        case .todaysClasses:
            // swiftlint:disable:next force_cast
            let todayClassesCell = collectionView.dequeueReusableCell(withReuseIdentifier: TodaysClassesCell.identifier, for: indexPath) as! TodaysClassesCell
            
            todayClassCollectionView = todayClassesCell.collectionView
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
        return sections.count
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        if collectionView != mainCollectionView { return UICollectionReusableView() }

        switch kind {
        case UICollectionView.elementKindSectionHeader:
            switch sections[indexPath.section] {
            case .todaysClasses:
                // swiftlint:disable:next force_cast
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HomeSectionEditButtonHeaderView.identifier, for: indexPath) as! HomeSectionEditButtonHeaderView
                headerView.configure(title: sections[indexPath.section].rawValue, buttonTitle: "view all", completion: viewTodaysClasses)
                return headerView
            case .checkIns:
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HomeSectionEditButtonHeaderView.identifier, for: indexPath) as! HomeSectionEditButtonHeaderView
                headerView.configure(title: sections[indexPath.section].rawValue, buttonTitle: "edit", completion: pushHabitOnboarding)
                return headerView
            case .lookingFor:
                // swiftlint:disable:next force_cast
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HomeSectionHeaderView.identifier, for: indexPath) as! HomeSectionHeaderView
                headerView.setTitle(title: sections[indexPath.section].rawValue)
                return headerView
            case .allGyms:
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HomeSectionEditButtonHeaderView.identifier, for: indexPath) as! HomeSectionEditButtonHeaderView
                headerView.configure(title: sections[indexPath.section].rawValue, buttonTitle: "edit", completion: {})
                // TODO - setup completion
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
        if collectionView == todayClassCollectionView {
            return CGSize(width: 228.0, height: 195.0)
        } else if collectionView == allGymsCollectionView {
            return CGSize(width: 271, height: 90.0)
        }

        switch sections[indexPath.section] {
        case .checkIns:
            return CGSize(width: collectionView.bounds.width, height: 53.0)
        case .allGyms:
            return CGSize(width: collectionView.bounds.width, height: 123.0)
        case .todaysClasses:
            return CGSize(width: collectionView.bounds.width, height: 227.0)
        case .lookingFor:
            let width = (collectionView.bounds.width-48)/2
            return CGSize(width: width, height: width*0.78)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView != mainCollectionView {
            return UIEdgeInsets(top: 0.0, left: 12.0, bottom: 32.0, right: 12.0)
        }
        
        switch sections[section] {
        case .checkIns:
            return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 32.0, right: 0.0)
        case .allGyms:
            return .zero
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
        if collectionView == todayClassCollectionView {
            // MARK: - Fabric
            Answers.logCustomEvent(withName: "Found Info on Homepage", customAttributes: [
                "Section": SectionType.todaysClasses.rawValue
                ])
            let classDetailViewController = ClassDetailViewController()
            classDetailViewController.gymClassInstance = gymClassInstances[indexPath.row]
            navigationController?.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(classDetailViewController, animated: true)
            return
        } else if collectionView == allGymsCollectionView {
            let gymDetailViewController = GymDetailViewController()
            gymDetailViewController.gym = favoriteGyms[indexPath.row]
            navigationController?.pushViewController(gymDetailViewController, animated: true)
            return
        }
        
        switch sections[indexPath.section] {
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
        case .checkIns:
            if habits.count == 0 {
                pushHabitOnboarding()
            }
            return
        case .todaysClasses, .allGyms:
            return
        }
        
        // MARK: - Fabric
        Answers.logCustomEvent(withName: "Found Info on Homepage", customAttributes: [
            "Section": sections[indexPath.section].rawValue
            ])
    }
}

extension HomeController {
    
    func pushHabitOnboarding() {
        let habitViewController = HabitTrackingController(type: .cardio)
        self.navigationController?.pushViewController(habitViewController, animated: true)
        return
    }
    
    func viewTodaysClasses() {
        guard let classNavigationController = tabBarController?.viewControllers?[1] as? UINavigationController else { return }
        guard let classListViewController = classNavigationController.viewControllers[0] as? ClassListViewController else { return }
        
        classListViewController.calendarDateSelected = classListViewController.calendarDatesList[3]
        classListViewController.calendarCollectionView.reloadData()
        classListViewController.getClassesFor(date: classListViewController.calendarDateSelected)
        if classListViewController.currentFilterParams != nil {
            classListViewController.filterOptions(params: FilterParameters())
        }
        
        classNavigationController.setViewControllers([classListViewController], animated: false)
        tabBarController?.hidesBottomBarWhenPushed = false
        tabBarController?.selectedIndex = 1
    }

    func getHourString(gym: Gym) -> String {
        let now = Date()
        let isOpen = gym.isOpen

        let gymHoursToday = gym.gymHoursToday
        let gymHoursTomorrow = gym.gymHours[now.getIntegerDayOfWeekTomorrow()]
        
        let format: String

        if now > gymHoursToday.closeTime {
            if Calendar.current.component(.minute, from: gymHoursTomorrow.openTime) == 0 {
                format = "h a"
            } else {
                format = "h:mm a"
            }
            
            if gym.closedTomorrow {
                return "Closed Tomorrow"
            } else {
                return "Opens at \(gymHoursTomorrow.openTime.getStringOfDatetime(format: format))"
            }
        } else if !isOpen {
            if Calendar.current.component(.minute, from: gymHoursToday.openTime) == 0 {
                format = "h a"
            } else {
                format = "h:mm a"
            }
            return "Opens at \(gymHoursToday.openTime.getStringOfDatetime(format: format))"
            
        } else {
            if Calendar.current.component(.minute, from: gymHoursToday.closeTime) == 0 {
                format = "h a"
            } else {
                format = "h:mm a"
            }
            let openTime = gymHoursToday.openTime.getStringOfDatetime(format: format)
            let closeTime = gymHoursToday.closeTime.getStringOfDatetime(format: format)
            
            return "\(openTime) - \(closeTime)"
        }
    }
}
