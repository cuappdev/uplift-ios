//
//  ClassDetailView.swift
//  Fitness
//
//  Created by eoin on 3/4/18.
//  Copyright © 2018 Uplift. All rights reserved.
//

import Bartinter
import Crashlytics
import EventKit
import Kingfisher
import SnapKit
import UIKit

class ClassDetailViewController: UIViewController {

    // MARK: Public data vars
    var gymClassInstance: GymClassInstance!

    // MARK: - Private view vars
    private let addToCalendarButton = UIButton()
    private let addToCalendarLabel = UILabel()
    private let backButton = UIButton()
    private var classCollectionView: UICollectionView!
    private let classImageContainer = UIView()
    private let classImageView = UIImageView()
    private let contentView = UIView()
    private let dateDivider = UIView()
    private let dateLabel = UILabel()
    private let descriptionTextView = UITextView()
    private let durationLabel = UILabel()
    private let favoriteButton = UIButton()
    private let functionDescriptionLabel = UILabel(frame: CGRect(x: 10, y: 511, width: 100, height: 19))
    private let functionDivider = UIView()
    private let functionLabel = UILabel()
    private let imageFilterView = UIView()
    private let instructorButton = UIButton()
    private let locationButton = UIButton()
    private let nextSessionsLabel = UILabel()
    private let scrollView = UIScrollView()
    private let semicircleView = UIImageView(image: #imageLiteral(resourceName: "semicircle"))
    private let shareButton = UIButton()
    private let timeLabel = UILabel()
    private let titleLabel = UILabel()

    // MARK: - Private data vars
    private var date: Date!
    private var location: String!
    private var isFavorite: Bool! {
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

    private var nextSessions: [GymClassInstance]! {
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

        // MARK: - Fabric
        Answers.logCustomEvent(withName: "Checking Class Details", customAttributes: [
            "Class Name": gymClassInstance.className
            ])

        let edgeSwipe = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(back))
        edgeSwipe.edges = .left
        contentView.addGestureRecognizer(edgeSwipe)

        setupScrollView()
        setupContentView()
        setupHeader()
        setupDateLabel()
        setupTimeLabel()
        setupAddToCalendarButton()
        setupAddToCalendarLabel()
        setupDateDivider()
        setupFunctionLabel()
        setupFunctionDescriptionLabel()
        setupDescriptionTextView()
        setupNextSessionsLabel()
        setupClassCollectionView()

        contentView.bringSubviewToFront(backButton)
        contentView.bringSubviewToFront(shareButton)
        contentView.bringSubviewToFront(favoriteButton)

        nextSessions = []
        let favorites = UserDefaults.standard.stringArray(forKey: Identifiers.favorites) ?? []
        isFavorite = favorites.contains(gymClassInstance.classDetailId)

        NetworkManager.shared.getGymClassInstancesByClass(gymClassDetailIds: [gymClassInstance.classDetailId]) { gymClasses in
            self.nextSessions = gymClasses
        }

        setupConstraints()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let favorites = UserDefaults.standard.stringArray(forKey: Identifiers.favorites) ?? []
        isFavorite = favorites.contains(gymClassInstance.classDetailId)

        switch UIApplication.shared.statusBarStyle {
        case .lightContent:
            backButton.setImage(UIImage(named: "back-arrow"), for: .normal)
            favoriteButton.setImage(UIImage(named: "white-star"), for: .normal)
            favoriteButton.setImage(UIImage(named: "yellow-white-star"), for: .selected)
            shareButton.setImage(UIImage(named: "share_light"), for: .normal)
        case .default:
            backButton.setImage(UIImage(named: "darkBackArrow"), for: .normal)
            favoriteButton.setImage(UIImage(named: "blackStar"), for: .normal)
            favoriteButton.setImage(UIImage(named: "yellow-white-star"), for: .selected)
            shareButton.setImage(UIImage(named: "share_dark"), for: .normal)
        }
    }

    func remakeConstraints() {
        classCollectionView.snp.updateConstraints { make in
            make.height.equalTo(classCollectionView.numberOfItems(inSection: 0) * 112)
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
        // MARK: - Fabric
        if isFavorite {
            Answers.logCustomEvent(withName: "Added Class To Favourites", customAttributes: [
                "Class Name": gymClassInstance.className
                ])
        }
    }

    @objc func share() {

        Answers.logCustomEvent(withName: "Shared Class", customAttributes: [
            "Class": gymClassInstance.className
            ])

        let shareText = """
        \(gymClassInstance.className) from \(gymClassInstance.startTime.getStringOfDatetime(format: "h:mm")) \
        to \(gymClassInstance.endTime.getStringOfDatetime(format: "h:mm")) \
        on \(gymClassInstance.startTime.getStringOfDatetime(format: "M/d")) \
        at \(gymClassInstance.location). Wanna go with me?
        """

        let activityVC = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)

        activityVC.excludedActivityTypes = [.print, .assignToContact, .openInIBooks, .addToReadingList, .markupAsPDF, .airDrop]
        activityVC.popoverPresentationController?.sourceView = view

        self.navigationController?.present(activityVC, animated: true, completion: nil)
    }

    @objc func instructorSelected() {
        // leaving as a stub, future designs will make use of this
    }

    @objc func locationSelected() {
        NetworkManager.shared.getGym(id: gymClassInstance.gymId) { gym in
            let gymDetailViewController = GymDetailViewController()
            gymDetailViewController.gym = gym
            self.navigationController?.pushViewController(gymDetailViewController, animated: true)
        }
    }

    @objc func addToCalendar() {
        let store = EKEventStore()
        store.requestAccess(to: .event) { (granted, error) in
            guard error == nil,
                granted,
                let gymClassInstance = self.gymClassInstance else { self.noAccess(); return }
            let event = EKEvent(eventStore: store)
            event.title = gymClassInstance.className
            event.startDate = gymClassInstance.startTime
            event.endDate = gymClassInstance.endTime
            event.structuredLocation = EKStructuredLocation(title: gymClassInstance.location)
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
        cell.configure(gymClassInstance: nextSessions[indexPath.item], style: .date)
        cell.delegate = self
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let classDetailViewController = ClassDetailViewController()
        classDetailViewController.gymClassInstance = nextSessions[indexPath.item]
        navigationController?.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(classDetailViewController, animated: true)
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
            shareButton.setImage(UIImage(named: "share_light"), for: .normal)
        case .default:
            backButton.setImage(UIImage(named: "darkBackArrow"), for: .normal)
            favoriteButton.setImage(UIImage(named: "blackStar"), for: .normal)
            favoriteButton.setImage(UIImage(named: "yellow-white-star"), for: .selected)
            shareButton.setImage(UIImage(named: "share_dark"), for: .normal)
        }
    }

}

// MARK: - ClassListCellDelegate
extension ClassDetailViewController: ClassListCellDelegate {

