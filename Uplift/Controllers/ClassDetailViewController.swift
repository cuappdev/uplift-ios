//
//  ClassDetailViewController.swift
//  Uplift
//
//  Created by Kevin Chan on 5/18/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import Bartinter
import Crashlytics
import SnapKit
import UIKit

class ClassDetailViewController: UIViewController {

    // MARK: - Public data vars
    var gymClassInstance: GymClassInstance!
    var isFavorite: Bool! {
        didSet {
            if oldValue == isFavorite { return }
            isFavoriteToggled()
        }
    }

    // MARK: - Private view vars
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: StretchyHeaderLayout())

    // MARK: - Private data vars
    private var date: Date!
    private var location: String!
    private var sections: [Section] = []
    private var headerView: ClassDetailHeaderView?

    private enum Constants {
        static let classDetailDescriptionCellIdentifier = "classDetailDescriptionCellIdentifier"
        static let classDetailFunctionCellIdentifier = "classDetailFunctionCellIdentifier"
        static let classDetailHeaderViewIdentifier = "classDetailHeaderViewIdentifier"
        static let classDetailNextSessionsCellIdentifier = "classDetailNextSessionsCellIdentifier"
        static let classDetailTimeCellIdentifier = "classDetailTimeCellIdentifier"
    }

    // MARK: - Private classes/enums
    private struct Section {
        var items: [ItemType]
    }

    private enum ItemType {
        case description
        case function
        case nextSessions([GymClassInstance])
        case time
    }

    // MARK: - Custom Initializer
    init(gymClassInstance: GymClassInstance) {
        super.init(nibName: nil, bundle: nil)
        self.gymClassInstance = gymClassInstance
        self.sections = gymClassInstance.tags.isEmpty ? [
            Section(items: [.time, .description, .nextSessions([])])
        ] : [
            Section(items: [.time, .function, .description, .nextSessions([])])
        ]
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

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
        view.addGestureRecognizer(edgeSwipe)

        setupViews()

        let favorites = UserDefaults.standard.stringArray(forKey: Identifiers.favoriteClasses) ?? []
        isFavorite = favorites.contains(gymClassInstance.classDetailId)

        NetworkManager.shared.getGymClassInstancesByClass(gymClassDetailIds: [gymClassInstance.classDetailId]) { gymClasses in
            let items = self.sections[0].items
            self.sections[0].items[items.count - 1] = .nextSessions(gymClasses)
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }

        setupConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let favorites = UserDefaults.standard.stringArray(forKey: Identifiers.favoriteClasses) ?? []
        isFavorite = favorites.contains(gymClassInstance.classDetailId)
    }

    func favoriteButtonTapped() {
        isFavorite.toggle()
        // Log to fabric
        if isFavorite {
            Answers.logCustomEvent(withName: "Added Class To Favourites", customAttributes: [
                "Class Name": gymClassInstance.className
                ])
        }
    }

    func share() {
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

        activityVC.excludedActivityTypes = [.print, .assignToContact, .openInIBooks, .addToReadingList, .airDrop]
        activityVC.popoverPresentationController?.sourceView = view

        self.navigationController?.present(activityVC, animated: true, completion: nil)
    }

    // MARK: - Targets

    @objc func back() {
        navigationController?.popViewController(animated: true)
    }

    // MARK: - Private helpers
    private func isFavoriteToggled() {
        let defaults = UserDefaults.standard
        var favorites = defaults.stringArray(forKey: Identifiers.favoriteClasses) ?? []

        if isFavorite {
            headerView?.selectFavoriteButton()
            if !favorites.contains(gymClassInstance.classDetailId) {
                favorites.append(gymClassInstance.classDetailId)
                defaults.set(favorites, forKey: Identifiers.favoriteClasses)
            }
        } else {
            headerView?.deselectFavoriteButton()
            if favorites.contains(gymClassInstance.classDetailId) {
                favorites = favorites.filter {$0 != gymClassInstance.classDetailId}
                defaults.set(favorites, forKey: Identifiers.favoriteClasses)
            }
        }

        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

// MARK: - CollectionViewDataSource, CollectionViewDelegate
extension ClassDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let itemType = sections[indexPath.section].items[indexPath.item]

        switch itemType {
        case .time:
            //swiftlint:disable:next force_cast
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.classDetailTimeCellIdentifier, for: indexPath) as! ClassDetailTimeCell
            cell.configure(for: self, gymClassInstance: gymClassInstance)
            return cell
        case .function:
            //swiftlint:disable:next force_cast
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.classDetailFunctionCellIdentifier, for: indexPath) as! ClassDetailFunctionCell
            cell.configure(for: gymClassInstance)
            return cell
        case .description:
            //swiftlint:disable:next force_cast
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.classDetailDescriptionCellIdentifier, for: indexPath) as! ClassDetailDescriptionCell
            cell.configure(for: gymClassInstance)
            return cell
        case .nextSessions(let nextSessions):
            //swiftlint:disable:next force_cast
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.classDetailNextSessionsCellIdentifier, for: indexPath) as! ClassDetailNextSessionsCell
            cell.configure(for: self, nextSessions: nextSessions)
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: Constants.classDetailHeaderViewIdentifier,
            //swiftlint:disable:next force_cast
            for: indexPath) as! ClassDetailHeaderView
        self.headerView = headerView
        headerView.configure(for: self, gymClassInstance: gymClassInstance)
        return headerView
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 360)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let itemType = sections[indexPath.section].items[indexPath.item]

        switch itemType {
        case .time:
            return CGSize(width: width, height: getTimeHeight())
        case .function:
            return CGSize(width: width, height: getFunctionHeight(width: width))
        case .description:
            return CGSize(width: width, height: getDescriptionHeight(width: width))
        case .nextSessions(let nextSessions):
            return CGSize(width: width, height: getNextSessionsHeight(numberOfSessions: CGFloat(nextSessions.count)))
        }
    }

}

