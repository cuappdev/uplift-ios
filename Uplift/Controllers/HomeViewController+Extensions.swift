//
//  HomeViewController+Extensions.swift
//  Uplift
//
//  Created by Kevin Chan on 5/20/19.
//  Copyright © 2019 Cornell AppDev. All rights reserved.
//

import UIKit

extension HomeViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
 
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionType = sections[indexPath.section]
        switch sectionType {
//        case .todaysClasses:
//            if gymClassInstances.isEmpty {
//                // swiftlint:disable:next force_cast
//                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.todaysClassesEmptyCellIdentifier, for: indexPath) as! TodaysClassesEmptyCell
//                return cell
//            }
//            // swiftlint:disable:next force_cast
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.todaysClassesListCellIdentifier, for: indexPath) as! TodaysClassesListCell
//            cell.delegate = self
//            cell.configure(for: gymClassInstances)
//            return cell
            
        case .fitnessCenters:
            // swiftlint:disable:next force_cast
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.gymsListCellIdentifier, for: indexPath) as! GymsListCell
            cell.delegate = self

            //MARK: changed self.MyGyms to self.gyms
            cell.configure(for: FitnessCenterManager.shared.getFitnessCenter())
            return cell
//        case .yourActivities:
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.activitiesListCellIdentifier, for: indexPath) as! ActivitiesListCell
//            cell.configure(for: activities)
//            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: HomeSectionHeaderView.identifier,
            for: indexPath
            // swiftlint:disable:next force_cast
            ) as! HomeSectionHeaderView
        let editButtonTitle = ClientStrings.Home.editButton

        switch sections[indexPath.section] {
        case .fitnessCenters:
            headerView.configure(title: sections[indexPath.section].rawValue, buttonTitle: nil, completion: pushGymOnboarding)
//        case .yourActivities:
//            headerView.configure(title: sections[indexPath.section].rawValue, buttonTitle: nil, completion: pushHabitOnboarding)
//        case .todaysClasses:
//            headerView.configure(title: sections[indexPath.section].rawValue, buttonTitle: nil, completion: viewTodaysClasses)
        }
        return headerView
    }
    
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if collectionView != collectionView { return .zero }
        return CGSize(width: collectionView.bounds.width, height: HomeSectionHeaderView.height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width

        switch sections[indexPath.section] {
//        case .todaysClasses:
//            let padding: CGFloat = 20.0
//            let cellWidth = gymClassInstances.isEmpty ? width - 2.0 * padding : width
//            return CGSize(width: cellWidth, height: TodaysClassesListCell.totalHeight)
//        case .yourActivities:
//            let height = ActivitiesListCell.itemHeight
//            return CGSize(width: width, height: height)
        case .fitnessCenters:
            //Height is calculated as item height of every row of 2 cells + minimum line spacing between them + bottom section inset value

            //Height of all cells (in rows of 2), plus line spacings after each of them
            //MARK: myGyms gyms.count and removed / 2
//            var height: CGFloat = (GymsListCell.itemHeight + GymsListCell.minimumItemSpacing) * ceil(CGFloat(integerLiteral: gyms.count))
            var height: CGFloat = (GymsListCell.itemHeight + GymsListCell.minimumItemSpacing) * ceil(CGFloat(integerLiteral: FitnessCenterManager.shared.getFitnessCenter().count))

            //Subtract extra minimum line spacing below the last row of cells, and add the section inset
            height += GymsListCell.sectionInsetBottom - GymsListCell.minimumItemSpacing
            return CGSize(width: width, height: max(height, 0))
        }
    }

    // Don't want the empty state cell to appear selectable, so disable zooming in/out for the empty state cell
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        if !(cell is TodaysClassesEmptyCell) {
            cell.zoomIn()
        }
    }

    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        if !(cell is TodaysClassesEmptyCell) {
            cell.zoomOut()
        }
    }

}

extension HomeViewController: GymsListCellDelegate {

    func allGymsCellShouldOpenGym(_ gym: Gym) {
        let gymDetailViewController = GymDetailViewController(gym: gym)
        navigationController?.pushViewController(gymDetailViewController, animated: true)
    }
}

extension HomeViewController: TodaysClassesListCellDelegate {

    func todaysClassesCellShouldOpenGymClassInstance(_ gymClassInstance: GymClassInstance) {
        let classDetailViewController = ClassDetailViewController(gymClassInstance: gymClassInstance)
        navigationController?.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(classDetailViewController, animated: true)
    }

}

extension HomeViewController: ChooseGymsDelegate {

    func updateFavorites(favorites: [String]) {
//        myGyms = favorites.compactMap { favorite in
//            self.gyms.first { $0.name == favorite }
//        }
    }

    func pushHabitOnboarding() {
        let habitViewController = HabitTrackingController(type: .cardio)
        navigationController?.pushViewController(habitViewController, animated: true)
        return
    }

    func pushGymOnboarding() {
        let onboardingGymsViewController = FavoriteGymsController()
        onboardingGymsViewController.hidesBottomBarWhenPushed = true
        onboardingGymsViewController.delegate = self
        navigationController?.pushViewController(onboardingGymsViewController, animated: true)
    }

    func viewTodaysClasses() {
        guard let classNavigationController = tabBarController?.viewControllers?[1] as? UINavigationController,
            let classListViewController = classNavigationController.viewControllers[0] as? ClassListViewController else {
                return
        }

        classListViewController.updateCalendarDateSelectedToToday()

        tabBarController?.hidesBottomBarWhenPushed = false
        tabBarController?.selectedIndex = 1
        tabBarController?.selectedViewController = classNavigationController
    }
}