    func toggleFavorite(classDetailId: String) {
        isFavorite.toggle()
    }

}

// MARK: - Layout
extension ClassDetailViewController {

    private func setupScrollView() {
        scrollView.showsVerticalScrollIndicator = false
        scrollView.isScrollEnabled = true
        scrollView.bounces = true
        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height * 2.1)
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func setupContentView() {
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.width.equalTo(scrollView)
        }
    }

    private func setupHeader() {
        classImageContainer.backgroundColor = .darkGray
        contentView.addSubview(classImageContainer)

        classImageView.contentMode = .scaleAspectFill
        classImageView.kf.setImage(with: gymClassInstance.imageURL)
        contentView.addSubview(classImageView)

        imageFilterView.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.6)
        contentView.addSubview(imageFilterView)

        semicircleView.contentMode = UIView.ContentMode.scaleAspectFit
        semicircleView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(semicircleView)

        titleLabel.text = gymClassInstance.className
        titleLabel.font = ._48Bebas
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        titleLabel.sizeToFit()
        contentView.addSubview(titleLabel)

        locationButton.setTitleColor(.white, for: .normal)
        locationButton.setTitle(gymClassInstance.location, for: .normal)
        locationButton.titleLabel?.font = ._14MontserratLight
        locationButton.titleLabel?.textAlignment = .center
        locationButton.sizeToFit()
        locationButton.addTarget(self, action: #selector(locationSelected), for: .touchUpInside)
        contentView.addSubview(locationButton)

        instructorButton.setTitle(gymClassInstance.instructor.uppercased(), for: .normal)
        instructorButton.titleLabel?.font = ._16MontserratBold
        instructorButton.titleLabel?.textAlignment = .center
        instructorButton.setTitleColor(.white, for: .normal)
        instructorButton.addTarget(self, action: #selector(instructorSelected), for: .touchUpInside)
        instructorButton.sizeToFit()
        contentView.addSubview(instructorButton)

        durationLabel.font = ._18Bebas
        durationLabel.textAlignment = .center
        durationLabel.textColor = .fitnessBlack
        durationLabel.text = "\(Int(gymClassInstance.duration) / 60) MIN"
        durationLabel.sizeToFit()
        contentView.addSubview(durationLabel)

        backButton.setImage(UIImage(named: "back-arrow"), for: .normal)
        backButton.sizeToFit()
        backButton.addTarget(self, action: #selector(self.back), for: .touchUpInside)
        contentView.addSubview(backButton)

        favoriteButton.setImage(UIImage(named: "white-star"), for: .normal)
        favoriteButton.setImage(UIImage(named: "yellow-white-star"), for: .selected)
        favoriteButton.sizeToFit()
        favoriteButton.addTarget(self, action: #selector(self.favorite), for: .touchUpInside)
        contentView.addSubview(favoriteButton)

        shareButton.setImage(UIImage(named: "share_light"), for: .normal)
        shareButton.sizeToFit()
        shareButton.addTarget(self, action: #selector(self.share), for: .touchUpInside)
        contentView.addSubview(shareButton)
    }

    private func setupDateLabel() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d"
        dateLabel.font = ._16MontserratLight
        dateLabel.textAlignment = .center
        dateLabel.textColor = .fitnessBlack
        dateLabel.text = dateFormatter.string(from: gymClassInstance.startTime)
        dateLabel.sizeToFit()
        contentView.addSubview(dateLabel)
    }

    private func setupTimeLabel() {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: "EDT")!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        let timeLabelText = dateFormatter.string(from: gymClassInstance.startTime) + " - " + dateFormatter.string(from: gymClassInstance.endTime)
        timeLabel.font = ._16MontserratMedium
        timeLabel.textAlignment = .center
        timeLabel.textColor = .fitnessBlack
        timeLabel.text = timeLabelText
        timeLabel.sizeToFit()
        contentView.addSubview(timeLabel)
    }

    private func setupAddToCalendarButton() {
        addToCalendarButton.setImage(#imageLiteral(resourceName: "calendar-icon"), for: .normal) //temp
        addToCalendarButton.sizeToFit()
        contentView.addSubview(addToCalendarButton)
    }

    private func setupAddToCalendarLabel() {
        addToCalendarLabel.text = "ADD TO CALENDAR"
        addToCalendarLabel.font = ._8SFBold
        addToCalendarLabel.textAlignment = .center
        addToCalendarLabel.textColor = .fitnessBlack
        addToCalendarLabel.sizeToFit()
        addToCalendarButton.addTarget(self, action: #selector(addToCalendar), for: .touchUpInside)
        contentView.addSubview(addToCalendarLabel)
    }

    private func setupDateDivider() {
        dateDivider.backgroundColor = .fitnessLightGrey
        contentView.addSubview(dateDivider)
    }

    private func setupFunctionLabel() {
        functionLabel.text = "FUNCTION"
        functionLabel.font = ._16MontserratMedium
        functionLabel.textAlignment = .center
        functionLabel.textColor = .fitnessBlack
        functionLabel.sizeToFit()
        contentView.addSubview(functionLabel)
    }

    private func setupFunctionDescriptionLabel() {
        functionDescriptionLabel.text = gymClassInstance.tags.map { $0.name }.joined(separator: " · ")
        functionDescriptionLabel.font = ._14MontserratLight
        functionDescriptionLabel.textAlignment = .center
        functionDescriptionLabel.textColor = .fitnessBlack
        functionDescriptionLabel.sizeToFit()
        contentView.addSubview(functionDescriptionLabel)

        functionDivider.backgroundColor = .fitnessLightGrey
        contentView.addSubview(functionDivider)
    }

    private func setupDescriptionTextView() {
        descriptionTextView.text = gymClassInstance.classDescription
        descriptionTextView.font = ._14MontserratLight
        descriptionTextView.isEditable = false
        descriptionTextView.textAlignment = .center
        descriptionTextView.sizeToFit()
        descriptionTextView.isScrollEnabled = false
        contentView.addSubview(descriptionTextView)
    }

    private func setupNextSessionsLabel() {
        nextSessionsLabel.font = ._12LatoBlack
        nextSessionsLabel.textColor = .fitnessDarkGrey
        nextSessionsLabel.text = "NEXT SESSIONS"
        nextSessionsLabel.textAlignment = .center
        nextSessionsLabel.sizeToFit()
        contentView.addSubview(nextSessionsLabel)
    }

    private func setupClassCollectionView() {
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
        classCollectionView.delaysContentTouches = false
        classCollectionView.register(ClassListCell.self, forCellWithReuseIdentifier: ClassListCell.identifier)
        classCollectionView.dataSource = self
        classCollectionView.delegate = self
        contentView.addSubview(classCollectionView)
    }

    // MARK: - CONSTRAINTS
    // swiftlint:disable:next function_body_length
    private func setupConstraints() {
        let addToCalendarButtonSize = CGSize(width: 23, height: 23)
        let addToCalendarButtonTopPadding = 26
        let addToCalendarLabelHeight = 10
        let addToCalendarLabelTopPadding = 5
        let backButtonLeftPadding = 20
        let backButtonSize = CGSize(width: 23, height: 19)
        let backButtonTopPadding = 30
        let classCollectionViewTopPadding = 32
        let classImageContainerHeight = 360
        let dateDividerHeight = 1
        let dateDividerTopPadding = 32
        let dateLabelHeight = 19
        let dateLabelTopPadding = 36
        let descriptionTextViewHorizontalPadding = 40
        let dividerSpacing = 24
        let durationLabelBottomPadding = 5
        let durationLabelSize = CGSize(width: 50, height: 21)
        let favoriteButtonRightPadding = 21
        let favoriteButtonSize = CGSize(width: 23, height: 22)
        let functionDescriptionLabelHeight = 20
        let functionDescriptionLabelTopPadding = 12
        let functionDividerHeight = 1
        let functionLabelHeight = 19
        let instructorButtonHeight = 21
        let instructorButtonTopPadding = 20
        let locationButtonHeight = 16
        let nextSessionsLabelHeight = 15
        let nextSessionsLabelTopPadding = 64
        let semicircleViewSize = CGSize(width: 100, height: 50)
        let shareButtonRightPadding = 14
        let shareButtonSize = CGSize(width: 22, height: 22)
        let timeLabelHeight = 19
        let timeLabelTopPadding = 8
        let titleLabelHeight = 57
        let titleLabelTopPadding = 126

        classImageContainer.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view)
            make.top.equalTo(scrollView)
            make.height.equalTo(classImageContainerHeight)
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
            make.size.equalTo(semicircleViewSize)
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview().offset(titleLabelTopPadding)
            make.trailing.equalToSuperview()
            make.height.equalTo(titleLabelHeight)
        }

        locationButton.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom)
            make.trailing.equalToSuperview()
            make.height.equalTo(locationButtonHeight)
        }

        instructorButton.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(locationButton.snp.bottom).offset(instructorButtonTopPadding)
            make.trailing.equalToSuperview()
            make.height.equalTo(instructorButtonHeight)
        }

