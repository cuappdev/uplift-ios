//
//  HomeController.swift
//  Fitness
//
//  Created by Cornell AppDev on 2/24/18.
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
    case todaysClasses = "TODAY'S CLASSES"
    case pros = "LEARN FROM THE PROS"
}

private enum SectionInsets {
    static func getInsets(section: SectionType) -> UIEdgeInsets {
        switch section {
        case .checkIns:
            return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 32.0, right: 0.0)
        case .allGyms:
            return UIEdgeInsets(top: 0.0, left: 16.0, bottom: 32.0, right: 12.0)
        case .todaysClasses:
            return UIEdgeInsets(top: 0.0, left: 16.0, bottom: 32.0, right: 12.0)
        case .pros:
            return UIEdgeInsets(top: 0.0, left: 16.0, bottom: 32.0, right: 16.0)
        }
    }
}

class HomeController: UIViewController {
    
    // MARK: - INITIALIZATION
    private var allGymsCollectionView: UICollectionView?
    private var headerView: HomeScreenHeaderView!
    private var mainCollectionView: UICollectionView!
    
    private var gymClassInstances: [GymClassInstance] = []
    private var gymLocations: [Int: String] = [:]
    private var gyms: [Gym] = []
    private var favoriteGyms: [Gym] = []
    private var habits: [Habit] = []
    private let pros = ProBio.getAllPros()
    private var sections: [SectionType] = []

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
        
        mainCollectionView.register(NoHabitsCell.self, forCellWithReuseIdentifier: NoHabitsCell.identifier)
        mainCollectionView.register(HabitTrackerCheckinCell.self, forCellWithReuseIdentifier: HabitTrackerCheckinCell.identifier)
        mainCollectionView.register(AllGymsCell.self, forCellWithReuseIdentifier: AllGymsCell.identifier)
        mainCollectionView.register(TodaysClassesCell.self, forCellWithReuseIdentifier: TodaysClassesCell.identifier)
        mainCollectionView.register(DiscoverProsCell.self, forCellWithReuseIdentifier: DiscoverProsCell.identifier)
        
        sections = [.checkIns, .allGyms, .todaysClasses, .pros]

        view.addSubview(mainCollectionView)

        mainCollectionView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(12)
            make.centerX.width.bottom.equalToSuperview()
        }
        
        // GET HABITS
        habits = Habit.getActiveHabits()
        mainCollectionView.reloadSections(IndexSet(integer: 0))

        // GET GYMS
        NetworkManager.shared.getGyms { gyms in
            self.gyms = gyms.sorted { $0.isOpen && !$1.isOpen }
            
            let gymNames = UserDefaults.standard.stringArray(forKey: Identifiers.favoriteGyms) ?? []
            self.updateFavorites(favorites: gymNames)
            
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

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        allGymsCollectionView?.visibleCells.forEach({ cell in
            if let cell = cell as? GymsCell, let indexPath = mainCollectionView.indexPath(for: cell) {
                cell.setGymStatus(isOpen: favoriteGyms[indexPath.item].isOpen, changingSoon: isGymStatusChangingSoon(gym: favoriteGyms[indexPath.item]))
            }
        })
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

    func getCollectionViewCellSize(_ collectionView: UICollectionView, identifier: String) -> CGSize {
        // Heights
        let allGymsCellHeight = CGFloat(123.0)
        let checkinCellHeight = CGFloat(53.0)
        let classCellHeight = CGFloat(195.0)
        let discoverProsCellHeight = CGFloat(110.0)
        let gymCellHeight = CGFloat(90.0)
        let proCellHeight = CGFloat(145.0)
        let todaysClassesCellHeight = CGFloat(227.0)
        
        // Habits
        let checkInCellSize = CGSize(width: collectionView.bounds.width, height: checkinCellHeight)
        // Gyms
        let allGymsCellSize = CGSize(width: collectionView.bounds.width, height: allGymsCellHeight)
        let gymCellSize = CGSize(width: 271, height: gymCellHeight)
        // Classes
        let todaysClassesCellSize = CGSize(width: collectionView.bounds.width, height: todaysClassesCellHeight)
        let classCellSize = CGSize(width: 228.0, height: classCellHeight)
        //Pros
        let discoverProsCellSize = CGSize(width: 280.0, height: discoverProsCellHeight)
        let proCellSize = CGSize(width: collectionView.bounds.width, height: proCellHeight)
        
        if identifier == Identifiers.habitTrackerCheckinCell {
            return checkInCellSize
        } else if identifier == Identifiers.allGymsCell {
            return allGymsCellSize
        } else if identifier == Identifiers.gymsCell {
            return gymCellSize
        } else if identifier == Identifiers.todaysClassesCell {
            return todaysClassesCellSize
        } else if identifier == Identifiers.classesCell {
            return classCellSize
        } else if identifier == Identifiers.discoverProsCell {
            return discoverProsCellSize
        } else if identifier == Identifiers.proCell {
            return proCellSize
        }
        
        return CGSize(width: 0, height: 0)
    }
}

