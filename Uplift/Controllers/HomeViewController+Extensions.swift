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
        case .checkIns:
            // swiftlint:disable:next force_cast
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.checkInsListCellIdentifier, for: indexPath) as! CheckInsListCell
            cell.configure(for: habits)
            return cell
        case .allGyms:
            // swiftlint:disable:next force_cast
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.gymsListCellIdentifier, for: indexPath) as! GymsListCell
            cell.delegate = self
            cell.configure(for: self.favoriteGyms)
            return cell
        case .todaysClasses:
            // swiftlint:disable:next force_cast
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.todaysClassesListCellIdentifier, for: indexPath) as! TodaysClassesListCell
            cell.delegate = self
            cell.configure(for: gymClassInstances)
            return cell
        default:
            // swiftlint:disable:next force_cast
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.prosListCellIdentifier, for: indexPath) as! ProsListCell
            cell.delegate = self
            cell.configure(for: pros)
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        // swiftlint:disable:next force_cast
        let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: HomeSectionHeaderView.identifier,
            for: indexPath
            ) as! HomeSectionHeaderView
        let editButtonTitle = "edit"

        switch sections[indexPath.section] {
        case .checkIns:
            headerView.configure(title: sections[indexPath.section].rawValue, buttonTitle: editButtonTitle, completion: pushHabitOnboarding)
        case .allGyms:
            headerView.configure(title: sections[indexPath.section].rawValue, buttonTitle: editButtonTitle, completion: pushGymOnboarding)
        case .pros:
            headerView.configure(title: sections[indexPath.section].rawValue, buttonTitle: nil, completion: nil)
        case .todaysClasses:
            headerView.configure(title: sections[indexPath.section].rawValue, buttonTitle: "view all", completion: viewTodaysClasses)
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
        case .checkIns:
            let checkInListItemCellHeight = 53
            let checkInListHeight = checkInListItemCellHeight * habits.count
            let bottomSectionInset = 32
            return CGSize(width: width, height: CGFloat(checkInListHeight + bottomSectionInset))
        case .allGyms:
            return CGSize(width: width, height: 123)
        case .pros:
            return CGSize(width: width, height: 145)
        case .todaysClasses:
            return CGSize(width: width, height: 227)
        }
    }

    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        cell.zoomIn()
    }

    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        cell.zoomOut()
    }

}

extension HomeViewController: GymsListCellDelegate {

    func allGymsCellShouldOpenGym(_ gym: Gym) {
        let gymDetailViewController = GymDetailViewController()
        gymDetailViewController.gym = gym
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

extension HomeViewController: ProsListCellDelegate {

    func prosListCellShouldOpenProBio(_ proBio: ProBio) {
        let proDetailViewController = ProBioViewController(pro: proBio)
        navigationController?.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(proDetailViewController, animated: true)
    }

}

extension HomeViewController: ChooseGymsDelegate {

    func updateFavorites(favorites: [String]) {
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
    }

    func viewTodaysClasses() {
        guard let classNavigationController = tabBarController?.viewControllers?[1] as? UINavigationController,
            let classListViewController = classNavigationController.viewControllers[0] as? ClassListViewController else {
                return
        }

        classListViewController.updateCalendarDateSelectedToToday()

        classNavigationController.setViewControllers([classListViewController], animated: false)
        tabBarController?.hidesBottomBarWhenPushed = false
        tabBarController?.selectedIndex = 1
    }

}