        durationLabel.snp.makeConstraints { make in
            make.bottom.equalTo(classImageView.snp.bottom).offset(-durationLabelBottomPadding)
            make.centerX.equalToSuperview()
            make.size.equalTo(durationLabelSize)
        }

        backButton.snp.makeConstraints { make in
            make.leading.equalTo(view).offset(backButtonLeftPadding)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(backButtonTopPadding)
            make.size.equalTo(backButtonSize)
        }

        favoriteButton.snp.makeConstraints { make in
            make.trailing.equalTo(view).offset(-favoriteButtonRightPadding)
            make.top.equalTo(backButton.snp.top)
            make.size.equalTo(favoriteButtonSize)
        }

        shareButton.snp.makeConstraints { make in
            make.trailing.equalTo(favoriteButton.snp.leading).offset(-shareButtonRightPadding)
            make.top.equalTo(favoriteButton.snp.top)
            make.size.equalTo(shareButtonSize)
        }

        dateLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(classImageView.snp.bottom).offset(dateLabelTopPadding)
            make.trailing.equalToSuperview()
            make.height.equalTo(dateLabelHeight)
        }

        timeLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(dateLabel.snp.bottom).offset(timeLabelTopPadding)
            make.trailing.equalToSuperview()
            make.height.equalTo(timeLabelHeight)
        }

        addToCalendarButton.snp.makeConstraints { make in
            make.size.equalTo(addToCalendarButtonSize)
            make.centerX.equalToSuperview()
            make.top.equalTo(timeLabel.snp.bottom).offset(addToCalendarButtonTopPadding)
        }

        addToCalendarLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(addToCalendarButton.snp.bottom).offset(addToCalendarLabelTopPadding)
            make.trailing.equalToSuperview()
            make.height.equalTo(addToCalendarLabelHeight)
        }

        dateDivider.snp.makeConstraints { make in
            make.height.equalTo(dateDividerHeight)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(addToCalendarLabel.snp.bottom).offset(dateDividerTopPadding)
        }

        functionLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(dateDivider.snp.bottom).offset(dividerSpacing)
            make.trailing.equalToSuperview()
            make.height.equalTo(functionLabelHeight)
        }

        functionDescriptionLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(functionLabel.snp.bottom).offset(functionDescriptionLabelTopPadding)
            make.trailing.equalToSuperview()
            make.height.equalTo(functionDescriptionLabelHeight)
        }

        functionDivider.snp.makeConstraints { make in
            make.height.equalTo(functionDividerHeight)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(functionDescriptionLabel.snp.bottom).offset(dividerSpacing)
        }

        descriptionTextView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(descriptionTextViewHorizontalPadding)
            make.trailing.equalToSuperview().offset(-descriptionTextViewHorizontalPadding)
            make.top.equalTo(functionDivider.snp.bottom).offset(dividerSpacing)
        }

        nextSessionsLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(descriptionTextView.snp.bottom).offset(nextSessionsLabelTopPadding)
            make.height.equalTo(nextSessionsLabelHeight)
        }

        classCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(nextSessionsLabel.snp.bottom).offset(classCollectionViewTopPadding)
            make.bottom.equalToSuperview()
        }
    }

}