// MARK: CollectionViewDataSource
extension HomeController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.accessibilityIdentifier == Identifiers.todaysClassesCell {
            return gymClassInstances.count
        } else if collectionView.accessibilityIdentifier == Identifiers.discoverProsCell {
            return pros.count
        } else if collectionView.accessibilityIdentifier == Identifiers.allGymsCell {
            return favoriteGyms.count
        }
    
        switch sections[section] {
        case .checkIns:
            // Either a cell for each habit, or if no habits one empty state cell
            return habits.isEmpty ? habits.count : 1
        case .pros, .todaysClasses, .allGyms:
            return 1
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.accessibilityIdentifier == Identifiers.todaysClassesCell {
            let classInstance = gymClassInstances[indexPath.row]
            let reuseIdentifier = classInstance.isCancelled ? ClassesCell.cancelledIdentifier : ClassesCell.identifier
            // swiftlint:disable:next force_cast
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ClassesCell
            let className = classInstance.className
            cell.className.text = className
            cell.locationName.text = classInstance.location
            cell.image.kf.setImage(with: classInstance.imageURL)

            // HOURS
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
            
        } else if collectionView.accessibilityIdentifier == Identifiers.allGymsCell {
            let gym = favoriteGyms[indexPath.row]
            
            // swiftlint:disable:next force_cast
            let gymCell = collectionView.dequeueReusableCell(withReuseIdentifier: GymsCell.identifier, for: indexPath) as! GymsCell
            gymCell.setGymName(name: gym.name)
            gymCell.setGymStatus(isOpen: gym.isOpen, changingSoon: isGymStatusChangingSoon(gym: gym))
            gymCell.setGymHours(hours: getHourString(gym: gym))
            return gymCell
            
        } else if collectionView.accessibilityIdentifier == Identifiers.discoverProsCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProCollectionViewCell.identifier, for: indexPath) as! ProCollectionViewCell
            cell.setPro(pros[indexPath.row])
            return cell
        }

        switch sections[indexPath.section] {
        case .checkIns:
            if habits.isEmpty {
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
        case .pros:
            let discoverPros = collectionView.dequeueReusableCell(withReuseIdentifier: DiscoverProsCell.identifier, for: indexPath) as! DiscoverProsCell
            discoverPros.collectionView.dataSource = self
            discoverPros.collectionView.delegate = self
            return discoverPros
        case .todaysClasses:
            // swiftlint:disable:next force_cast
            let todayClassesCell = collectionView.dequeueReusableCell(withReuseIdentifier: TodaysClassesCell.identifier, for: indexPath) as! TodaysClassesCell
            todayClassesCell.collectionView.dataSource = self
            todayClassesCell.collectionView.delegate = self
            return todayClassesCell
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
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HomeSectionHeaderView.identifier, for: indexPath) as! HomeSectionHeaderView
            
            switch sections[indexPath.section] {
            case .checkIns:
                headerView.configure(title: sections[indexPath.section].rawValue, buttonTitle: "edit", completion: pushHabitOnboarding)
                return headerView
            case .allGyms:
                headerView.configure(title: sections[indexPath.section].rawValue, buttonTitle: "edit", completion: pushGymOnboarding)
                return headerView
            case .pros:
                headerView.configure(title: sections[indexPath.section].rawValue, buttonTitle: nil, completion: nil)
                return headerView
            case .todaysClasses:
                headerView.configure(title: sections[indexPath.section].rawValue, buttonTitle: "view all", completion: viewTodaysClasses)
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
        return CGSize(width: collectionView.bounds.width, height: HomeSectionHeaderView.height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.accessibilityIdentifier == Identifiers.todaysClassesCell {
            return getCollectionViewCellSize(collectionView, identifier: Identifiers.classesCell)
        } else if collectionView.accessibilityIdentifier == Identifiers.discoverProsCell{
            return getCollectionViewCellSize(collectionView, identifier: Identifiers.discoverProsCell)
        } else if collectionView.accessibilityIdentifier == Identifiers.allGymsCell {
            return getCollectionViewCellSize(collectionView, identifier: Identifiers.gymsCell)
        }

        switch sections[indexPath.section] {
        case .checkIns:
            return getCollectionViewCellSize(collectionView, identifier: Identifiers.habitTrackerCheckinCell)
        case .allGyms:
            return getCollectionViewCellSize(collectionView, identifier: Identifiers.allGymsCell)
        case .pros:
            return getCollectionViewCellSize(collectionView, identifier: Identifiers.proCell)
        case .todaysClasses:
            return getCollectionViewCellSize(collectionView, identifier: Identifiers.todaysClassesCell)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView.accessibilityIdentifier == Identifiers.todaysClassesCell {
            return SectionInsets.getInsets(section: .todaysClasses)
        } else if collectionView.accessibilityIdentifier == Identifiers.allGymsCell {
            return SectionInsets.getInsets(section: .allGyms)
        } else if collectionView.accessibilityIdentifier == Identifiers.discoverProsCell {
            return SectionInsets.getInsets(section: .pros)
        }
        
        switch sections[section] {
        case .checkIns:
            return SectionInsets.getInsets(section: .checkIns)
        case .allGyms, .pros, .todaysClasses:
            // Insets for these are handled within their internal collectionViews
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
        if collectionView.accessibilityIdentifier == Identifiers.todaysClassesCell {
            let classDetailViewController = ClassDetailViewController(gymClassInstance: gymClassInstances[indexPath.row])
            navigationController?.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(classDetailViewController, animated: true)
            return
        } else if collectionView.accessibilityIdentifier == Identifiers.allGymsCell {
            let gymDetailViewController = GymDetailViewController()
            gymDetailViewController.gym = favoriteGyms[indexPath.row]
            navigationController?.pushViewController(gymDetailViewController, animated: true)
            return
        } else if collectionView.accessibilityIdentifier == Identifiers.discoverProsCell {
            let proDetailViewController = ProBioPageViewController()
            proDetailViewController.pro = pros[indexPath.row]
            navigationController?.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(proDetailViewController, animated: true)
            return
        }
        
        switch sections[indexPath.section] {
        case .checkIns:
            if habits.isEmpty {
                pushHabitOnboarding()
            }
            return
        case .pros:
            let proDetailViewController = ProBioPageViewController()
            navigationController?.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(proDetailViewController, animated: true)
        case .todaysClasses, .allGyms:
            return
        }
    }
}

extension HomeController: ChooseGymsDelegate {
    func updateFavorites(favorites: [String]) {
        favoriteGyms = []
        favoriteGyms = favorites.compactMap { favorite in
            self.gyms.first { $0.name == favorite }
        }
    }
    
    func pushHabitOnboarding() {
        let habitViewController = HabitTrackingController(type: .cardio)
        self.navigationController?.pushViewController(habitViewController, animated: true)
        return
    }
    
    func pushGymOnboarding() {
        navigationController?.tabBarController?.tabBar.isHidden = true
        let onboardingGymsViewController = OnboardingGymsViewController()
        onboardingGymsViewController.delegate = self
        navigationController?.pushViewController(onboardingGymsViewController, animated: true)
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
    
    func isGymStatusChangingSoon(gym: Gym) -> Bool {
        let changingSoonThreshold = 3600.0
        let now = Date()
        
        if gym.isOpen {
            return (gym.gymHoursToday.closeTime - changingSoonThreshold) < now
        } else {
            let openTime = gym.gymHours[now.getIntegerDayOfWeekTomorrow()].openTime + Date.secondsPerDay
            return (openTime - changingSoonThreshold) < now
        }
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
