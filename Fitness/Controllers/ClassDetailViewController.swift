//
//  ClassDetailView.swift
//  Fitness
//
//  Created by eoin on 3/4/18.
//  Copyright © 2018 Uplift. All rights reserved.
//

import UIKit
import SnapKit
import EventKit
import Kingfisher
import Bartinter

class ClassDetailViewController: UIViewController {

    // MARK: - INITIALIZATION
    var gymClassInstance: GymClassInstance!

    var titleLabel: UILabel!
    var locationLabel = UILabel()
    var instructorLabel: UILabel!
    var durationLabel = UILabel()
    var location: String!

    var classImageContainer: UIView!
    var classImageView = UIImageView()
    var imageFilterView: UIView!
    var semicircleView: UIImageView!

    var backButton: UIButton!
    var favoriteButton = UIButton()
    var isFavorite: Bool! {
        didSet {
            if oldValue == isFavorite { return }

            let defaults = UserDefaults.standard
            var favorites = defaults.stringArray(forKey: Identifiers.favorites) ?? []

            if isFavorite {
                favoriteButton.isSelected = true
                if !favorites.contains(gymClassInstance.classDetailId) {
                    favorites.append(gymClassInstance.classDetailId)
                    defaults.set(favorites, forKey: Identifiers.favorites)
                }
            } else {
                favoriteButton.isSelected = false
                if favorites.contains(gymClassInstance.classDetailId) {
                    favorites = favorites.filter {$0 != gymClassInstance.classDetailId}
                    defaults.set(favorites, forKey: Identifiers.favorites)
                }
            }

            for i in 0..<classCollectionView.numberOfItems(inSection: 0) {
                let cell = classCollectionView.cellForItem(at: IndexPath(item: i, section: 0)) as! ClassListCell
                cell.isFavorite = isFavorite
            }
        }
    }

    var dateLabel = UILabel()
    var timeLabel = UILabel()
    var date: Date!

    var addToCalendarButton: UIButton!
    var addToCalendarLabel: UILabel!

    var functionLabel: UILabel!
    var functionDescriptionLabel: UILabel!

    var descriptionTextView: UITextView!

    var dateDivider: UIView!
    var functionDivider: UIView!

    var scrollView: UIScrollView!
    var contentView: UIView!

    var nextSessionsLabel: UILabel!
    var classCollectionView: UICollectionView!
    var nextSessions: [GymClassInstance]! {
        didSet {
            classCollectionView.reloadData()
            remakeConstraints()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController!.isNavigationBarHidden = true
    }

    //swiftlint:disable:next function_body_length
    override func viewDidLoad() {
        super.viewDidLoad()
        updatesStatusBarAppearanceAutomatically = true
        view.backgroundColor = .white

        scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.isScrollEnabled = true
        scrollView.bounces = true
        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height * 2.1)
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        contentView = UIView()
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.width.equalTo(scrollView)
        }