// MARK: - Item Height Calculations
extension ClassDetailViewController {
    func getTimeHeight() -> CGFloat {
        return Constraints.verticalPadding + Constraints.titleLabelHeight +
            ClassDetailTimeCell.Constants.timeLabelTopPadding + Constraints.titleLabelHeight +
            ClassDetailTimeCell.Constants.addToCalendarButtonTopPadding +
            ClassDetailTimeCell.Constants.addToCalendarButtonHeight +
            ClassDetailTimeCell.Constants.addToCalendarLabelTopPadding +
            ClassDetailTimeCell.Constants.addToCalendarLabelHeight +
            Constraints.verticalPadding + Constraints.dividerViewHeight
    }

    func getFunctionHeight(width: CGFloat) -> CGFloat {
        let baseHeight = Constraints.verticalPadding + Constraints.titleLabelHeight +
            ClassDetailFunctionCell.Constants.functionDescriptionLabelTopPadding +
            Constraints.verticalPadding + Constraints.dividerViewHeight

        let descriptionLabelWidth = width - CGFloat(ClassDetailFunctionCell.Constants.descriptionLabelHorizontalPadding * 2)
        let string = gymClassInstance.tags.map { $0.name }.joined(separator: " · ")
        let descriptionLabelHeight = string.height(withConstrainedWidth: descriptionLabelWidth, font: UIFont._14MontserratLight!)

        return baseHeight + descriptionLabelHeight
    }

    func getDescriptionHeight(width: CGFloat) -> CGFloat {
        let baseHeight = 2.0 * Constraints.verticalPadding + Constraints.dividerViewHeight

        let descriptionTextViewWidth = width - CGFloat(ClassDetailDescriptionCell.Constants.descriptionTextViewHorizontalPadding * 2)
        let descriptionTextViewHeight = gymClassInstance.classDescription.height(withConstrainedWidth: descriptionTextViewWidth, font: UIFont._14MontserratLight!)

        return baseHeight + descriptionTextViewHeight
    }

    func getNextSessionsHeight(numberOfSessions: CGFloat) -> CGFloat {
        let nextSessionsCellHeight: CGFloat = 112

        let baseHeight = Constraints.verticalPadding + Constraints.titleLabelHeight +
            ClassDetailNextSessionsCell.Constants.collectionViewTopPadding +
            ClassDetailNextSessionsCell.Constants.collectionViewBottomPadding

        let nextSessionsCollectionViewHeight = numberOfSessions * nextSessionsCellHeight

        return baseHeight + nextSessionsCollectionViewHeight
    }
}

// MARK: - Layout
extension ClassDetailViewController {

    private func setupViews() {
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(ClassDetailHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Constants.classDetailHeaderViewIdentifier)
        collectionView.register(ClassDetailTimeCell.self, forCellWithReuseIdentifier: Constants.classDetailTimeCellIdentifier)
        collectionView.register(ClassDetailFunctionCell.self, forCellWithReuseIdentifier: Constants.classDetailFunctionCellIdentifier)
        collectionView.register(ClassDetailDescriptionCell.self, forCellWithReuseIdentifier: Constants.classDetailDescriptionCellIdentifier)
        collectionView.register(ClassDetailNextSessionsCell.self, forCellWithReuseIdentifier: Constants.classDetailNextSessionsCellIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
    }

    // MARK: - CONSTRAINTS
    private func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

}
