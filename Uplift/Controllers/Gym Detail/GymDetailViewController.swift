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
    private var sections: [ItemType]!

    // MARK: - Public data vars
    var gymDetail: Gym!

    // MARK: - Private classes/enums

    private enum ItemType {
        case hours
        case tabbedController
    }

    // MARK: - Custom Initializer
    init(gym: Gym) {
        super.init(nibName: nil, bundle: nil)
        gymDetail = gym
        sections = [.tabbedController]
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
        return self.sections.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let itemType = sections[indexPath.item]

        switch itemType {
        case .hours:
            // swiftlint:disable:next force_cast
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GymDetailHoursCell.reuseId, for: indexPath) as! GymDetailHoursCell
            cell.configure(for: self, hours: gymDetail.hours, isDisclosed: gymDetail.hoursIsDisclosed)
            return cell

        case .tabbedController:
            // swiftlint:disable:next force_cast
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GymDetailTabbedControllerCell.reuseId, for: indexPath) as! GymDetailTabbedControllerCell
            cell.configure(fitnessCenters: gymDetail.fitnessCenters)
            cell.delegate = self
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height: CGFloat

        switch sections[indexPath.item] {
        case .hours:
            height = GymDetailHoursCell.getHeight(isDisclosed: gymDetail.hoursIsDisclosed, numLines: gymDetail.hours.getNumHoursLines())
        case .tabbedController:
            height = GymDetailTabbedControllerCell.getHeight(fitnessCenters: gymDetail.fitnessCenters[gymDetail.currentDisplayedFitnessCenter], viewWidt: self.view.frame.width)
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
        return CGSize(width: collectionView.frame.width, height: 300)
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
        collectionView.register(GymDetailTabbedControllerCell.self, forCellWithReuseIdentifier: GymDetailTabbedControllerCell.reuseId)

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

// MARK: - Extensions
extension GymDetailViewController: GymDetailHoursCellDelegate {

    func didDropHours(isDropped: Bool, completion: @escaping () -> Void) {
        gymDetail.hoursIsDisclosed.toggle()
        collectionView.performBatchUpdates({}, completion: nil)
        completion()
    }

}

extension GymDetailViewController: GymDetailTabbedControllerCellDelegate {
    func didMoveTo(index: Int, completion: @escaping () -> Void) {
        gymDetail.currentDisplayedFitnessCenter = index
        collectionView.performBatchUpdates({}, completion: nil)
        completion()
    }

    func didChangeSize(completion: @escaping () -> Void) {
        collectionView.performBatchUpdates({}, completion: nil)
        completion()
    }
}

extension GymDetailViewController: GymDetailHeaderViewDelegate {

    func gymDetailHeaderViewBackButtonTapped() {
        back()
    }

}