        let edgeSwipe = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(back))
        edgeSwipe.edges = .left
        contentView.addGestureRecognizer(edgeSwipe)

        // HEADER
        setupHeader()

        // DATE
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d"
        dateLabel.font = ._16MontserratLight
        dateLabel.textAlignment = .center
        dateLabel.textColor = .fitnessBlack
        dateLabel.text = dateFormatter.string(from: gymClassInstance.startTime)
        dateLabel.sizeToFit()
        contentView.addSubview(dateLabel)

        var calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: "EDT")!
        dateFormatter.dateFormat = "h:mm a"
        let timeLabelText = dateFormatter.string(from: gymClassInstance.startTime) + " - " + dateFormatter.string(from: gymClassInstance.endTime)

        timeLabel.font = ._16MontserratMedium
        timeLabel.textAlignment = .center
        timeLabel.textColor = .fitnessBlack
        timeLabel.text = timeLabelText
        timeLabel.sizeToFit()
        contentView.addSubview(timeLabel)

        // CALENDAR
        addToCalendarButton = UIButton()
        addToCalendarButton.setImage(#imageLiteral(resourceName: "calendar-icon"), for: .normal) //temp
        addToCalendarButton.sizeToFit()
        contentView.addSubview(addToCalendarButton)

        addToCalendarLabel = UILabel()
        addToCalendarLabel.text = "ADD TO CALENDAR"
        addToCalendarLabel.font = ._8SFBold
        addToCalendarLabel.textAlignment = .center
        addToCalendarLabel.textColor = .fitnessBlack
        addToCalendarLabel.sizeToFit()
        addToCalendarButton.addTarget(self, action: #selector(addToCalendar), for: .touchUpInside)
        contentView.addSubview(addToCalendarLabel)

        dateDivider = UIView()
        dateDivider.backgroundColor = .fitnessLightGrey
        contentView.addSubview(dateDivider)

        //FUNCTION
        functionLabel = UILabel()
        functionLabel.text = "FUNCTION"
        functionLabel.font = ._16MontserratMedium
        functionLabel.textAlignment = .center
        functionLabel.textColor = .fitnessBlack
        functionLabel.sizeToFit()
        contentView.addSubview(functionLabel)

        functionDescriptionLabel = UILabel(frame: CGRect(x: 10, y: 511, width: 100, height: 19))
        functionDescriptionLabel.text = gymClassInstance.tags.map { $0.name }.joined(separator: " · ")
        functionDescriptionLabel.font = ._14MontserratLight
        functionDescriptionLabel.textAlignment = .center
        functionDescriptionLabel.textColor = .fitnessBlack
        functionDescriptionLabel.sizeToFit()
        contentView.addSubview(functionDescriptionLabel)

        functionDivider = UIView()
        functionDivider.backgroundColor = .fitnessLightGrey
        contentView.addSubview(functionDivider)

        // DESCRIPTION
        descriptionTextView = UITextView()
        descriptionTextView.text = gymClassInstance.classDescription
        descriptionTextView.font = ._14MontserratLight
        descriptionTextView.isEditable = false
        descriptionTextView.textAlignment = .center
        descriptionTextView.sizeToFit()
        descriptionTextView.isScrollEnabled = false
        contentView.addSubview(descriptionTextView)

        // NEXT SESSIONS
        nextSessionsLabel = UILabel()
        nextSessionsLabel.font = ._12LatoBlack
        nextSessionsLabel.textColor = .fitnessDarkGrey
        nextSessionsLabel.text = "NEXT SESSIONS"
        nextSessionsLabel.textAlignment = .center
        nextSessionsLabel.sizeToFit()
        contentView.addSubview(nextSessionsLabel)

        let classFlowLayout = UICollectionViewFlowLayout()
        classFlowLayout.itemSize = CGSize(width: view.bounds.width - 32.0, height: 100.0)
        classFlowLayout.minimumLineSpacing = 12.0
        classFlowLayout.headerReferenceSize = .zero

        classCollectionView = UICollectionView(frame: .zero, collectionViewLayout: classFlowLayout)
        classCollectionView.bounces = false
        classCollectionView.showsVerticalScrollIndicator = false
        classCollectionView.showsHorizontalScrollIndicator = false
        classCollectionView.backgroundColor = .white
        classCollectionView.clipsToBounds = false

        classCollectionView.register(ClassListCell.self, forCellWithReuseIdentifier: ClassListCell.identifier)

        classCollectionView.dataSource = self
        classCollectionView.delegate = self
        contentView.addSubview(classCollectionView)

        nextSessions = []
        let favorites = UserDefaults.standard.stringArray(forKey: Identifiers.favorites) ?? []
        isFavorite = favorites.contains(gymClassInstance.classDetailId)

        NetworkManager.shared.getGymClassInstancesByClass(gymClassDetailIds: [gymClassInstance.classDetailId]) { gymClasses in
            self.nextSessions = gymClasses
        }

        setupConstraints()
    }

    func setupHeader() {
        classImageContainer = UIView()
        classImageContainer.backgroundColor = .darkGray
        contentView.addSubview(classImageContainer)

        classImageView.contentMode = .scaleAspectFill
        classImageView.kf.setImage(with: gymClassInstance.imageURL)
        contentView.addSubview(classImageView)

        imageFilterView = UIView()
        imageFilterView.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.6)
        contentView.addSubview(imageFilterView)

        semicircleView = UIImageView(image: #imageLiteral(resourceName: "semicircle"))
        semicircleView.contentMode = UIView.ContentMode.scaleAspectFit
        semicircleView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(semicircleView)

        titleLabel = UILabel()
        titleLabel.text = gymClassInstance.className
        titleLabel.font = ._48Bebas
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        titleLabel.sizeToFit()
        contentView.addSubview(titleLabel)

        locationLabel.font = ._14MontserratLight
        locationLabel.textAlignment = .center
        locationLabel.textColor = .white
        locationLabel.text = gymClassInstance.location
        locationLabel.sizeToFit()
        contentView.addSubview(locationLabel)

        instructorLabel = UILabel()
        instructorLabel.text = gymClassInstance.instructor
        instructorLabel.font = ._18Bebas
        instructorLabel.textAlignment = .center
        instructorLabel.textColor = .white
        instructorLabel.sizeToFit()
        contentView.addSubview(instructorLabel)

        durationLabel.font = ._18Bebas
        durationLabel.textAlignment = .center
        durationLabel.textColor = .fitnessBlack
        durationLabel.text = "\(Int(gymClassInstance.duration) / 60) MIN"
        durationLabel.sizeToFit()
        contentView.addSubview(durationLabel)

        backButton = UIButton()
        backButton.setImage(UIImage(named: "back-arrow"), for: .normal)
        backButton.sizeToFit()
        backButton.addTarget(self, action: #selector(self.back), for: .touchUpInside)
        contentView.addSubview(backButton)

        favoriteButton.setImage(UIImage(named: "white-star"), for: .normal)
        favoriteButton.setImage(UIImage(named: "yellow-white-star"), for: .selected)
        favoriteButton.sizeToFit()
        favoriteButton.addTarget(self, action: #selector(self.favorite), for: .touchUpInside)
        contentView.addSubview(favoriteButton)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let favorites = UserDefaults.standard.stringArray(forKey: Identifiers.favorites) ?? []
        isFavorite = favorites.contains(gymClassInstance.classDetailId)
    }

    // MARK: - CONSTRAINTS
    func setupConstraints() {
        // HEADER
        let dividerSpacing = 24

        classImageContainer.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view)
            make.top.equalTo(scrollView)
            make.height.equalTo(360)
        }

        classImageView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(classImageContainer)
            make.top.equalTo(view).priority(.high)
            make.height.greaterThanOrEqualTo(classImageContainer).priority(.high)
            make.bottom.equalTo(classImageContainer)
        }

        imageFilterView.snp.makeConstraints { make in
            make.edges.equalTo(classImageView)
        }

        semicircleView.snp.makeConstraints { make in
            make.bottom.equalTo(classImageView.snp.bottom)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(100)
        }

        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalToSuperview().offset(126)
            make.right.equalToSuperview()
            make.height.equalTo(57)
        }

        locationLabel.snp.makeConstraints { make in
                make.left.equalToSuperview()
                make.top.equalTo(titleLabel.snp.bottom)
                make.right.equalToSuperview()
                make.height.equalTo(16)
        }

        instructorLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(locationLabel.snp.bottom).offset(20)
            make.right.equalToSuperview()
            make.height.equalTo(21)
        }

        durationLabel.snp.makeConstraints { make in
            make.bottom.equalTo(classImageView.snp.bottom).offset(-5)
            make.centerX.equalToSuperview()
            make.width.equalTo(50)
            make.height.equalTo(21)
        }

        backButton.snp.makeConstraints { make in
            make.left.equalTo(view).offset(20)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(30)
            make.width.equalTo(23)
            make.height.equalTo(19)
        }

        favoriteButton.snp.makeConstraints { make in
            make.right.equalTo(view).offset(-21)
            make.top.equalTo(backButton.snp.top)
            make.width.equalTo(23)
            make.height.equalTo(22)
        }

        // DATE
        dateLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(classImageView.snp.bottom).offset(36)
            make.right.equalToSuperview()
            make.height.equalTo(19)
        }

        timeLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(dateLabel.snp.bottom).offset(8)
            make.right.equalToSuperview()
            make.height.equalTo(19)
        }

        // CALENDAR
        addToCalendarButton.snp.makeConstraints { make in
            make.height.equalTo(23)
            make.width.equalTo(23)
            make.centerX.equalToSuperview()
            make.top.equalTo(timeLabel.snp.bottom).offset(26)
        }

        addToCalendarLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(addToCalendarButton.snp.bottom).offset(5)
            make.right.equalToSuperview()
            make.height.equalTo(10)
        }

        dateDivider.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(addToCalendarLabel.snp.bottom).offset(32)
        }

        // FUNCTION
        functionLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(dateDivider.snp.bottom).offset(dividerSpacing)
            make.right.equalToSuperview()
            make.height.equalTo(19)
        }

        functionDescriptionLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(functionLabel.snp.bottom).offset(12)
            make.right.equalToSuperview()
            make.height.equalTo(20)
        }

        functionDivider.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(functionDescriptionLabel.snp.bottom).offset(dividerSpacing)
        }

        // DESCRIPTION
        descriptionTextView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().offset(-40)
            make.top.equalTo(functionDivider.snp.bottom).offset(dividerSpacing)
        }

        // NEXT SESSIONS
        nextSessionsLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(descriptionTextView.snp.bottom).offset(64)
            make.height.equalTo(15)
        }

        classCollectionView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(nextSessionsLabel.snp.bottom).offset(32)
            make.bottom.equalToSuperview()
        }
    }

    func remakeConstraints() {
        classCollectionView.snp.remakeConstraints {make in
            make.left.right.equalToSuperview()
            make.top.equalTo(nextSessionsLabel.snp.bottom).offset(32)
            make.height.equalTo(classCollectionView.numberOfItems(inSection: 0) * 112)
            make.bottom.equalToSuperview()
        }
    }

    // MARK: - BUTTON METHODS
    @objc func back() {
        if let navigationController = navigationController {
            navigationController.popViewController(animated: true)
        }
    }

    @objc func favorite() {
        isFavorite.toggle()
    }

    @objc func addToCalendar() {
        let store = EKEventStore()
        store.requestAccess(to: .event) { (granted, error) in
            guard granted, let gymClassInstance = self.gymClassInstance else { self.noAccess(); return }

            let event = EKEvent(eventStore: store)
            event.title = gymClassInstance.className
            event.startDate = gymClassInstance.startTime
            event.endDate = gymClassInstance.endTime
            event.location = self.location
            event.calendar = store.defaultCalendarForNewEvents

            DispatchQueue.main.async {
                let alert = UIAlertController(title: "\(self.gymClassInstance.className) added to calendar", message: "Get ready to get sweaty", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Dismiss calendar alert"), style: .default))
                self.present(alert, animated: true, completion: nil)
            }

            do {
                try store.save(event, span: .thisEvent, commit: true)
            } catch {
                // should not happen
            }
        }
    }

    func noAccess() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Cannot add to calendar", message: "Uplift does not have permission to acess your calendar", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Dismiss calendar alert"), style: .default))

            let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }

                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: nil )
                }
            }

            alert.addAction(settingsAction)

            self.present(alert, animated: true, completion: nil)
        }
    }
}

