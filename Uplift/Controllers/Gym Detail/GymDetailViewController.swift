//
//  GymDetailViewController.swift
//  Uplift
//
//  Created by Yana Sang on 5/22/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import Crashlytics
import UIKit

class GymDetailViewController: UIViewController {

    // MARK: - Public view vars
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: StretchyHeaderLayout())

    // MARK: - Private data vars
    private var section: Section!

    // MARK: - Public data vars
    var gymDetail: Gym!

    // TODO: - Move to cell classes
//    private enum Constants {
//        static let gymDetailHoursCellIdentifier = "gymDetailHoursCellIdentifier"
//        static let gymDetailFacilitiesCellIdentifier = "gymDetailFacilitiesCellIdentifier"
//        static let gymDetailPopularTimesCellIdentifier = "gymDetailPopularTimesCellIdentifier"
//    }

    // MARK: - Private classes/enums
    private struct Section {
        var items: [ItemType]
    }

    private enum ItemType {
        case hours
        // TODO: - Reimplement necesary items
//        case busyTimes
//        case classes([GymClassInstance])
//        case facilities([FacilityDropdown])
    }

    // MARK: - Custom Initializer
    init(gym: Gym) {
        super.init(nibName: nil, bundle: nil)
        gymDetail = gym
        section = Section(items: [.hours])
        collectionView.backgroundColor = .white
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        updatesStatusBarAppearanceAutomatically = true
        view.backgroundColor = .white

        // MARK: - Fabric
//        Answers.logCustomEvent(withName: "Checking Gym Details")

        let edgeSwipe = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(back))
        edgeSwipe.edges = .left
        view.addGestureRecognizer(edgeSwipe)

        setupViews()
        setupConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }

    // MARK: - Targets
    @objc func back() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - CollectionViewDataSource, CollectionViewDelegate, CollectionViewDelegateFlowLayout
extension GymDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.section.items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let itemType = section.items[indexPath.item]

        switch itemType {
        case .hours:
            // swiftlint:disable:next force_cast
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GymDetailHoursCell.reuseId, for: indexPath) as! GymDetailHoursCell
            cell.configure(for: self, hours: gymDetail.hours, isDisclosed: gymDetail.hoursIsDisclosed)
            return cell

            // TODO: - Reimplement necessary items
//        case .busyTimes:
//            // swiftlint:disable:next force_cast
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.gymDetailPopularTimesCellIdentifier, for: indexPath) as! GymDetailPopularTimesCell
//            cell.configure(for: gymDetail.gym, selectedPopularTimeIndex: selectedPopularTimeIndex) { index in
//                self.selectedPopularTimeIndex = index
//            }
//            return cell
//        case .facilities:
//            // swiftlint:disable:next force_cast
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.gymDetailFacilitiesCellIdentifier, for: indexPath) as! GymDetailFacilitiesCell
//
//            let itemType = section.items[indexPath.row]
//            var facilityDropdowns: [FacilityDropdown] = []
//            if case .facilities(let dropdowns) = itemType {
//                facilityDropdowns = dropdowns
//            }
//            let reloadFacilitiesCellAt: (Int?) -> Void = { index in
//                // Set the current dropdown status (closed or open) at that index to its opposite
//                if let index = index {
//                    let dropdownStatus = facilityDropdowns[index].dropdownStatus
//                    facilityDropdowns[index].dropdownStatus = dropdownStatus == .closed
//                        ? .open
//                        : .closed
//                }
//                UIView.performWithoutAnimation {
//                    self.collectionView.reloadItems(at: [indexPath])
//                }
//            }
//            cell.backgroundColor = .white
//            cell.configure(for: facilityDropdowns,
//                           reloadGymDetailCollectionViewClosure: reloadFacilitiesCellAt)
//            return cell
//        case .classes:
//            // swiftlint:disable:next force_cast
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.gymDetailClassesCellIdentifier, for: indexPath) as! GymDetailTodaysClassesCell
//            cell.configure(for: self, classes: todaysClasses)
//            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height: CGFloat

        switch section.items[indexPath.item] {
        case .hours:
            height = getHoursHeight()
        }

        return CGSize(width: collectionView.frame.width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: GymDetailHeaderView.reuseId,
            // swiftlint:disable:next force_cast
            for: indexPath) as! GymDetailHeaderView
        headerView.configure(for: self, for: gymDetail)
        return headerView
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 360)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

}

// MARK: - Layout
extension GymDetailViewController {

    private func setupViews() {
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false

        collectionView.register(GymDetailHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: GymDetailHeaderView.reuseId)

        collectionView.register(GymDetailHoursCell.self, forCellWithReuseIdentifier: GymDetailHoursCell.reuseId)
        // TODO: - Reimplement
//        collectionView.register(GymDetailFacilitiesCell.self, forCellWithReuseIdentifier: Constants.gymDetailFacilitiesCellIdentifier)
//        collectionView.register(GymDetailTodaysClassesCell.self, forCellWithReuseIdentifier: GymDetailHoursCell.reuseId)

        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
    }

    private func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

}

// MARK: - Item Height Calculations
extension GymDetailViewController {

    func getHoursHeight() -> CGFloat {
        var height = GymDetailConstraints.cellPadding + GymDetailHoursCell.LayoutConstants.hoursTableViewTopPadding + GymDetailHoursCell.LayoutConstants.hoursTableViewBottomRowHeight

        if gymDetail.hoursIsDisclosed {
            height += CGFloat(gymDetail.hours.getNumHoursLines() - 1) * GymDetailHoursCell.LayoutConstants.hoursTableViewRowHeight
        }

        return height
    }

    // TODO: - Reimplement what's necessary
//    func getFacilitiesHeight(_ facilityDropdowns: [FacilityDropdown]) -> CGFloat {
//        return GymDetailFacilitiesCell.getHeights(for: facilityDropdowns) + 2 * GymDetailConstraints.verticalPadding + GymDetailConstraints.titleLabelHeight
//    }
//
//    func getTodaysClassesHeight() -> CGFloat {
//        let baseHeight = GymDetailConstraints.verticalPadding +
//            GymDetailConstraints.titleLabelHeight
//
//        let noMoreClassesHeight = GymDetailTodaysClassesCell.Constants.noMoreClassesLabelTopPadding +
//            GymDetailTodaysClassesCell.Constants.noMoreClassesLabelHeight +
//            GymDetailConstraints.verticalPadding
//
//        let collectionViewHeight = 2.0 * GymDetailTodaysClassesCell.Constants.classesCollectionViewVerticalPadding +
//            classesCollectionViewHeight()
//
//        return (todaysClasses.isEmpty) ? baseHeight + noMoreClassesHeight : baseHeight + collectionViewHeight
//    }
//
//    private func classesCollectionViewHeight() -> CGFloat {
//        let cellPadding: CGFloat = 12
//        let cellHeight: CGFloat = 100
//        let numberOfClasses = CGFloat(todaysClasses.count)
//
//        return numberOfClasses * cellHeight + (numberOfClasses - 1) * cellPadding
//    }
}