// MARK: - CollectionViewDataSource, CollectionViewDelegate
extension ClassDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nextSessions.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ClassListCell.identifier, for: indexPath) as! ClassListCell

        let gymClassInstance = nextSessions[indexPath.item]

        cell.classLabel.text = gymClassInstance.className
        cell.locationLabel.text = gymClassInstance.location
        cell.instructorLabel.text = gymClassInstance.instructor
        cell.durationLabel.text = gymClassInstance.startTime.getStringOfDatetime(format: "h:mma")

        let calendar = Calendar.current

        if calendar.dateComponents([.day], from: gymClassInstance.startTime) == calendar.dateComponents([.day], from: Date()) {
            cell.timeLabel.text = "Today"
        } else {
            cell.timeLabel.text = gymClassInstance.startTime.getStringOfDatetime(format: "MMM d")
        }

        cell.classId = gymClassInstance.classDetailId
        cell.isFavorite = isFavorite
        cell.delegate = self

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let classDetailViewController = ClassDetailViewController()
        classDetailViewController.gymClassInstance = nextSessions[indexPath.item]
        navigationController?.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(classDetailViewController, animated: true)
    }
}

// MARK: - ScrollViewDelegate
extension ClassDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        statusBarUpdater?.refreshStatusBarStyle()

        switch UIApplication.shared.statusBarStyle {
        case .lightContent:
            backButton.setImage(UIImage(named: "back-arrow"), for: .normal)
            favoriteButton.setImage(UIImage(named: "white-star"), for: .normal)
            favoriteButton.setImage(UIImage(named: "yellow-white-star"), for: .selected)
        case .default:
            backButton.setImage(UIImage(named: "back-arrow"), for: .normal)
            favoriteButton.setImage(UIImage(named: "white-star"), for: .normal)
            favoriteButton.setImage(UIImage(named: "yellow-white-star"), for: .selected)
        }
    }
}

// MARK: - ClassListCellDelegate
extension ClassDetailViewController: ClassListCellDelegate {
    func toggleFavorite(classDetailId: String) {
        isFavorite.toggle()
    }
}
